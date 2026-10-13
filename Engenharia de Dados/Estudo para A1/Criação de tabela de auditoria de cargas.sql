USE DataCommerce;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.schemas
	WHERE NAME = 'staging'
)
BEGIN
	EXEC('CREATE SCHEMA staging'); -- Precisa estar em EXEC, pois o schema precisa ser o primeiro comando.
END;
GO

--

IF OBJECT_ID ('staging.clientes_csv') IS NOT NULL
	DROP TABLE staging.clientes_csv;
GO

CREATE TABLE staging.clientes_csv
(
	cliente_id	NVARCHAR(50),
	nome		NVARCHAR(200),
	email		NVARCHAR(200),
	cidade		NVARCHAR(100),
	uf			NVARCHAR(10),
	data_cadastro NVARCHAR(50),
	ativo		NVARCHAR(10)
);
GO

/*
Pergunta clássica de prova:

Por que receber tudo como texto?

Resposta:

Porque a staging deve refletir fielmente o dado recebido da origem, 
permitindo validações posteriores sem perda de informação.
*/

-- Se fizer cagada:

TRUNCATE TABLE staging.clientes_csv;
GO

-- Carga CSV

BULK INSERT staging.clientes_csv
FROM '/var/opt/mssql/import/clientes_100.csv'
WITH
(
	FIRSTROW = 2, -- Pula o cabeçalho/nome das colunas.
	FIELDTERMINATOR = ';', -- O separador de cada coluna
	ROWTERMINATOR = '0x0D0A', -- Quebra de linha
	CODEPAGE = 'RAW' -- UTF-8 com BOM
)
GO

-- Conferência

SELECT COUNT(*)
FROM staging.clientes_csv;

-- Primeira validação

SELECT *
FROM staging.clientes_csv
WHERE
	email IS NULL
	OR LTRIM(RTRIM(email)) = '';

-- Segunda validação

SELECT *
FROM staging.clientes_csv
WHERE uf NOT IN
(
	'SP',
	'RJ',
	'MG',
	'PR',
	'BA',
	'PE',
	'DF'
);

-- Terceira validação

SELECT * FROM staging.clientes_csv
WHERE
	TRY_CONVERT
	(
		DATE,
		data_cadastro,
		23
	) IS NULL;

-- Quarta validação

SELECT
	email,
	COUNT(*) AS quantidade
FROM staging.clientes_csv
GROUP BY email
HAVING COUNT(*) > 1;

--

-- Quinta validação

SELECT *
FROM staging.clientes_csv
WHERE nome <> LTRIM(RTRIM(nome));