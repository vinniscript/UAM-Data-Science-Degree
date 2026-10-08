IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.mapeamento_etl
	WHERE fonte = N'vendas.csv'
	  AND campo_origem = N'data_venda'
	  AND tabela_destino = N'staging.vendas_tratadas'
	  AND campo_destino = N'data_venda'
)
BEGIN
	INSERT INTO auditoria.mapeamento_etl
	(
		fonte,
		campo_origem,
		tabela_destino,
		campo_destino,
		regra
	)
	VALUES
	(
		N'vendas.csv',
		N'data_venda',
		N'staging.vendas_tratadas',
		N'data_venda',
		N'Tipo esperado DATE; aceitar yyyy-MM-dd ou dd/MM/yyyy; rejeitar nulo ou formato inválido'
	);
END;
GO

-- Cliente

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.mapeamento_etl
	WHERE fonte = N'vendas.csv'
	  AND campo_origem = N'cliente_email'
	  AND tabela_destino = N'staging.vendas_tratadas'
	  AND campo_destino = N'cliente_email'
)
BEGIN
	INSERT INTO auditoria.mapeamento_etl
	(
		fonte,
		campo_origem,
		tabela_destino,
		campo_destino,
		regra
	)
	VALUES
	(
		N'vendas.csv',
		N'cliente_email',
		N'staging.vendas_tratadas',
		N'cliente_email',
		N'Tipo esperado NVARCHAR(160); remover espaços, converter para minúsculas e rejeitar vazio'
	);
END;
GO

-- Produto

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.mapeamento_etl
    WHERE fonte = N'vendas.csv'
      AND campo_origem = N'sku'
      AND tabela_destino = N'staging.vendas_tratadas'
      AND campo_destino = N'sku'
)
BEGIN
    INSERT INTO auditoria.mapeamento_etl
    (
        fonte,
        campo_origem,
        tabela_destino,
        campo_destino,
        regra
    )
    VALUES
    (
        N'vendas.csv',
        N'sku',
        N'staging.vendas_tratadas',
        N'sku',
        N'Tipo esperado NVARCHAR(30); remover espaços e rejeitar valor vazio'
    );
END;
GO

-- filial

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.mapeamento_etl
    WHERE fonte = N'vendas.csv'
      AND campo_origem = N'filial'
      AND tabela_destino = N'staging.vendas_tratadas'
      AND campo_destino = N'filial'
)
BEGIN
    INSERT INTO auditoria.mapeamento_etl
    (
        fonte,
        campo_origem,
        tabela_destino,
        campo_destino,
        regra
    )
    VALUES
    (
        N'vendas.csv',
        N'filial',
        N'staging.vendas_tratadas',
        N'filial',
        N'Tipo esperado NVARCHAR(80); remover espaços e rejeitar valor vazio'
    );
END;
GO

-- Quantidade

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.mapeamento_etl
    WHERE fonte = N'vendas.csv'
      AND campo_origem = N'quantidade'
      AND tabela_destino = N'staging.vendas_tratadas'
      AND campo_destino = N'quantidade'
)
BEGIN
    INSERT INTO auditoria.mapeamento_etl
    (
        fonte,
        campo_origem,
        tabela_destino,
        campo_destino,
        regra
    )
    VALUES
    (
        N'vendas.csv',
        N'quantidade',
        N'staging.vendas_tratadas',
        N'quantidade',
        N'Tipo esperado INT; converter com TRY_CONVERT e aceitar somente valores maiores que zero'
    );
END;
GO

-- Valor unitário

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.mapeamento_etl
    WHERE fonte = N'vendas.csv'
      AND campo_origem = N'valor_unitario'
      AND tabela_destino = N'staging.vendas_tratadas'
      AND campo_destino = N'valor_unitario'
)
BEGIN
    INSERT INTO auditoria.mapeamento_etl
    (
        fonte,
        campo_origem,
        tabela_destino,
        campo_destino,
        regra
    )
    VALUES
    (
        N'vendas.csv',
        N'valor_unitario',
        N'staging.vendas_tratadas',
        N'valor_unitario',
        N'Tipo esperado DECIMAL(12,2); normalizar separador decimal, converter e aceitar somente valor positivo'
    );
END;
GO

-- Validando o exercício

SELECT
    mapeamento_id,
    fonte,
    campo_origem,
    tabela_destino,
    campo_destino,
    regra
FROM auditoria.mapeamento_etl
WHERE fonte = N'vendas.csv'
ORDER BY mapeamento_id;