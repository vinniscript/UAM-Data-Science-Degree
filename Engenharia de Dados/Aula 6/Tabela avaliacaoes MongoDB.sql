USE DataCommerce;
GO

IF OBJECT_ID
(
	N'staging.avaliacoes_mongodb',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE staging.avaliacoes_mongodb
	(
		cliente_email NVARCHAR(160) NULL,

		canal NVARCHAR(40) NULL,

		nota INT NULL,

		comentario NVARCHAR(500) NULL,

		origem_arquivo NVARCHAR(200) NULL,

		data_carga DATETIME2 NOT NULL
		CONSTRAINT DF_avaliacoes_mongodb_data_carga
		DEFAULT SYSDATETIME()
	);
END;
GO

-- Por ser no schema staging, vamos aceitar NULL e ir tratando os casos.

SELECT
    ORDINAL_POSITION AS posicao,

    COLUMN_NAME AS coluna,

    DATA_TYPE AS tipo,

    CHARACTER_MAXIMUM_LENGTH AS tamanho,

    IS_NULLABLE AS aceita_null,

    COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'staging'
  AND TABLE_NAME = N'avaliacoes_mongodb'
ORDER BY ORDINAL_POSITION;

-- Antes de user o BULK INSERT oficial, vamos confirmar que a estrutura relacional representa corretamente os documentos.

IF NOT EXISTS
(
	SELECT 1
	FROM staging.avaliacoes_mongodb
)
BEGIN
	INSERT INTO staging.avaliacoes_mongodb
	(
		cliente_email,
		canal,
		nota,
		comentario,
		origem_arquivo
	)
	VALUES
	(
		N'ana@datacommerce.com',
		N'app',
		5,
		N'Entrega rápida',
		N'avaliacoes_mongodb.csv'
	),
	(
		N'bruno@datacommerce.com',
		N'site',
		3,
		N'Preço alto',
		N'avaliacoes_mongodb.csv'
	);
END;
GO

-- Consultando a staging

SELECT
    cliente_email,
    canal,
    nota,
    comentario,
    origem_arquivo, -- metadado
    data_carga -- metadado
FROM staging.avaliacoes_mongodb
ORDER BY cliente_email;

-- VALIDAÇÕES: quantidade recebida

SELECT
	COUNT(*) AS total_avaliacoes
FROM staging.avaliacoes_mongodb;

-- MÉDIA por canal

SELECT
	canal,

	AVG
	(
		CONVERT
		(
			DECIMAL(10,2),
			nota
		)
	) AS media_nota,

	COUNT(*) AS total
FROM staging.avaliacoes_mongodb
GROUP BY canal
ORDER BY media_nota DESC;

-- Avaliações com notas ausentes

SELECT
	cliente_email,
	canal,
	comentario
FROM staging.avaliacoes_mongodb
WHERE nota IS NULL;

-- Notas fora da faixa esperada

SELECT
	cliente_email,
	canal,
	comentario
FROM staging.avaliacoes_mongodb
WHERE nota < 1
   OR nota > 5;

DECLARE @ArquivoExiste INT;

EXEC master.dbo.xp_fileexist
	N'/var/opt/mssql/import/avaliacoes_mongodb.csv',
	@ArquivoExiste OUTPUT;

SELECT 
	@ArquivoExiste AS arquivo_existe;

-- Inserindo o arquivo

BULK INSERT staging.avaliacoes_mongodb
FROM '/var/opt/mssql/import/avaliacoes_mongodb.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '0X0a' --,
	-- CODEPAGE = 65001 ;; Se eu não estivesse rodando num docker, isso aqui ia ser necessário
);

USE DataCommerce;
GO

IF OBJECT_ID
(
    N'staging.avaliacoes_mongodb_importacao',
    N'U'
) IS NULL
BEGIN
    CREATE TABLE staging.avaliacoes_mongodb_importacao -- Para bater como arquivo da aula. A IA criou além
    (
        cliente_email NVARCHAR(160) NULL,
        canal NVARCHAR(40) NULL,
        nota INT NULL,
        comentario NVARCHAR(500) NULL
    );
END;
GO

TRUNCATE TABLE staging.avaliacoes_mongodb_importacao;
GO

-- Executando agora novamente na nova tabela com as 4 colunas que condizem com o .csv

BEGIN TRY

	BEGIN TRANSACTION;

	BULK INSERT staging.avaliacoes_mongodb_importacao
	FROM '/var/opt/mssql/import/avaliacoes_mongodb.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		DATAFILETYPE = 'char'
	);
	
	COMMIT;

END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK;
	END;

	SELECT
		ERROR_NUMBER(),
		ERROR_MESSAGE()

END CATCH;
GO

-- Conferimento

SELECT
    cliente_email,
    canal,
    nota,
    comentario
