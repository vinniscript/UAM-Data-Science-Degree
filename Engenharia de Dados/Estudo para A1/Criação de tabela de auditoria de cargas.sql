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

-- Carga CSV

BULK INSERT staging.clientes_csv
FROM '/var/opt/mssql/import/clientes_100.csv'
WITH
(
	FIRSTROW = 2, -- Pula o cabeçalho/nome das colunas.
	FIELDTERMINATOR = ';', -- O separador de cada coluna
	ROWTERMINATOR = '0x0A', -- Quebra de linha
	CODEPAGE = 'RAW' -- UTF-8 com BOM
)
GO

 

