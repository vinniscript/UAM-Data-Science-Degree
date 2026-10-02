USE DataCommerce;
GO

IF OBJECT_ID(N'origem.pedidos', N'U') IS NULL
BEGIN
	CREATE TABLE origem.pedidos
	(
		pedido_id INT IDENTITY(1,1) NOT NULL,

		cliente_id INT NOT NULL, -- Precisa ser do mesmo tipo da coluna referenciada INT -> INT

		data_pedido DATE NOT NULL,

		filial NVARCHAR(80) NOT NULL,

		CONSTRAINT PK_pedidos
		PRIMARY KEY (pedido_id),


		CONSTRAINT FK_pedidos_cliente
		FOREIGN KEY (cliente_id)
		REFERENCES origem.clientes(cliente_id)
/*
Leitura:

O valor presente em pedidos.cliente_id precisa corresponder a algum valor existente em clientes.cliente_id.

Isso permite:

Um cliente → muitos pedidos
Um pedido → um cliente


A chave estrangeira fica em pedidos, pois pedidos é o lado “muitos”.
Se ficasse do lado do "1", cada cliente estaria fadado a fazer apenas 1 pedido a vida inteira
*/
	);
END;
GO

IF OBJECT_ID(N'origem.itens_pedido', N'U') IS NULL
BEGIN
	CREATE TABLE origem.itens_pedido -- Resolve PEDIDOS N:N PRODUTOS
	( -- transformando em PEDIDOS 1:N ITENS_PEDIDO | PRODUTOS 1:N ITENS_PEDIDOS
		pedido_id INT NOT NULL,
		
		produto_id INT NOT NULL,
		
		quantidade DECIMAL(18,2) NOT NULL,

		valor_unitario DECIMAL(18,2) NOT NULL

		/*
		Cada linha significa algo semelhante a:

		No pedido 1,
		foi incluído o produto 2,
		na quantidade 3,
		pelo valor unitário de R$ 80.
		*/

		CONSTRAINT PK_itens_pedido
			PRIMARY KEY
			(
				pedido_id,
				produto_id
			), -- Aqui a regra não diz que pedido_id ou produto_id não pode se repetir, diz que pedido_id e produto_id não podem se repetir
			/*
			Válido:

			pedido_id | produto_id
			1 | 1
			1 | 2
			2 | 1

			Inválido:

			pedido_id | produto_id
			1 | 1
			1 | 1

			Decisão de modelagem

			Esse modelo não permite duas linhas separadas para o mesmo produto no mesmo pedido.

			Em vez de:

			Pedido 1 | Mouse | quantidade 1
			Pedido 1 | Mouse | quantidade 2

			esperamos:

			Pedido 1 | Mouse | quantidade 3

			*/
		CONSTRAINT FK_itens_pedido_pedidos
			FOREIGN KEY (pedido_id)
			REFERENCES origem.pedidos(pedido_id),

		CONSTRAINT FK_itens_pedidos_produtos
			FOREIGN KEY (produto_id)
			REFERENCES origem.produtos(produto_id),

		CONSTRAINT CK_itens_pedido_quantidade
			CHECK (quantidade > 0),

		CONSTRAINT CK_itens_pedido_valor
			CHECK (valor_unitario >= 0)
	);
END;
GO

-- Validação das 4 tabelas

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
	N'produtos',
	N'pedidos',
	N'itens_pedido'
  )
  ORDER BY t.name;

-- Validação das chaves estrangeiras

SELECT
	fk.name AS chave_estrangeira,

	OBJECT_SCHEMA_NAME -- Schema pai, quem faz a referência (o N)
	(
		fk.parent_object_id
	) AS schema_origem,

	OBJECT_NAME -- A tabela pai, quem recebe o referenciado
	(
		fk.parent_object_id
	) AS tabela_origem,

	OBJECT_SCHEMA_NAME -- Schema referenciado
	(
		fk.referenced_object_id
	) AS schema_referenciado,

	OBJECT_NAME -- Tabela que contém o atributo que será estrangeiro em outra tabela (o 1)
	(
		fk.referenced_object_id
	) AS tabela_referenciada

FROM sys.foreign_keys AS fk

WHERE fk.parent_object_id IN -- Onde pedidos e itens_pedidos são responsaveis pela chamada da referência, as tabelas pais
(
	OBJECT_ID(N'origem.pedidos'),
	OBJECT_ID(N'origem.itens_pedido')
)

ORDER BY fk.name;

-- Validação de todas as CONSTRAINTS

SELECT
	t.name AS tabela,
	o.name AS constraint_nome,
	o.type_desc AS constraint_tipo
FROM sys.objects AS o
INNER JOIN sys.tables as t
	ON t.object_id = o.parent_object_id
INNER JOIN sys.schemas as S
	ON s.schema_id = t.schema_id
WHERE s.name = N'origem'
  AND t.name IN
  (
	  N'pedidos',
	  N'itens_pedido'
  )
  AND o.type IN
  (
	  N'PK',
	  N'F',
	  N'C'
  )
  ORDER BY
  t.name,
  o.type_desc,
  o.name;