FROM staging.avaliacoes_mongodb_importacao
ORDER BY cliente_email;

-- Verificar possível carriage return

/*
Como o arquivo veio do Windows, a última coluna pode terminar com o caractere invisível CHAR(13).
*/

SELECT
    cliente_email,
    comentario,
    LEN(comentario) AS tamanho_visivel,
    DATALENGTH(comentario) AS tamanho_bytes,
    UNICODE
    (
        RIGHT
        (
            comentario,
            1
        )
    ) AS codigo_ultimo_caractere
FROM staging.avaliacoes_mongodb_importacao;

-- Transferir para a staging final
-- evitando duplicatas
INSERT INTO staging.avaliacoes_mongodb
(
    cliente_email,
    canal,
    nota,
    comentario,
    origem_arquivo
)
SELECT
    LTRIM
    (
        RTRIM
        (
            i.cliente_email
        )
    ),

    LTRIM
    (
        RTRIM
        (
            i.canal
        )
    ),

    i.nota,

    LTRIM
    (
        RTRIM
        (
            REPLACE
            (
                i.comentario,
                CHAR(13),
                N''
            )
        )
    ),

    N'avaliacoes_mongodb.csv'

FROM staging.avaliacoes_mongodb_importacao AS i

WHERE NOT EXISTS
(
    SELECT 1
    FROM staging.avaliacoes_mongodb AS d
    WHERE d.cliente_email =
          LTRIM
          (
              RTRIM
              (
                  i.cliente_email
              )
          )
      AND d.canal =
          LTRIM
          (
              RTRIM
              (
                  i.canal
              )
          )
      AND d.nota = i.nota
      AND d.comentario =
          LTRIM
          (
              RTRIM
              (
                  REPLACE
                  (
                      i.comentario,
                      CHAR(13),
                      N''
                  )
              )
          )
);
GO

SELECT
    cliente_email,
    canal,
    nota,
    comentario,
    origem_arquivo,
    data_carga
FROM staging.avaliacoes_mongodb
ORDER BY cliente_email;

-- Consertando os caracteres especiais bugados
    -- O arquivo precisa estar com o enconding BOM do UTF-16LE

TRUNCATE TABLE staging.avaliacoes_mongodb_importacao;
GO

BEGIN TRY

    BEGIN TRANSACTION;

    BULK INSERT staging.avaliacoes_mongodb_importacao
    FROM '/var/opt/mssql/import/avaliacoes_mongodb_utf16_bom.csv'
    WITH -- Padrões linux (contêiner docker)
    (
        DATAFILETYPE = 'widechar',
        FIRSTROW = 2,
        FIELDTERMINATOR = '0x3B00',
        ROWTERMINATOR = '0x0A00'
    );

    COMMIT;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END;

    SELECT
        ERROR_NUMBER() AS numero_erro,
        ERROR_MESSAGE() AS mensagem_erro;

END CATCH;
GO

SELECT
    cliente_email,
    canal,
    nota,
    comentario
FROM staging.avaliacoes_mongodb_importacao
ORDER BY cliente_email;

SELECT
    cliente_email,
    comentario,
    LEN(comentario) AS tamanho_visivel,
    DATALENGTH(comentario) AS tamanho_bytes
FROM staging.avaliacoes_mongodb_importacao
ORDER BY cliente_email;

BEGIN TRY

    BEGIN TRANSACTION;

    TRUNCATE TABLE staging.avaliacoes_mongodb;

    INSERT INTO staging.avaliacoes_mongodb
    (
        cliente_email,
        canal,
        nota,
        comentario,
        origem_arquivo
    )
    SELECT
        LTRIM(RTRIM(cliente_email)),
        LTRIM(RTRIM(canal)),
        nota,
        LTRIM
        (
            RTRIM
            (
                REPLACE
                (
                    comentario,
                    NCHAR(13),
                    N''
                )
            )
        ),
        N'avaliacoes_mongodb.csv'
    FROM staging.avaliacoes_mongodb_importacao;

    DECLARE @LinhasGravadas INT;

    SET @LinhasGravadas = @@ROWCOUNT;

    IF @LinhasGravadas <> 2
    BEGIN
        THROW 50021,
              N'A transferência deveria gravar exatamente duas avaliações.',
              1;
    END;

    COMMIT;

    SELECT
        @LinhasGravadas AS linhas_gravadas;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END;

    SELECT
        ERROR_NUMBER() AS numero_erro,
        ERROR_MESSAGE() AS mensagem_erro;

END CATCH;
GO

SELECT
    cliente_email,
    canal,
    nota,
    comentario,
    origem_arquivo,
    data_carga
FROM staging.avaliacoes_mongodb
ORDER BY cliente_email;

SELECT
    COUNT(*) AS total_avaliacoes
FROM staging.avaliacoes_mongodb;