-- Corrigindo o BIT

SELECT DISTINCT 
	ativo,
	LEN(ativo) AS TAMANHO,
	DATALENGTH(ativo) AS bytes
FROM staging.clientes_csv;

SELECT TOP 10
	'[' + ativo + ']' AS valor -- Aqui é nítido o espaço após o número
FROM staging.clientes_csv;

-- Para corrigir
SELECT DISTINCT
    '[' + ativo + ']' AS ativo,
    LEN(ativo) AS tamanho,
    DATALENGTH(ativo) AS bytes,
    ASCII(RIGHT(ativo, 1)) AS ultimo_caractere
FROM staging.clientes_csv;

SELECT
	ativo,
	TRY_CONVERT(BIT, REPLACE(ativo, CHAR(13), '')) AS ativo_convertido -- remove o '/r' da quebra de linha do windows
FROM staging.clientes_csv;

