/*
Uma variável é uma área temporária usada para guardar um valor durante o lote.

No T-SQL, o nome começa com:

@

Exemplo:

DECLARE @ClienteId INT;
 

Isso cria uma variável:

Nome: @ClienteId
Tipo: INT
Valor inicial: NULL

Ainda não existe um número dentro dela.

Atribuindo um valor

SELECT
@ClienteId = cliente_id
FROM origem.clientes
WHERE email = N'bruno@datacommerce.com';

Essa consulta:

procura Bruno pelo e-mail;
lê seu cliente_id;
guarda o resultado em @ClienteId.

Com seus dados atuais:

@Cl-ienteId = 2

Podemos conferir:


SELECT @ClienteId AS cliente_localizado;
Mostrar mais linhas
Por que não escrever simplesmente 2?

Porque o ID 2 existe no seu estado atual, mas poderia ser outro número se:

a tabela tivesse recebido registros anteriormente;
linhas anteriores tivessem sido excluídas;
a identidade tivesse avançado;
o script fosse executado em outro banco.

O e-mail foi definido como UNIQUE, então serve como uma forma estável de localizar Bruno neste laboratório.
*/

-- Para pegar um ID recém gerado pelo IDENTITY, usamos o SCOPE_IDENTITY()

/*
EXEMPLO:

INSERT INTO origem.pedidos
(
	cliente.id,
	data_pedido,
	filial
)
VALUES
(
	@ClienteId,
	'2026-09-24',
	N'Rio de Janeiro'
);

SET @PedidoId = CONVERT(INT, SCOPE_IDENTITY());

SCOPE_IDENTITY()

Devolve o último valor IDENTITY gerado no mesmo escopo da execução.

Se o novo pedido recebeu:

pedido_id = 2

Então

@PedidoId = 2
*/

USE DataCommerce;
GO

DECLARE @ClienteId INT;
DECLARE @ProdutoId INT;
DECLARE @PedidoId INT;

/*
PONTO DE ATENÇÃO:

Se Bruno ou Mouse não fossem encontrados:

@ClienteId = NULL
@ProdutoId = NULL

Os INSERTs falhariam porque as colunas correspondentes são NOT NULL.

Em um script profissional, devemos testar isso explicitamente antes de iniciar a transação.

IF @ClienteId IS NULL
BEGIN
	THROW 50001, N'Cliente não encontrado.', 1; -- Interrompe o fluxo e gera um erro definido pelo script.
END;

IF @Produto IS NULL
BEGIN
	THROW 50002, N'Produto não encontrado.', 1;
END;
*/

SELECT
	@ClienteId = cliente_id
FROM origem.clientes
WHERE email = N'bruno@datacommerce.com';

SELECT 
	@ProdutoId = produto_id
FROM origem.produtos
WHERE sku = N'MOU-010';

SELECT
	@ClienteId AS cliente_localizado,
	@ProdutoId AS produto_localizado;

BEGIN TRANSACTION;

INSERT INTO origem.pedidos
(
	cliente_id,
	data_pedido,
	filial
)
VALUES
(
	@ClienteId,
	'2026-09-24',
	N'Rio de Janeiro'
);

SET @PedidoId = CONVERT(INT,SCOPE_IDENTITY());

/*
SCOPE_IDENTITY() não devolve necessáriamente um INT, ele trabalha com NUMERIC(X,X)
Porém, é capaz que funcionasse sim algo como:

SET @PedidoId = SCOPE_IDENTITY()

mas deixamos a conversão para explicitar ainda mais as intenções e facilitar a legibilidade
*/

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
	@ProdutoId,
	1.00,
	80.00
);

SELECT
	@PedidoId AS pedido_gerado,
	@@TRANCOUNT AS transacoes_abertas;

SELECT
	(SELECT COUNT(*) FROM origem.pedidos) AS pedidos_durante, -- Subconsulta da quantidade de linhas/registros de pedidos
	(SELECT COUNT(*) FROM origem.itens_pedido) AS itens_durante; -- Subconsulta da quantidade de linhas/registros de itens_pedidos

ROLLBACK; -- Não retorna o ID novo gerado para pedidos. A partir daqui, cria-se "lacunas", mas não atrapalha em nada. Só perdeu a sequência númerica

SELECT
	@@TRANCOUNT AS transacoes_abertas_apos_rollback;

SELECT
	(SELECT COUNT(*) FROM origem.pedidos) AS pedidos_depois,
	(SELECT COUNT(*) FROM origem.itens_pedido) AS itens_depois;

-- Agora com COMMIT

USE DataCommerce;
GO

DECLARE @ClienteId INT;
DECLARE @ProdutoId INT;
DECLARE @PedidoId INT;

SELECT
	@ClienteId = cliente_id
FROM origem.clientes
WHERE email = N'bruno@datacommerce.com';

SELECT
	@ProdutoId = produto_id
FROM origem.produtos
WHERE sku = N'MOU-010';

SELECT
	@ClienteId AS [Cliente localizado (Antes do commit)],
	@ProdutoId AS [Produto localizado (Antes do commit)]

BEGIN TRANSACTION;

INSERT INTO origem.pedidos
(
	cliente_id,
	data_pedido,
	filial
)
VALUES
(
	@ClienteId,
	'2026-09-24',
	N'Rio de Janeiro'
);

SET @PedidoId = CONVERT
(
INT,
SCOPE_IDENTITY()
);

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
	@ProdutoId,
	1.00,
	80.00
);

SELECT
	@PedidoId AS [Pedido gerado],
	@@TRANCOUNT AS [Transações (antes do commit)]

COMMIT;

SELECT
	@@TRANCOUNT AS [Transações (após o COMMIT)]

-- Validando o pedido confirmado

SELECT
	p.pedido_id,
	c.nome AS cliente,
	p.data_pedido,
	p.filial,
	pr.sku,
	pr.produto,
	i.quantidade,
	i.valor_unitario,
	i.quantidade * i.valor_unitario AS subtotal
FROM origem.pedidos AS p
INNER JOIN origem.clientes AS c
	ON c.cliente_id = p.cliente_id
INNER JOIN origem.itens_pedido AS i
	ON i.pedido_id = p.pedido_id
INNER JOIN origem.produtos AS pr
	ON pr.produto_id = i.produto_id
WHERE c.email = N'bruno@datacommerce.com'
  AND p.data_pedido = '2026-09-24'
ORDER BY
	p.pedido_id,
	pr.produto_id;
