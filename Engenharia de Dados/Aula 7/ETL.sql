/*

E = Extract
Extrair dados das fontes
 
T = Transform
Limpar, converter, validar e padronizar
 
L = Load
Carregar os dados no destino

ETL consolida dados de diferentes fontes, aplica transformações segundo regras e os envia
a um destino unificado. Operações comuns de transformação incluem
filtragem, ordenação, agregação, combinação, limpeza, remoção de duplicidades e validação.

A staging continua sendo a área intermediária onde os dados podem ser recebidos, 
transformados e validados antes do destino final.

*/

-- Criando a tabela de mapeamento;

USE DataCommerce;
GO

IF OBJECT_ID
(
	N'auditoria.mapeamento_etl',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE auditoria.mapeamento_etl
	(
		mapeamento_id INT IDENTITY(1,1) NOT NULL,

		fonte NVARCHAR(100) NOT NULL,

		campo_origem NVARCHAR(100) NOT NULL,

		tabela_destino NVARCHAR(100) NOT NULL,

		campo_destino NVARCHAR(100) NOT NULL,

		regra NVARCHAR(500) NOT NULL,

		CONSTRAINT PK_mapeamento_etl
			PRIMARY KEY (mapeamento_id),

		CONSTRAINT UQ_mapeamento_etl_fluxo
			UNIQUE
			(
				fonte,
				campo_origem,
				tabela_destino,
				campo_destino
			)
	);
END;
GO

-- Validando a estrutura

SELECT
	ORDINAL_POSITION AS posicao,
	COLUMN_NAME AS coluna,
	DATA_TYPE AS tipo,
	CHARACTER_MAXIMUM_LENGTH AS tamanho,
	IS_NULLABLE AS aceita_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'auditoria'
  AND TABLE_NAME = 'mapeamento_etl'
ORDER BY ORDINAL_POSITION;

-- Inserção reexecutável

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.mapeamento_etl
	WHERE fonte = N'clientes.csv'
	  AND campo_origem = N'email'
	  AND tabela_destino = N'origem.clientes'
	  AND campo_destino = N'email'
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
		N'clientes.csv',
		N'email',
		N'origem.clientes',
		N'email',
		N'Validar formato e remover duplicidade'
	);
END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.mapeamento_etl
	WHERE fonte = N'metas_comerciais.xlsx'
	  AND campo_origem = N'valor_meta'
	  AND tabela_destino = N'staging.metas_excel'
	  AND campo_destino = N'valor_meta'
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
		N'metas_comerciais.xlsx',
		N'valor_meta',
		N'staging.metas_excel',
		N'valor_meta',
		N'converter para decimal'
	);

END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.mapeamento_etl
    WHERE fonte = N'atendimentos.json'
      AND campo_origem = N'nota'
      AND tabela_destino = N'staging.atendimentos_json'
      AND campo_destino = N'nota'
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
        N'atendimentos.json',
        N'nota',
        N'staging.atendimentos_json',
        N'nota',
        N'converter para inteiro'
    );
END;
GO

-- Consultando o mapa

SELECT
    mapeamento_id,
    fonte,
    campo_origem,
    tabela_destino,
    campo_destino,
    regra
FROM auditoria.mapeamento_etl
ORDER BY mapeamento_id;

/*
Por que receber tudo como texto?

Imagine estes valores vindos de um arquivo:

data_venda = 2026-09-30
quantidade = 2
valor_unitario = 80,50

A versão correta parece fácil de converter.

Mas o arquivo também poderia conter:

data_venda = 30/09/2026
quantidade = duas
valor_unitario = R$ 80,50


Se a staging exigisse imediatamente:

SQL
data_venda DATE
quantidade INT
valor_unitario DECIMAL(10,2)


a extração poderia falhar antes de conseguirmos investigar os dados.

Recebendo como:
NVARCHAR

Podemos separar as etapas:

Extração
Recebe o valor original.

Transformação
Tenta converter e identifica problemas.

Carga
Grava somente o dado aprovado no destino tipado.
*/

USE DataCommerce;
GO

