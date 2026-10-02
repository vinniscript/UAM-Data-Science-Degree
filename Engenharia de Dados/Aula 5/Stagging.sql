USE DataCommerce;
-- Validação de usuário e banco
SELECT
	DB_NAME() AS banco_atual,
	SUSER_SNAME() AS usuario_atual;
GO

-- Vendo as tabelas de auditoria e staging

SELECT
	s.name AS schema_nome,
	t.name AS tabela_nome
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
WHERE s.name IN 
(
	N'staging',
	N'auditoria'
)
ORDER BY
	s.name,
	t.name;

-- Checando se staging existe

SELECT
	name AS schema_nome,
	schema_id
FROM sys.schemas
WHERE name = N'staging';

-- Criando de forma segura

IF SCHEMA_ID(N'staging') IS NULL
BEGIN
	EXEC
	(
		N'CREATE SCHEMA staging AUTHORIZATION dbo;'-- EXEC isola o comando em um novo lote para evitar o erro de sintaxe do CREATE SCHEMA dentro de IF
	); -- O SQL Server tem uma parada chata com CREATE, pois ele fala que precisa ser o primeiro comando do lote.
	-- Esse EXEC cria um contexto diferente, onde o SQL server entende ser um lote novo. Dai ele executa lá, caso seja NULL. Não parando a query
END;
GO

-- Criando a tabela (de forma segura)

USE DataCommerce;
GO

IF OBJECT_ID
(
	N'staging.clientes_csv',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE staging.clientes_csv
	(
		nome NVARCHAR(120) NULL,

		email NVARCHAR (160) NULL,

		cpf NVARCHAR (80) NULL,

		cidade NVARCHAR (80) NULL,

		uf NVARCHAR (10) NULL
	);
END;
GO

-- Validando criação

SELECT
	s.name AS schema_nome,
	t.name AS tabela_nome
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
WHERE s.name = N'staging'
  AND t.name = N'clientes_csv';
GO

-- Validação das propriedades

SELECT
	ORDINAL_POSITION AS posicao,
	COLUMN_NAME AS coluna,
	DATA_TYPE AS tipo,
	CHARACTER_MAXIMUM_LENGTH AS tamanho,
	IS_NULLABLE AS aceita_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'clientes_csv'
  AND TABLE_SCHEMA = N'staging';

-- Simulando uma fonte externa

IF NOT EXISTS
(
    SELECT 1
    FROM staging.clientes_csv
)
BEGIN
    INSERT INTO staging.clientes_csv
    (
        nome,
        email,
        cpf,
        cidade,
        uf
    )
    VALUES
    (
        N'Ana Silva',
        N'ana@datacommerce.com',
        N'12345678900',
        N'São Paulo',
        N'SP'
    ),
    (
        N'Bruno Lima',
        N'bruno@datacommerce.com',
        N'98765432100',
        N'Rio de Janeiro',
        N'RJ'
    ),
    (
        N'Cliente Ruim',
        NULL,
        N'11122233344',
        N'Cidade Teste',
        N'XX'
    ),
    (
        N'Carla Souza',
        N' carla@datacommerce.com ',
        N'444.555.666-77',
        N'Belo Horizonte',
        N'MG'
    ),
    (
        N'Cliente Sem Cidade',
        N'vazio@datacommerce.com',
        N'55566677788',
        NULL,
        N'SP'
    );
END;
GO

SELECT
    nome,
    email,
    cpf,
    cidade,
    uf
FROM staging.clientes_csv;

-- Quantidade total

SELECT
    COUNT(*) AS total_linhas
FROM staging.clientes_csv;

-- Amostra de 20

SELECT TOP 20
    nome,
    email,
    cpf,
    cidade,
    uf
FROM staging.clientes_csv;

-- E-mails ausentes ou inválidos

SELECT
    nome,
    email
FROM staging.clientes_csv
WHERE email IS NULL
   OR LTRIM(RTRIM(email))= N''; -- Tirando os espaços, verifica se está tudo bem branco, ou há caracteres.

-- E-mails com espaços nas extremidades

SELECT
    nome,
    email,
    LTRIM(RTRIM(email)) AS email_sem_espacos
FROM staging.clientes_csv
WHERE email IS NOT NULL
  AND email <> LTRIM(RTRIM(email));

-- Cidades ausentes

SELECT
    nome,
    cidade
FROM staging.clientes_csv
WHERE cidade IS NULL OR LTRIM(RTRIM(cidade)) = N'';
