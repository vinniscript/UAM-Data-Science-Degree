SELECT
	PE.pedido_id,
	PE.data_pedido,
	C.cliente_id,
	C.nome AS cliente,
	C.uf,
	VE.vendedor_id,
	VE.nome AS vendedor,
	PE.filial,
	PR.sku,
	PR.produto,
	PR.categoria,
	I.quantidade,
	I.valor_unitario,
	I.quantidade * I.valor_unitario AS valor_total_item
	
FROM origem.itens_pedido AS I

INNER JOIN origem.pedidos AS PE
	ON PE.pedido_id = I.pedido_id

INNER JOIN origem.clientes AS C
	ON C.cliente_id = PE.cliente_id

INNER JOIN origem.produtos AS PR
	ON pr.produto_id = I.produto_id

INNER JOIN origem.vendedores AS VE
	ON VE.vendedor_id = PE.vendedor_id

ORDER BY
	PE.pedido_id DESC,
	PR.produto_id;

	USE DataCommerce;
GO

SELECT
    N'clientes' AS objeto,
    COUNT(*) AS total
FROM origem.clientes

UNION ALL

SELECT
    N'produtos',
    COUNT(*)
FROM origem.produtos

UNION ALL

SELECT
    N'pedidos',
    COUNT(*)
FROM origem.pedidos

UNION ALL

SELECT
    N'itens_pedido',
    COUNT(*)
FROM origem.itens_pedido

UNION ALL

SELECT
    N'vendedores',
    COUNT(*)
FROM origem.vendedores;
GO

SELECT TOP 30
    pedido_id,
    data_pedido,
    cliente,
    uf,
    vendedor,
    filial,
    sku,
    produto,
    quantidade,
    valor_unitario,
    valor_total
FROM origem.vw_vendas_operacionais
ORDER BY
    pedido_id DESC,
    produto;

-- Recriando uma VIEW

USE DataCommerce;
GO

CREATE OR ALTER VIEW origem.vw_resumo_pedidos
AS

SELECT
    PE.pedido_id,
    PE.data_pedido,
    PE.cliente_id,
    C.nome AS cliente,
    C.uf,
    PE.vendedor_id,
    VE.nome AS vendedor,
    PE.filial,
    COUNT(*) AS linhas_de_item,

    COUNT
    (
        DISTINCT I.produto_id
    ) AS produtos_distintos,

    SUM
    (
        I.quantidade
    ) AS quantidade_total,

    SUM
    (
        I.quantidade * I.valor_unitario
    ) AS valor_total_pedido
   
FROM origem.pedidos AS PE

INNER JOIN origem.clientes AS C
   ON C.cliente_id = PE.cliente_id

INNER JOIN origem.vendedores AS VE
    ON VE.vendedor_id = PE.vendedor_id

INNER JOIN origem.itens_pedido AS I
    ON I.pedido_id = PE.pedido_id

GROUP BY
    PE.pedido_id,
    PE.data_pedido,
    PE.cliente_id,
    C.nome,
    C.uf,
    PE.vendedor_id,
    VE.nome,
    PE.filial;
GO

-- Consultar a VIEW

SELECT
    *
FROM origem.vw_resumo_pedidos
ORDER BY pedido_id DESC;