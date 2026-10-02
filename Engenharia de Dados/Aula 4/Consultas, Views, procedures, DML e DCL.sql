-- VIEWs armazenam querys complexas para não precisar ficar redigitando.

-- Conferimento da inexistência da VIEW
USE DataCommerce;
GO

SELECT
	DB_NAME() AS banco_atual,
	SUSER_SNAME() AS login_atual,
	OBJECT_ID
	(
		N'origem.vm_vendas_operacionais',
		N'V'
	) AS view_id;

-- Criação da view

CREATE OR ALTER VIEW origem.vw_vendas_operacionais
AS

SELECT
    p.pedido_id,
    p.data_pedido,

    c.nome AS cliente,
    c.uf,

    p.filial,

    pr.sku,
    pr.produto,

    i.quantidade,
    i.valor_unitario,

    i.quantidade * i.valor_unitario AS valor_total

FROM origem.pedidos AS p

INNER JOIN origem.clientes AS c
    ON c.cliente_id = p.cliente_id

INNER JOIN origem.itens_pedido AS i
    ON i.pedido_id = p.pedido_id

INNER JOIN origem.produtos AS pr
    ON pr.produto_id = i.produto_id;
GO	

-- Consultando a view

SELECT
    pedido_id,
    data_pedido,
    cliente,
    uf,
    filial,
    sku,
    produto,
    quantidade,
    valor_unitario,
    valor_total

FROM origem.vw_vendas_operacionais
ORDER BY
    pedido_id,
    sku;

-- Consultando totais pela view

SELECT
    pedido_id,
    cliente,
    filial,
    SUM(valor_total) AS total_pedido
FROM origem.vw_vendas_operacionais
GROUP BY
    pedido_id,
    cliente,
    filial
ORDER BY pedido_id;

--Note que com o view, não precisamos redigitar os JOINS tudo.

-- validando pelo catálogo

SELECT
    s.name AS schema_nome,
    v.name AS view_nome,
    v.create_date AS data_criacao,
    v.modify_date AS data_modificacao
FROM sys.views AS v
INNER JOIN sys.schemas AS s
    ON s.schema_id = v.schema_id
WHERE s.name = N'origem'
  AND v.name = N'vw_vendas_operacionais';

-- Validando a definição armazenada

SELECT
    OBJECT_DEFINITION
    (
        OBJECT_ID
        (
            N'origem.vw_vendas_operacionais'
        )
    ) AS definicao_view;

-- Demonstra a query cadastrada dentro dessa view


-- Agora vamos adicionar/alterar a view para colocar junto os vendedores

CREATE OR ALTER VIEW origem.vw_vendas_operacionais
AS

SELECT
    p.pedido_id,
    p.data_pedido,

    c.nome AS cliente,
    c.uf,

    v.nome AS vendedor,

    p.filial,

    pr.sku,
    pr.produto,

    i.quantidade,
    i.valor_unitario,

    i.quantidade * i.valor_unitario AS valor_total

FROM origem.pedidos AS p

INNER JOIN origem.clientes AS c
    ON c.cliente_id = p.cliente_id

INNER JOIN origem.vendedores AS v
    ON v.vendedor_id = p.vendedor_id

INNER JOIN origem.itens_pedido AS i
    ON i.pedido_id = p.pedido_id

INNER JOIN origem.produtos AS pr
    ON pr.produto_id = i.produto_id;
GO

/*
O que mudou?

acrescentamos v.nome AS vendedor
e
INNER JOIN origem.vendedores AS v
    ON v.vendedor_id = p.vendedor_id
*/

-- validando:

SELECT
    pedido_id,
    data_pedido,
    cliente,
    vendedor,
    uf,
    filial,
    sku,
    produto,
    quantidade,
    valor_unitario,
    valor_total
FROM origem.vw_vendas_operacionais
ORDER BY
    pedido_id,
    sku;

-- stored procedure

/*
Vamos diferenciar:

VIEW
Representa uma consulta nomeada, consumida com SELECT.
 
STORED PROCEDURE
Representa uma rotina executada com EXEC.
Pode receber parâmetros e executar várias instruções.

A procedure que construiremos receberá:

data inicial
data final

e executará uma consulta sobre a view.
*/

CREATE OR ALTER PROCEDURE origem.sp_vendas_por_periodo
    @data_ini DATE, -- Data de ínicio
    @data_fim DATE  -- Data final
AS
BEGIN
    SET NOCOUNT ON; -- Não trazer mensagem de linhas afetadas

    SELECT
        filial,
        SUM(valor_total) AS faturamento
    FROM origem.vw_vendas_operacionais
    WHERE data_pedido BETWEEN @data_ini AND @data_fim
    GROUP BY filial
    ORDER BY filial;
END;
GO

-- Para executar a nossa procedure:
-- para agosto --
EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-08-01', -- Apenas definimos estrategicamente quais variaveis mudar
    @data_fim = '2026-08-31'; -- dentro dessa execução. Então rapidamente definimos o escopo da busca
    -- ainda por cima utilizando o procedure

-- Para setembro

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-09-01',
    @data_fim = '2026-09-30';

-- Para o período completo

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-08-01',
    @data_fim = '2026-09-30';

/*
Antes de avançar: a procedure ainda aceita períodos incoerentes

Atualmente podemos executar:

EXEC origem.sp_vendas_por_periodo
@data_ini = '2026-09-30',
@data_fim = '2026-09-01';

A data inicial está depois da final.

A consulta provavelmente retornará zero linhas, mas isso esconde um erro de entrada. Uma rotina reutilizável deveria informar que o período é inválido.

Complemento pedagógico: validar os parâmetros

Vamos evoluir a mesma procedure:
*/

CREATE OR ALTER PROCEDURE origem.sp_vendas_por_periodo
    @data_ini DATE,
    @data_fim DATE
AS
   BEGIN
        SET NOCOUNT ON;

        IF @data_ini IS NULL
        BEGIN
            THROW 50001, N'A data inicial é obrigatória.', 1;
        END;

        IF @data_fim IS NULL
        BEGIN
            THROW 50002, N'A data final é obirgatória.', 1;
        END;

        IF @data_ini > @data_fim
        BEGIN
            THROW 50003, N'A data inicial não pode ser posterior a data final.', 1;
        END;

        SELECT
            filial,
            SUM(valor_total) AS faturamento
        FROM origem.vw_vendas_operacionais
        WHERE data_pedido BETWEEN @data_ini AND @data_fim
        GROUP BY filial
        ORDER BY filial;
END;
GO

-- Testando se ficou bala mesmo

EXEC origem.sp_vendas_por_periodo
    @data_ini = NULL, -- precisa dar erro 'Msg 50001... A data inicial é obrigatória'
    @data_fim = '2026-09-30'

-- Data final ausente

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-08-01',
    @data_fim = NULL

-- período invertido

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-09-30',
    @data_fim = '2026-08-01' -- erro 50003... data inicial não pode ser posterior a final

-- período válido

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-08-01',   
    @data_fim = '2026-09-30';

