-- Nesse momento, não deve existir nada nessas tabelas. Apenas validando (22/09/2026 - 20:41)

USE DataCommerce;
GO

SELECT N'clientes' AS tabela, COUNT(*) AS total
FROM origem.clientes

UNION ALL

SELECT N'produtos', COUNT(*)
FROM origem.produtos

UNION ALL

SELECT N'pedidos', COUNT(*)
FROM origem.pedidos

UNION ALL

SELECT N'itens_pedido', COUNT(*)
FROM origem.itens_pedido;

-- Inserindo clientes

IF NOT EXISTS
(
	SELECT 1
	FROM origem.clientes
	WHERE email = N'ana@datacommerce.com'
)
BEGIN
	INSERT INTO origem.clientes
	(
		nome,
		email,
		uf
	)
	VALUES
	(
		N'Ana Silva',
		N'ana@datacommerce.com',
		N'SP'
	);

END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM origem.clientes
	WHERE email = N'bruno@datacommerce.com'
)
BEGIN
	INSERT INTO origem.clientes
	(
		nome,
		email,
		uf
	)
	VALUES
	(
		N'Bruno Lima',
		N'bruno@datacommerce.com',
		N'RJ'
	);
END;
GO

-- Não informamos cliente_id nem data_cadastro, pois cliente_id será gerado por IDENTITY e data_cadastro será preenchida pelo DEFAULT

-- Inserindo produtos

IF NOT EXISTS
(
	SELECT 1
	FROM origem.produtos
	WHERE sku = N'NBK-001'
)
BEGIN
	INSERT INTO origem.produtos
	(
		sku,
		produto,
		categoria,
		preco
	)
	VALUES
	(
		N'NBK-001',
		N'Notebook Pro',
		N'Informática',
		N'4500.00'
	);
END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM origem.produtos
	WHERE sku = N'MOU-010'
)
BEGIN
	INSERT INTO origem.produtos
	(
		sku,
		produto,
		categoria,
		preco		
	)
	VALUES
	(
		N'MOU-010',
		N'Mouse óptico',
		N'Acessórios',
		N'80.00'
	);
END;
GO

-- Conferindo IDs gerados (clientes)

SELECT
	cliente_id,
	nome,
	email,
	uf,
	data_cadastro
FROM origem.clientes
ORDER BY cliente_id;
GO

-- Conferindo IDs gerados (produtos)

SELECT
	produto_id,
	sku,
	produto,
	categoria,
	preco
FROM origem.produtos
ORDER BY produto_id;
GO

-- Inserindo o pedido sem presumir o ID do cliente

DECLARE @ClienteId INT; -- Cria uma variável local do tipo INT

SELECT
	@clienteId = cliente_id -- A variável existe apenas dentro do lote atual. Por isso não há GO entre o DECLARE e o uso da variável.
FROM origem.clientes
WHERE email = N'ana@datacommerce.com';

IF NOT EXISTS
(
	SELECT 1
	FROM origem.pedidos
	WHERE cliente_id = @ClienteId
	  AND data_pedido = '2026-08-24'
	  AND filial = N'São Paulo'
)
BEGIN
	INSERT INTO origem.pedidos
	(
		cliente_id,
		data_pedido,
		filial
	)
	VALUES
	(
		@ClienteId,
		'2026-08-24',
		N'São Paulo'
	);
END;
GO
-- O DECLARE é uma forma de conseguir efetuar a compra sem presumir IDs. Pegamos o ID por um dado fixo já definido. Acertaremos o alvo independente do número, apenas sabendo outras colunas da linha desejada.

-- Inserindo os itens sem presumir IDs

DECLARE @PedidoId INT;
DECLARE @NotebookId INT;
DECLARE @MouseId INT;

SELECT
	@PedidoId = pedido_id
FROM origem.pedidos
WHERE data_pedido = '2026-08-24'
  AND filial = N'São Paulo';

SELECT
	@NotebookId = produto_id
FROM origem.produtos
WHERE sku = N'NBK-001';

SELECT
	@MouseId = produto_ID
FROM origem.produtos
WHERE sku = N'MOU-010';

IF NOT EXISTS
(
	SELECT 1
	FROM origem.itens_pedido
	WHERE pedido_id = @PedidoId
	  AND produto_id = @NotebookId
)
BEGIN
	INSERT INTO origem.itens_pedido
	(
		pedido_id,
		produto_id,
		quantidade,
		valor_unitario
	)
	VALUES
	(
		@PedidoId,
		@NotebookId,
		1.00,
		4500.00
	);
END;

IF NOT EXISTS
(
	SELECT 1
	FROM origem.itens_pedido
	WHERE pedido_id = @PedidoId
	  AND produto_id = @MouseId
)
BEGIN
	INSERT INTO origem.itens_pedido
	(
		pedido_id,
		produto_id,
		quantidade,
		valor_unitario
	)
	VALUES
	(
		@PedidoId,
		@MouseId,
		2.00,
		80.00
	);
END;
GO

-- Validando o feito

SELECT
	pedido_id,
	produto_id,
	quantidade,
	valor_unitario,
	quantidade * valor_unitario AS subtotal
FROM origem.itens_pedido
ORDER BY
	pedido_id,
	produto_id;

