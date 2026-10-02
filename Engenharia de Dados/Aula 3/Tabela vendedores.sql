IF OBJECT_ID(
	N'origem.vendedores',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE origem.vendedores
	(
		vendedor_id INT IDENTITY(1,1) NOT NULL,
		nome NVARCHAR(120) NOT NULL,
		email NVARCHAR(160) NOT NULL,
		ativo BIT NOT NULL
			CONSTRAINT DF_vendedores_ativo
			DEFAULT 1, -- A constraint de default é feita á nivel de definição da coluna, não funciona deixar para fazer no final da criação.

		CONSTRAINT PK_vendedores
			PRIMARY KEY (vendedor_id),

		CONSTRAINT UQ_vendedores_email
			UNIQUE (email),
	);
END;
GO

-- Inserindo valores em vendedores

IF NOT EXISTS
(
	SELECT 1
	FROM origem.vendedores
	WHERE email = N'carla@datacommerce.com'
)
BEGIN
	INSERT INTO origem.vendedores
	(
		nome,
		email
	)
	VALUES
	(
		N'Carla Mendes',
		N'carla@datacommerce.com'
	);
END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM origem.vendedores
	WHERE email = N'diego@datacommerce.com'
)
BEGIN
	INSERT INTO origem.vendedores
	(
		nome,
		email
	)
	VALUES
	(
		N'Diego Ramos',
		N'diego@datacommerce.com'
	);
END;
GO

SELECT 
	vendedor_id,
	nome,
	email,
	ativo
FROM origem.vendedores
ORDER BY vendedor_id

/*
Por que não adicionar imediatamente uma coluna NOT NULL?

Já existem dois pedidos:

pedido 1
pedido 5

Se fizermos diretamente:

ALTER TABLE origem.pedidos
ADD vendedor_id INT NOT NULL;

o SQL Server precisará responder:

Qual é o vendedor dos pedidos antigos?

A coluna é obrigatória, mas não fornecemos nenhum valor para as linhas existentes.

Por isso, faremos uma migração em etapas:

1. Adicionar vendedor_id aceitando NULL.
2. Preencher os pedidos existentes.
3. Verificar se algum pedido ficou sem vendedor.
4. Alterar a coluna para NOT NULL.
5. Criar a FOREIGN KEY.

Esse é um padrão importante de evolução de bancos com dados existentes.
*/

-- Coluna provisoramente opcional

IF COL_LENGTH
(
	N'origem.pedidos',
	N'vendedor_id'
) IS NULL
BEGIN
	ALTER TABLE origem.pedidos
	ADD vendedor_id INT NULL;
END;
GO

-- valide

SELECT *
FROM origem.pedidos
ORDER BY pedido_id

/*
Vamos associar:

Pedido 1 → Carla
Pedido 5 → Diego

porém sem presumir IDs. DECLARE porraaaa
*/

DECLARE @CarlaId INT;
DECLARE @DiegoId INT;

SELECT
	@CarlaId = vendedor_id
FROM origem.vendedores
WHERE email = N'carla@datacommerce.com';

SELECT
	@DiegoId = vendedor_id
FROM origem.vendedores
WHERE email = N'diego@datacommerce.com';

UPDATE origem.pedidos
SET vendedor_id = @CarlaId
WHERE pedido_id = 1;

UPDATE origem.pedidos
SET vendedor_id = @DiegoId
WHERE pedido_id = 5;
GO

-- Validação antes de tornar obrigatório

SELECT *
FROM origem.pedidos

-- Validação se existe algum pedido sem vendedor

SELECT
	COUNT(*) AS [Pedido sem vendedor]
FROM origem.pedidos
WHERE vendedor_id IS NULL;

-- Tornando a coluna obrigatória

ALTER TABLE origem.pedidos
ALTER COLUMN vendedor_id INT NOT NULL;
GO

-- Criando a chave estrangeira

IF NOT EXISTS
(
	SELECT 1
	FROM sys.foreign_keys
	WHERE name = N'FK_pedidos_vendedores'
)
BEGIN
	ALTER TABLE origem.pedidos
	ADD CONSTRAINT FK_pedidos_vendedores
		FOREIGN KEY (vendedor_id)
		REFERENCES origem.vendedores(vendedor_id);
END;
GO

-- Consulta final com clientes e vendedores

SELECT
	p.pedido_id,

	c.nome AS cliente,
	
	v.nome AS vendedor,

	p.data_pedido,

	p.filial
FROM origem.pedidos AS p
INNER JOIN origem.clientes AS c
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.vendedores AS v
	ON v.vendedor_id = p.vendedor_id
ORDER BY pedido_id;

-- Validação da nova FK

SELECT
    fk.name AS chave_estrangeira,
    OBJECT_NAME
    (fk.parent_object_id) AS tabela_origem,
    OBJECT_NAME
    (fk.referenced_object_id) AS tabela_referenciada
FROM sys.foreign_keys AS fk
WHERE fk.name = N'FK_pedidos_vendedores';

SELECT
	p.pedido_id,
	c.nome AS cliente,
	v.nome AS vendedor,
	pr.produto,
	i.quantidade,
	i.valor_unitario,
	i.valor_unitario * i.quantidade AS subtotal
FROM origem.pedidos AS p
INNER JOIN origem.clientes AS c
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.vendedores AS v
	ON v.vendedor_id = p.vendedor_id
INNER JOIN origem.itens_pedido AS i
	ON i.pedido_id = p.pedido_id
INNER JOIN origem.produtos AS pr
	ON pr.produto_id = i.produto_id
