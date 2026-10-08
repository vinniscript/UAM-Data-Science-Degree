DECLARE @ArquivoExiste INT;

EXEC master.dbo.xp_fileexist
	N'/var/opt/mssql/import/atendimentos.json',
	@ArquivoExiste OUTPUT;

SELECT
	@ArquivoExiste AS arquivo_existe;

-- Já salvamos no docker o .JSON e validamos que o banco o acessa.

-- Agora vamos lê-lo sem criar tabelas

DECLARE @json NVARCHAR(MAX)

SELECT
	@json = CONVERT
	(
		NVARCHAR(MAX),
		BulkColumn
	)
FROM OPENROWSET
(
	BULK '/var/opt/mssql/import/atendimentos.json',
	SINGLE_CLOB /*SINGLE_CLOB lê o conteúdo como uma única linha e coluna do tipo VARCHAR(MAX). Para conteúdo Unicode, SINGLE_NCLOB produz NVARCHAR(MAX).
Como o arquivo provavelmente está em UTF-8, primeiro testaremos o comportamento real de SINGLE_CLOB.*/
) AS fonte;

SELECT
	ISJSON(@json) AS json_valido;

-- Visualizar os atendimentos

SELECT
	atendimento_id,
	cliente_email,
	canal,
	assunto,
	nota
FROM OPENJSON(@json)
WITH
(
	atendimento_id INT '$.atendimento_id',
	cliente_email NVARCHAR(160) '$.cliente_email',
	canal NVARCHAR(40) '$.canal',
	assunto NVARCHAR(80) '$.assunto',
	nota INT '$.nota'
);

-- Criar a tabela

USE DataCommerce;
GO

IF OBJECT_ID
(
    N'staging.atendimentos_json',
    N'U'
) IS NULL
BEGIN
    CREATE TABLE staging.atendimentos_json
    (
        atendimento_id INT NULL,

        cliente_email NVARCHAR(160) NULL,

        canal NVARCHAR(40) NULL,

        assunto NVARCHAR(80) NULL,

        nota INT NULL,

        arquivo_origem NVARCHAR(200) NULL,

        data_carga DATETIME2 NOT NULL
            CONSTRAINT DF_atendimentos_json_data_carga
            DEFAULT SYSDATETIME()
    );
END;
GO

-- Validar a estrutura

SELECT
    ORDINAL_POSITION AS posicao,
    COLUMN_NAME AS coluna,
    DATA_TYPE AS tipo,
    CHARACTER_MAXIMUM_LENGTH AS tamanho,
    IS_NULLABLE AS aceita_null,
    COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'staging'
  AND TABLE_NAME = N'atendimentos_json'
ORDER BY ORDINAL_POSITION;

-- Carregar JSON

BEGIN TRY
	
	BEGIN TRANSACTION;

	TRUNCATE TABLE staging.atendimentos_json;

	DECLARE @json NVARCHAR(MAX);

	SELECT
		@json = CONVERT
		(
			NVARCHAR(MAX),
			BulkColumn
		)
	FROM OPENROWSET
	(
		BULK '/var/opt/mssql/import/atendimentos.json',
		SINGLE_CLOB
	) AS fonte;

	IF ISJSON(@json) <> 1
	BEGIN
		THROW 50040,
			N'O arquivo contém JSON inválido',
			1;
	END;

	INSERT INTO staging.atendimentos_json
	(
		atendimento_id,
		cliente_email,
		canal,
		assunto,
		nota,
		arquivo_origem
	)
	SELECT
		atendimento_id,

		LOWER(LTRIM(RTRIM(cliente_email))),
		LOWER(LTRIM(RTRIM(canal))),
		LOWER(LTRIM(RTRIM(assunto))),

		nota,

		N'atendimentos.json'
	FROM OPENJSON(@json)
	WITH
	(
		atendimento_id INT '$.atendimento_id',
		cliente_email NVARCHAR(160) '$.cliente_email',
		canal NVARCHAR(40) '$.canal',
		assunto NVARCHAR(80) '$.assunto',
		nota INT '$.nota'
	);

	DECLARE @LinhasGravadas INT;

	SET @LinhasGravadas = @@ROWCOUNT;

	IF @LinhasGravadas <> 6
	BEGIN
		THROW 50041,
			N'A carga deveria gravar exatamente seis atendimentos',
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
		ERROR_NUMBER(),
		ERROR_MESSAGE()
END CATCH;
GO

-- Validando a carga

SELECT
    atendimento_id,
    cliente_email,
    canal,
    assunto,
    nota,
    arquivo_origem,
    data_carga
FROM staging.atendimentos_json
ORDER BY atendimento_id;

-- Validações de qualidade

SELECT
    atendimento_id,
    cliente_email,
    canal,
    assunto,
    nota
FROM staging.atendimentos_json
WHERE cliente_email IS NULL
   OR LTRIM(RTRIM(cliente_email)) = N''
   OR canal IS NULL
   OR LTRIM(RTRIM(canal)) = N''
   OR nota IS NULL;

-- Notas fora da faixa

SELECT
	atendimento_id,
	cliente_email,
	nota
FROM staging.atendimentos_json
WHERE nota < 1
   OR nota > 5;

-- Indicador por canal

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

	COUNT(*) AS total_atendimentos
FROM staging.atendimentos_json
GROUP BY canal
ORDER BY media_nota DESC;

SELECT
	N'clientes_csv' AS estrutura,
	COUNT(*) AS total
FROM staging.clientes_csv

UNION ALL

SELECT
	N'vendas_csv',
	COUNT(*)
FROM staging.vendas_csv

UNION ALL

SELECT
	N'vendas_tratadas',
	COUNT(*)
FROM staging.vendas_tratadas

UNION ALL

SELECT
	N'metas_excel',
	COUNT(*)
FROM staging.metas_excel

UNION ALL

SELECT
	N'atendimentos_json',
	COUNT(*)
FROM staging.atendimentos_json

UNION ALL

SELECT
	N'avaliacoes_mongodb',
	COUNT(*)
FROM staging.avaliacoes_mongodb;