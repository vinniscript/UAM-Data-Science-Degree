-- Adicionando colunas

ALTER TABLE origem.clientes
ADD ativo BIT NOT NULL DEFAULT 1; -- Adicione uma coluna (ADD) com o nome 'ativo', binária, não-nula com valor padrão de 1

-- Como a nova coluna é NOT NULL, as linhas antigas não podem ficar sem valor, então usa-se o DEFAULT

ALTER TABLE origem.produtos
ADD data_criacao DATETIME2 NOT NULL DEFAULT SYSDATETIME();

/*

Ponto importante

Notebook e Mouse já existiam antes da coluna.

Logo, a data aplicada a eles representa aproximadamente:

momento em que a coluna foi adicionada

Não necessariamente:

momento histórico original em que os produtos foram cadastrados

*/

-- Versão segura e reexecutável

USE DataCommerce;
GO

IF COL_LENGTH
(
	N'origem.clientes',
	N'ativo'
) IS NULL
BEGIN
	ALTER TABLE origem.clientes
	ADD ativo BIT NOT NULL
		CONSTRAINT DF_clientes_ativo
		DEFAULT 1;
END;
GO

IF COL_LENGTH -- Verifica a coluna informada
(
	N'origem.produtos',
	N'data_criacao'
) IS NULL -- Se não existir, execute do BEGIN até o END;
BEGIN
	ALTER TABLE origem.produtos
	ADD data_criacao DATETIME2 NOT NULL
		CONSTRAINT DF_produtos_data_criacao
		DEFAULT SYSDATETIME();
END;
GO

-- Validando os dados

SELECT
	cliente_id,
	nome,
	email,
	ativo
FROM origem.clientes
ORDER BY cliente_id;
GO

SELECT
	produto_id
	sku,
	produto,
	preco,
	data_criacao
FROM origem.produtos
ORDER BY produto_id;
GO

-- Validando e estrutura

SELECT
	TABLE_NAME AS tabela,
	ORDINAL_POSITION AS posicao,
	COLUMN_NAME AS coluna,
	DATA_TYPE AS tipo,
	IS_NULLABLE AS aceita_null,
	COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'origem'
  AND
  (
	(
		TABLE_NAME = N'clientes'
		AND COLUMN_NAME = N'ativo'
	)
	OR
	(
		TABLE_NAME = N'produtos'
		AND COLUMN_NAME = N'data_criacao'
	)
  )
  ORDER BY 
	TABLE_NAME,
	ORDINAL_POSITION;

-- Validando as novas CONSTRAINTS

SELECT
	t.name AS tabela,
	dc.name AS constraint_nome,
	c.name AS coluna,
	dc.definition AS definicao
FROM sys.default_constraints AS dc
INNER JOIN sys.tables AS t
	ON t.object_id = dc.parent_object_id
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
INNER JOIN sys.columns AS c
	ON c.object_id = dc.parent_object_id
	  AND c.column_id = dc.parent_column_id
WHERE s.name = N'origem'
  AND dc.name IN
  (
	N'DF_clientes_ativo',
	N'DF_produtos_data_criacao'
  )
ORDER BY t.name;

