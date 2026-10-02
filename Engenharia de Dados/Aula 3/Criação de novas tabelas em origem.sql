-- Tabela clientes no schema origem
USE DataCommerce;
GO

IF OBJECT_ID(N'origem.clientes', N'U') IS NULL
BEGIN
	CREATE TABLE origem.clientes
	(
		cliente_id INT IDENTITY(1,1) NOT NULL,
		nome NVARCHAR(120) NOT NULL,
		email NVARCHAR(160) NOT NULL,
		uf CHAR(2) NULL,
		
		data_cadastro DATE NOT NULL
			CONSTRAINT DF_clientes_data_cadastro
			DEFAULT CONVERT(date, GETDATE()),

		CONSTRAINT PK_clientes
			PRIMARY KEY (cliente_id),

		CONSTRAINT UQ_clientes_email
			UNIQUE (email)
	);
END;
GO


-- Tabela produtos no schema origem

IF OBJECT_ID(N'origem.produtos', N'U') IS NULL
BEGIN
	CREATE TABLE origem.produtos
	(
		produto_id INT IDENTITY(1,1) NOT NULL,
		sku NVARCHAR(30) NOT NULL,
		produto NVARCHAR(120) NOT NULL,
		categoria NVARCHAR(80) NULL,
		preco DECIMAL(18,2) NOT NULL,

		-- Colunas primeiro, Constraints depois, é uma boa forma de se organizar.

		CONSTRAINT PK_produtos -- É a mesma coisa que apenas definir um Primary Key, porém agora nominalmente e de forma mais organizável e controlável
			PRIMARY KEY (produto_id),

		CONSTRAINT UQ_produtos_sku
			UNIQUE (SKU),

		CONSTRAINT CK_produtos_preco
			CHECK (preco >= 0)
	);
END;
GO

/*
O material usa regras sem nomes explícitos:

email NVARCHAR(160) NOT NULL UNIQUE

preco DECIMAL(18,2) NOT NULL CHECK (preco >= 0)

Isso funciona, mas o SQL Server gera nomes automáticos para algumas constraints.

Para administração e troubleshooting, prefiro nomes explícitos:

PK_clientes
UQ_clientes_email
DF_clientes_data_cadastro
PK_produtos
UQ_produtos_sku
CK_produtos_preco

O prefixo comunica o tipo:

PK = Primary Key
FK = Foreign Key
UQ = Unique
CK = Check
DF = Default

Esses prefixos são convenções de nomenclatura, não palavras obrigatórias do SQL Server.

É uma boa prática.
*/

SELECT
	s.name AS schema_nome,
	t.name AS tabela_nome
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
WHERE s.name = N'origem'
  AND t.name IN
  (
	  N'clientes',
	  N'produtos'
  )
ORDER BY t.name;

--

SELECT
	TABLE_NAME AS tablea,
	ORDINAL_POSITION AS posicao,
	COLUMN_NAME AS coluna,
	DATA_TYPE AS tipo,
	CHARACTER_MAXIMUM_LENGTH AS tamanho_texto,
	NUMERIC_PRECISION AS precisao,
	NUMERIC_SCALE AS escala,
	IS_NULLABLE AS nullavel
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'origem'
  AND TABLE_NAME IN
  (
	  N',clientes',
	  N'produtos'
  )
ORDER BY
	TABLE_NAME,
	ORDINAL_POSITION;	

-- Validando constraints

SELECT
	t.name AS tabela,
	o.name AS constraint_nome,
	o.type_desc AS contraint_tipo
FROM sys.objects AS o
INNER JOIN sys.tables AS t
	ON t.object_id = o.parent_object_id
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
WHERE s.name = N'origem'
  AND t.name IN
  (
	  N'clientes',
	  N'produtos'
  )
  AND o.type IN
  (
	  N'PK',
	  N'UQ',
	  N'C',
	  N'D'
  )
  ORDER BY
	t.name,
	o.type_desc,
	o.name;