IF OBJECT_ID
(
	N'staging.vendas_csv',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE staging.vendas_csv
	(
		data_venda NVARCHAR(30) NULL,

		cliente_email NVARCHAR(160) NULL,

		sku NVARCHAR(30) NULL,

		filial NVARCHAR(80) NULL,

		quantidade NVARCHAR(30) NULL,

		valor_unitario NVARCHAR(30) NULL,

		arquivo_origem NVARCHAR(200) NULL,

		data_carga DATETIME2 NOT NULL
			CONSTRAINT DF_vendas_csv_data_carga
				DEFAULT SYSDATETIME()
	);
END;
GO

-- Validando a estrutura

SELECT
    ORDINAL_POSITION AS posicao,

    COLUMN_NAME AS coluna,

    DATA_TYPE AS tipo,

    CHARACTER_MAXIMUM_LENGTH AS tamanho,

    IS_NULLABLE AS aceita_null,

    COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'staging'
  AND TABLE_NAME = N'vendas_csv'
ORDER BY ORDINAL_POSITION;

-- Adicionando

IF NOT EXISTS
(
    SELECT 1
    FROM staging.vendas_csv
)
BEGIN
    INSERT INTO staging.vendas_csv
    (
        data_venda,
        cliente_email,
        sku,
        filial,
        quantidade,
        valor_unitario,
        arquivo_origem
    )
    VALUES
    (
        N'2026-09-25',
        N'ana@datacommerce.com',
        N'NOTE-PRO',
        N'São Paulo',
        N'1',
        N'4500.00',
        N'vendas.csv'
    ),
    (
        N'2026-09-26',
        N'bruno@datacommerce.com',
        N'MOUSE-OPT',
        N'Rio de Janeiro',
        N'2',
        N'80.00',
        N'vendas.csv'
    ),
    (
        N'30/09/2026',
        N' carla@datacommerce.com ',
        N'MOUSE-OPT',
        N'São Paulo',
        N'duas',
        N'80,50',
        N'vendas.csv'
    ),
    (
        NULL,
        N'clienteinvalido@datacommerce.com',
        N'PROD-INEXISTENTE',
        N'Curitiba',
        N'-1',
        N'valor inválido',
        N'vendas.csv'
    );
END;
GO

-- Conferindo a extração para vermos os erros

SELECT
    data_venda,
    cliente_email,
    sku,
    filial,
    quantidade,
    valor_unitario,
    arquivo_origem,
    data_carga
FROM staging.vendas_csv
ORDER BY data_carga;

/*
Carla com espaço, um não tem data de venda, nem produto e a quantidade é negativa.
Vamos aprender a tratar isso.
*/

SELECT COUNT(*) AS linhas_vendas FROM staging.vendas_csv;

-- Retorno que tem data ausente

SELECT
    cliente_email,
    sku,
    data_venda
FROM staging.vendas_csv
WHERE data_venda IS NULL
   OR LTRIM(RTRIM(data_venda)) = N'';

-- Email com espaços

SELECT 
    cliente_email AS email_original,

    LTRIM
    (
        RTRIM
        (
            cliente_email
        )
    ) AS email_tratado
FROM staging.vendas_csv
WHERE cliente_email IS NOT NULL
  AND cliente_email <> LTRIM(RTRIM(cliente_email)); -- Só trazer casos onde o tratamento de espaços vazios mudaram o e-mail

-- Testar conversão de quantidade

SELECT
    cliente_email,
    quantidade,

    TRY_CONVERT
    (
        INT,
        quantidade
    ) AS quantidade_convertida -- Aqui 'duas' vai ficar NULL
FROM staging.vendas_csv

-- Identificar quantidade inválida

SELECT
    cliente_email,
    quantidade
FROM staging.vendas_csv
WHERE TRY_CONVERT
      (
        INT,
        quantidade
      ) IS NULL -- Vai retornar 'duas', pois quando a conversão não é possível, retorna NULL

    OR TRY_CONVERT
    (
        INT,
        quantidade
    ) <= 0;

-- Teste o valor unitário

SELECT
    cliente_email,
    valor_unitario,

    TRY_CONVERT
    (
        DECIMAL(12,2),
        valor_unitario
    ) AS valor_convertido

FROM staging.vendas_csv;

/*
Seguimos o fluxo;

INSERT na staging
Representa a extração.
 
TRY_CONVERT
Avalia se o valor pode ser transformado.
 
Filtros de validação
Identificam os registros problemáticos.
 
Destino final - Próxima etapa
Ainda não foi carregado.
*/
