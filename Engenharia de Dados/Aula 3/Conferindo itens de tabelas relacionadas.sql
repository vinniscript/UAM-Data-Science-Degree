-- Aprendendo a usar o JOIN

SELECT
	p.pedido_id,
	p.cliente_id,
	c.nome,
	p.data_pedido,
	p.filial
FROM origem.pedidos AS p -- Define a tabela inicial pedidos, nomeando-a como p
INNER JOIN origem.clientes AS c -- Combina pedidos com clientes, nomeando-a como c
	ON c.cliente_id = p.cliente_id; -- Define a regra de combinação. Sem isso o banco não saberia qual cliente combinar com qual pedido

-- Acrescentando os itens

SELECT
	p.pedido_id,
	c.nome AS cliente,
	p.filial,
	i.produto_id,
	i.quantidade,
	i.valor_unitario,
	i.quantidade * i.valor_unitario AS subtotal
FROM origem.pedidos AS p
INNER JOIN origem.clientes as C
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.itens_pedido as i -- Para cada pedido, encontre os itens que possuem o mesmo pedido_id.
	ON i.pedido_id = p.pedido_id
ORDER BY
	p.pedido_id,
	i.produto_id; -- mesmo sem estar no ON do INNER JOIN, pode ser chamado.
	
-- Acrescentando o nome do produto

SELECT
	p.pedido_id,
	c.nome AS cliente,
	p.data_pedido,
	pr.sku,
	pr.produto,
	i.quantidade,
	i.valor_unitario,
	i.quantidade * valor_unitario AS subtotal
FROM origem.pedidos AS p
INNER JOIN origem.clientes AS c
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.itens_pedido AS i
	ON i.pedido_id = p.pedido_id
INNER JOIN origem.produtos AS pr -- Para cada item, encontre o produto cujo identificador seja igual ao produto_id armazenado no item.
	ON pr.produto_id = i.produto_id
ORDER BY
	p.pedido_id,
	pr.produto_id;

-- Calculando o total com SUM

SELECT
	p.pedido_id,
	c.nome,
	p.filial,
	SUM(i.quantidade * i.valor_unitario) AS total_pedido
FROM origem.pedidos AS p
INNER JOIN origem.clientes AS c
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.itens_pedido AS i
	ON i.pedido_id = p.pedido_id
GROUP BY -- Por quê GROUP BY?
	p.pedido_id, -- Queremos uma linha final por pedido. Ele forma um grupo para cada combinação
	c.nome, -- ID e nomes iguais, ao invés de aparecer várias vezes, só aparecerá uma, agregado.
	p.filial;

/*
Regra inicial útil

Quando usamos agregação, as colunas exibidas no SELECT que não estão dentro de uma 
função como SUM, COUNT, MIN ou MAX normalmente precisam aparecer no GROUP BY.
*/