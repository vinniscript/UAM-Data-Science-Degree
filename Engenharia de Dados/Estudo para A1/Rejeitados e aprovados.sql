USE DataCommerce;
GO

-- Rejeitados

IF OBJECT_ID('auditoria.clientes_rejeitados') IS NOT NULL
DROP TABLE auditoria.clientes_rejeitados;
GO

CREATE TABLE auditoria.clientes_rejeitados
(
	cliente_id NVARCHAR(50),
	nome NVARCHAR(200),
	email NVARCHAR(200),
	cidade NVARCHAR(100),
	uf NVARCHAR(10),
	data_cadastro NVARCHAR(50),
	ativo NVARCHAR (10),
	motivo_rejeicao NVARCHAR (500)
);
GO

ALTER TABLE auditoria.clientes_rejeitados
ADD data_cadastro NVARCHAR(50);

-- Aprovados

IF OBJECT_ID('origem.clientes_aprovados') IS NOT NULL
	DROP TABLE origem.clientes_aprovados;
GO

CREATE TABLE origem.clientes_aprovados
(
	cliente_id INT,
	nome NVARCHAR(200),
	email NVARCHAR(200),
	cidade NVARCHAR(100),
	uf CHAR(2),
	data_cadastro DATE,
	ativo BIT
);
GO

-- Inserindo rejeitados

INSERT INTO auditoria.clientes_rejeitados
(
	cliente_id,
	nome,
	email,
	cidade,
	uf,
	data_cadastro,
	ativo,
	motivo_rejeicao
)
SELECT
	cliente_id,
	nome,
	email,
	cidade,
	uf,
	data_cadastro,
	ativo,
	CONCAT
	(
		CASE
			WHEN email IS NULL
				OR LTRIM(RTRIM(email)) = ''
			THEN 'EMAIL INVÁLIDO; '
			ELSE ''
		END,

		CASE
			WHEN uf NOT IN
			(
				'SP',
				'RJ',
				'MG',
				'PR',
				'BA',
				'PE',
				'DF'
			)
			THEN 'UF INVALIDA; '
			ELSE ''
		END,

		CASE
			WHEN TRY_CONVERT(DATE, data_cadastro, 23) IS NULL
			THEN 'DATA INVALIDA; '
			ELSE ''
		END
	)
FROM staging.clientes_csv
WHERE
(
	email IS NULL
	OR LTRIM(RTRIM(email)) = ''
)
OR
(
	uf NOT IN
	(
		'SP',
		'RJ',
		'MG',
		'PR',
		'BA',
		'PE',
		'DF'
	)
)
OR
(
	TRY_CONVERT(DATE, data_cadastro, 23) IS NULL
);

-- Inserindo aprovados
INSERT INTO origem.clientes_aprovados
(
    cliente_id,
    nome,
    email,
    cidade,
    uf,
    data_cadastro,
    ativo -- Isso aqui é problema se não acertarmos o rowterminator do CSV
)
SELECT
    CAST(cliente_id AS INT),
    LTRIM(RTRIM(nome)),
    email,
    cidade,
    uf,
    TRY_CONVERT(DATE,data_cadastro,23),
    TRY_CONVERT
	(
		BIT,
		REPLACE(ativo, CHAR(13), '')
	)
FROM staging.clientes_csv
WHERE
email IS NOT NULL
AND LTRIM(RTRIM(email)) <> ''
AND uf IN
(
    'SP',
    'RJ',
    'MG',
    'PR',
    'BA',
    'PE',
    'DF'
)
AND TRY_CONVERT(DATE,data_cadastro,23) IS NOT NULL;

SELECT COUNT(*) AS aprovados
FROM origem.clientes_aprovados;

SELECT COUNT(*) AS rejeitados
FROM auditoria.clientes_rejeitados;