USE DataCommerce;
GO

IF OBJECT_ID
(
	N'staging.produtos_xml',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE staging.produtos_xml
	(
		sku NVARCHAR(30) NOT NULL,

		produto NVARCHAR(120) NOT NULL,

		preco DECIMAL(18,2) NOT NULL,

		arquivo_origem NVARCHAR(200) NOT NULL,

		data_carga DATETIME2 NOT NULL
			CONSTRAINT DF_produtos_xml_data_carga
				DEFAULT SYSDATETIME(),

		CONSTRAINT CK_produtos_xml_preco
			CHECK (preco > 0)
	);
END;
GO

SELECT 
	ORDINAL_POSITION AS posicao,
	COLUMN_NAME AS coluna,
	DATA_TYPE AS tipo,
	CHARACTER_MAXIMUM_LENGTH AS tamanho,
	NUMERIC_PRECISION AS precisao,
	NUMERIC_SCALE AS escala,
	IS_NULLABLE AS aceita_null,
	COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'staging'
  AND TABLE_NAME = 'produtos_xml'

-- Carga transacional

BEGIN TRY

    BEGIN TRANSACTION;

    TRUNCATE TABLE staging.produtos_xml;

    DECLARE @xml XML;

    SELECT
        @xml = TRY_CAST
        (
            BulkColumn AS XML
        )
    FROM OPENROWSET
    (
        BULK '/var/opt/mssql/import/produtos.xml',
        SINGLE_BLOB
    ) AS fonte;

    IF @xml IS NULL
    BEGIN
        THROW 50050,
              N'O arquivo produtos.xml não contém XML válido.',
              1;
    END;

    INSERT INTO staging.produtos_xml
    (
        sku,
        produto,
        preco,
        arquivo_origem
    )
    SELECT
        LTRIM
        (
            RTRIM
            (
                p.value
                (
                    '(sku/text())[1]',
                    'nvarchar(30)'
                )
            )
        ),

        LTRIM
        (
            RTRIM
            (
                p.value
                (
                    '(nome/text())[1]',
                    'nvarchar(120)'
                )
            )
        ),

        p.value
        (
            '(preco/text())[1]',
            'decimal(18,2)'
        ),

        N'produtos.xml'

    FROM @xml.nodes
    (
        '/produtos/produto'
    ) AS T(p)

    WHERE p.value
          (
              '(sku/text())[1]',
              'nvarchar(30)'
          ) <> N''

      AND p.value
          (
              '(nome/text())[1]',
              'nvarchar(120)'
          ) <> N''

      AND p.value
          (
              '(preco/text())[1]',
              'decimal(18,2)'
          ) > 0;

    DECLARE @LinhasGravadas INT;

    SET @LinhasGravadas = @@ROWCOUNT;

    IF @LinhasGravadas = 0
    BEGIN
        THROW 50051,
              N'Nenhum produto válido foi carregado.',
              1;
    END;

    INSERT INTO auditoria.log_etl
    (
        processo,
        fonte,
        destino,
        status,
        linhas_lidas,
        linhas_gravadas,
        mensagem,
        fim
    )
    VALUES
    (
        N'Carga produtos.xml',
        N'produtos.xml',
        N'staging.produtos_xml',
        N'SUCESSO',
        @LinhasGravadas,
        @LinhasGravadas,
        N'Carga XML via OPENROWSET, nodes e value',
        SYSDATETIME()
    );

    COMMIT;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END;

    INSERT INTO auditoria.log_etl
    (
        processo,
        fonte,
        destino,
        status,
        linhas_lidas,
        linhas_gravadas,
        mensagem,
        fim
    )
    VALUES
    (
        N'Carga produtos.xml',
        N'produtos.xml',
        N'staging.produtos_xml',
        N'ERRO',
        NULL,
        0,
        ERROR_MESSAGE(),
        SYSDATETIME()
    );

    SELECT
        ERROR_NUMBER() AS numero_erro,
        ERROR_MESSAGE() AS mensagem_erro;

END CATCH;

-- Validar produtos carregados

SELECT
    sku,
    produto,
    preco,
    arquivo_origem,
    data_carga
FROM staging.produtos_xml
ORDER BY sku;

-- Quantidade

SELECT
    COUNT(*) AS total_produtos
FROM staging.produtos_xml;

-- Registro em auditoria.log_etl

DECLARE @Linhas INT;

SELECT
	@Linhas = COUNT(*)
FROM staging.produtos_xml;

INSERT INTO auditoria.log_etl
(
	processo,
	fonte,
	destino,
	status,
	linhas_lidas,
	linhas_gravadas,
	mensagem,
	fim
)
VALUES
(
	N'Carga produtos.xml',
	N'produtos.xml',
	N'staging.produtos_xml',
	N'SUCESSO',
	@Linhas,
	@Linhas,
	N'Carga XML via OPENWORSET, nodes e value',
	SYSDATETIME()
);
GO

-- Consultar log inserido

SELECT TOP 10
    log_id,
    processo,
    fonte,
    destino,
    status,
    linhas_lidas,
    linhas_gravadas,
    mensagem,
    inicio,
    fim
FROM auditoria.log_etl
ORDER BY log_id DESC;


/*
Por que o log de erro fica depois do ROLLBACK?

Se fizéssemos:

INSERT do log de erro
ROLLBACK
 

o rollback apagaria o próprio registro de erro.

Por isso, a sequência correta no CATCH é:

1. Desfazer a transação
2. Registrar o erro fora da transação desfeita
*/

SELECT
    N'CSV de clientes' AS carga,
    N'BULK INSERT' AS mecanismo,
    COUNT(*) AS linhas
FROM staging.clientes_csv

UNION ALL

SELECT
    N'Metas do Excel',
    N'Excel representado em staging',
    COUNT(*)
FROM staging.metas_excel

UNION ALL

SELECT
    N'Atendimentos JSON',
    N'OPENROWSET + OPENJSON',
    COUNT(*)
FROM staging.atendimentos_json

UNION ALL

SELECT
    N'Avaliações MongoDB',
    N'CSV + BULK INSERT',
    COUNT(*)
FROM staging.avaliacoes_mongodb

UNION ALL

SELECT
    N'Produtos XML',
    N'OPENROWSET + XML nodes',
    COUNT(*)
FROM staging.produtos_xml;