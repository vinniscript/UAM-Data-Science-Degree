USE DataCommerce;
GO

CREATE TABLE staging.clientes_origem
(
    nome_cliente    NVARCHAR(240) NULL,
    celular_cliente NVARCHAR(100) NULL,
    status_cliente  NVARCHAR(20)  NULL
);
GO

CREATE TABLE staging.produtos_origem
(
    nome_produto  NVARCHAR(240) NULL,
    sku_produto   NVARCHAR(60)  NULL,
    un_produto    NVARCHAR(20)  NULL,
    preco_produto NVARCHAR(60)  NULL
);
GO

CREATE TABLE staging.vendas_origem
(
    id_cliente NVARCHAR(100) NULL,
    data_venda NVARCHAR(100) NULL
);
GO

CREATE TABLE staging.itens_venda_origem
(
    id_venda             NVARCHAR(100) NULL,
    id_produto           NVARCHAR(100) NULL,
    qtd_item_venda       NVARCHAR(100) NULL,
    preco_item_vendaunit NVARCHAR(100) NULL
);
GO

-- NVARCHAR na staging -> aceita tudo, trata depois
-- staging bruta

-- Carregar os 4 CSVs

BULK INSERT staging.clientes_origem
FROM '/var/opt/mssql/import/clientes_origem_1200.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT staging.produtos_origem
FROM '/var/opt/mssql/import/produtos_origem_120.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT staging.vendas_origem
FROM '/var/opt/mssql/import/X_vendas_origem_500.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT staging.itens_venda_origem
FROM '/var/opt/mssql/import/Z_itens_venda_origem_500.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a'
);
GO

-- Validando a carga bruta

SELECT
    N'clientes_origem' AS tabela,
    COUNT_BIG(*) AS registros
FROM staging.clientes_origem

UNION ALL

SELECT
    N'produtos_origem',
    COUNT_BIG(*)
FROM staging.produtos_origem

UNION ALL

SELECT
    N'vendas_origem',
    COUNT_BIG(*)
FROM staging.vendas_origem

UNION ALL

SELECT
    N'itens_venda_origem',
    COUNT_BIG(*)
FROM staging.itens_venda_origem;

-- Tendo uma visão sobre as tabelas
/*
TRUNCATE TABLE staging.clientes_origem;
TRUNCATE TABLE staging.produtos_origem;
TRUNCATE TABLE staging.vendas_origem;
TRUNCATE TABLE staging.itens_venda_origem;
*/

SELECT TOP (5)
    nome_cliente,
    celular_cliente,
    status_cliente
FROM staging.clientes_origem;

SELECT TOP (5)
    nome_produto,
    sku_produto,
    un_produto,
    preco_produto
FROM staging.produtos_origem;

SELECT TOP (5)
    id_cliente,
    data_venda
FROM staging.vendas_origem;

SELECT TOP (5)
    id_venda,
    id_produto,
    qtd_item_venda,
    preco_item_vendaunit
FROM staging.itens_venda_origem;
