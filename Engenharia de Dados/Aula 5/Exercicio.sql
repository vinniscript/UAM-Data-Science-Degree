-- Execício aula 5

SELECT
	nome,
	email,
	cidade,
	uf,

	CASE
		WHEN email IS NULL
		  OR LTRIM(RTRIM(email)) = N''
		  OR cidade IS NULL
		  OR LTRIM(RTRIM(cidade)) = N''
		 THEN N'Rejeitado'

		WHEN email <> LTRIM(RTRIM(email)) -- Me mostre se email é diferente de si mesmo após remover espaços em branco
		  OR uf = N'XX'
		THEN N'AJUSTAR'

		ELSE N'APROVADO'
	END AS classificacao

FROM staging.clientes_csv

ORDER BY nome;

-- Resumo da classificação

SELECT
    classificacao,
    COUNT(*) AS total
FROM
(
    SELECT
        CASE
            WHEN email IS NULL
              OR LTRIM(RTRIM(email)) = N''
              OR cidade IS NULL
              OR LTRIM(RTRIM(cidade)) = N''
            THEN N'REJEITADO'

            WHEN email <> LTRIM(RTRIM(email))
              OR uf = N'XX'
            THEN N'AJUSTAR'

            ELSE N'APROVADO'
        END AS classificacao
    FROM staging.clientes_csv
) AS classificacao_clientes
GROUP BY classificacao
ORDER BY classificacao;