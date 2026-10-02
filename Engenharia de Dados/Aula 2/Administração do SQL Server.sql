USE DataCommerce;
GO

IF OBJECT_ID (
	'auditoria.parametros',
	'U'
) IS NULL
BEGIN
	CREATE TABLE auditoria.parametros
	(
		parametro NVARCHAR(80) NOT NULL PRIMARY KEY, -- UM Identificador via texto; não-usual
		valor NVARCHAR(4000) NOT NULL,
		descricao NVARCHAR(300) NULL
	);
END;
GO

-- validando

SELECT
	COLUMN_NAME as coluna,
	DATA_TYPE as tipo,
	CHARACTER_MAXIMUM_LENGTH as tamanho_maximo,
	IS_NULLABLE as pode_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'auditoria'
  AND TABLE_NAME = 'parametros'
ORDER BY ORDINAL_POSITION;

-- Inserindo parametros

IF NOT EXISTS 
(
	SELECT 1
	FROM auditoria.parametros
	WHERE parametro = N'PASTA_DADOS'
)
BEGIN
	INSERT INTO auditoria.parametros
	(
		parametro,
		valor,
		descricao
	)
	VALUES
	(
		N'PASTA_DADOS',
		N'C:\Users\vini\OneDrive - Cast Informatica SA\Documentos\UAM\8º Semestre\Engenharia de Dados\Meus estudos\DataCommerce\dados',
		N'Pasta de arquivos de entrada'
	);
END;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.parametros
	WHERE parametro = N'PASTA_LOGS'
)
BEGIN
	INSERT INTO auditoria.parametros
	(
		parametro,
		valor,
		descricao
	)
	VALUES
	(
		N'PASTA_LOGS',
		N'C:\Users\vini\OneDrive - Cast Informatica SA\Documentos\UAM\8º Semestre\Engenharia de Dados\Meus estudos\DataCommerce\logs',
		N'Pasta de logs de ETL'
	);
END;
GO

/*
Não precisa se preocupar com escape de caracteres especiais, como a \.
T-SQL só pede escape para apóstrofo "'", exemplo:

D'Ávila

Em um literal T-SQL:

N'D''Ávila'

Aspas simples é duplicada.
*/

-- Consultando os parâmetros

SELECT
	parametro,
	valor,
	descricao
FROM auditoria.parametros
ORDER BY parametro

-- Buscando somente um valor;

SELECT
	valor
FROM auditoria.parametros
WHERE parametro = N'PASTA_DADOS';

/*
FLUXO MENTAL

FROM auditoria.parametros
        ↓
ler a tabela de parâmetros

WHERE parametro = N'PASTA_DADOS'
        ↓
manter somente a linha desejada

SELECT valor
        ↓
retornar somente a coluna valor
*/

-- Contando e validando

SELECT
	COUNT(*) AS total_parametros
FROM auditoria.parametros;

