USE DataCommerce;
GO

IF OBJECT_ID
(
    N'staging.metas_excel',
    N'U'
) IS NULL
BEGIN
    CREATE TABLE staging.metas_excel
    (
        mes NVARCHAR(7) NULL,

        filial NVARCHAR(80) NULL,

        valor_meta DECIMAL(14,2) NULL,

        arquivo_origem NVARCHAR(200) NULL,

        data_carga DATETIME2 NOT NULL
            CONSTRAINT DF_metas_excel_data_carga
            DEFAULT SYSDATETIME()
    );
END;
GO

-- Validar estrutura

SELECT
	ORDINAL_POSITION AS posicao,
	
	COLUMN_NAME AS coluna,

	DATA_TYPE AS tipo,

	CHARACTER_MAXIMUM_LENGTH AS tamanho,

	NUMERIC_PRECISION AS precisao,

	NUMERIC_SCALE AS escala,

	IS_NULLABLE AS aceita_null,

	COLUMN_DEFAULT AS valor_padrao

FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'staging'
  AND TABLE_NAME = 'metas_excel'
ORDER BY ORDINAL_POSITION;

-- Inserindo valores

IF NOT EXISTS
(
	SELECT 1
	FROM staging.metas_excel
	WHERE arquivo_origem = N'metas_comerciais.xlsx'
)
BEGIN
	INSERT INTO staging.metas_excel
	(
		mes,
		filial,
		valor_meta,
		arquivo_origem
	)
	VALUES
	(
		N'2026-08',
		N'São Paulo',
		100000.00,
		N'metas_comerciais.xlsx'
	),
	(
		N'2026-08',
		N'Rio de Janeiro',
		80000.00,
		N'metas_comerciais.xlsx'
	),
	(
		N'2026-09',
		N'São Paulo',
		120000.00,
		N'metas_comerciais.xlsx'
	),
	(
		N'2026-09',
		N'Rio de Janeiro',
		90000.00,
		N'metas_comerciais.xlsx'
	);
END;
GO	

-- Consultado as metas

SELECT
    mes,
    filial,
    valor_meta,
    arquivo_origem,
    data_carga
FROM staging.metas_excel
ORDER BY
    mes,
    filial;

-- Campos obrigatórios ausentes

SELECT
    mes,
    filial,
    valor_meta
FROM staging.metas_excel
WHERE mes IS NULL
   OR LTRIM(RTRIM(mes)) = N''
   OR filial IS NULL
   OR LTRIM(RTRIM(filial)) = N''
   OR valor_meta IS NULL;

-- Valors não positivos

SELECT
	mes,
	filial,
	valor_meta
FROM staging.metas_excel
WHERE valor_meta <= 0;

-- Agregar mês por filial

SELECT
	filial,
	SUM(valor_meta) AS meta_total,
	COUNT(*) AS quantidade_meses
FROM staging.metas_excel
GROUP BY filial
ORDER BY meta_total DESC;

-- Agregar metas por mês

SELECT
	mes,
	SUM(valor_meta) AS meta_total,
	COUNT(*) AS quantidade_filiais
FROM staging.metas_excel
GROUP BY mes
ORDER BY mes;