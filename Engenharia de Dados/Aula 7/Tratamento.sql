/*
transformação controlada

Agora criaremos uma consulta de transformação. Ela não alterará staging.vendas_csv.

A consulta calculará versões tratadas das colunas:

data_venda_tratada
cliente_email_tratado
quantidade_tratada
valor_unitario_tratado
status_transformacao

Tratando as datas

Temos dois formatos:

2026-09-25
30/09/2026

O estilo 23 representa:

aaaa-mm-dd

O estilo 103 representa:

dd/mm/aaaa

Esses estilos são reconhecidos por CONVERT e TRY_CONVERT ao interpretar datas.
*/

SELECT
	cliente_email,
	data_venda,

	COALESCE -- Retorna o primeiro valor que não seja NULL sem alterar nada na tabela
	(
		TRY_CONVERT
		(
			DATE,
			data_venda,
			23 -- padrão aaaa-mm-dd
		),
		TRY_CONVERT
		(
			DATE,
			data_venda,
			103 -- padrão dd/mm/aaaa
		)
	) AS data_venda_tratada

FROM staging.vendas_csv;

-- Agora tratando e-mail

SELECT
	cliente_email AS email_original,

	LOWER
	(
		LTRIM
		(
			RTRIM
			(
				cliente_email
			)
		)
	) AS email_tratado

FROM staging.vendas_csv;

/*

RTRIM
Remove espaços à direita.

LTRIM
Remove espaços à esquerda.

LOWER
Converte o texto para letras minúsculas.

*/

-- Tratando o valor unitário (vírgulas por pontos)

SELECT
	cliente_email,
	valor_unitario,

	TRY_CONVERT
	(
		DECIMAL(12,2),

		REPLACE
		(
			valor_unitario,
			N',',
			N'.'
		)
	) AS valor_unitario_tratado

FROM staging.vendas_csv;

/*
Essa transformação é adequada para o pequeno exemplo controlado. Em fontes reais, separadores de milhar e decimal precisam de uma regra mais precisa.

Por exemplo:

1.234,56

não poderia ser tratado corretamente apenas trocando vírgula por ponto:

1.234.56
*/

-- Consulta completa de transformação
SELECT
    data_venda AS data_venda_original,

    COALESCE
    (
        TRY_CONVERT
        (
            DATE,
            data_venda,
            23
        ),

        TRY_CONVERT
        (
            DATE,
            data_venda,
            103
        )
    ) AS data_venda_tratada,

    cliente_email AS email_original,

    LOWER
    (
        LTRIM
        (
            RTRIM
            (
                cliente_email
            )
        )
    ) AS email_tratado,

    sku,

    filial,

    quantidade AS quantidade_original,

    TRY_CONVERT
    (
        INT,
        quantidade
    ) AS quantidade_tratada,

    valor_unitario AS valor_original,

    TRY_CONVERT
    (
        DECIMAL(12,2),

        REPLACE
        (
            valor_unitario,
            N',',
            N'.'
        )
    ) AS valor_tratado

FROM staging.vendas_csv;

-- Classificando a transformação

SELECT
    cliente_email,
    sku,

    CASE
        WHEN data_venda IS NULL
            OR LTRIM(RTRIM(data_venda)) = N''
        THEN N'REJEITADO: data ausente'

        WHEN COALESCE
            (
                TRY_CONVERT
                (
                    DATE,
                    data_venda,
                    23
                ),

                TRY_CONVERT
                (
                    DATE,
                    data_venda,
                    103
                )
            ) IS NULL
        THEN N'REJEITADO: data_inválida'

        WHEN cliente_email IS NULL
          OR LTRIM(RTRIM(cliente_email)) = N''
        THEN N'REJEITADO: email ausente'

        WHEN TRY_CONVERT
            (
                INT,
                quantidade
            ) IS NULL
        THEN N'REJETADO: quantidade não numérica'

        WHEN TRY_CONVERT
            (
                INT,
                quantidade
            ) <= 0
         THEN N'REJEITADO: quantidade deve ser positiva'

         WHEN TRY_CONVERT
              (
                
                DECIMAL(12,2),

                REPLACE
                (
                    valor_unitario,
                    N',',
                    N'.'
                )
           ) IS NULL
         THEN N'REJEITADO: valor não númerico'

         WHEN TRY_CONVERT
             (
                DECIMAL(12,2),

                REPLACE
                (
                    valor_unitario,
                    N',',
                    N'.'
                )
             ) <= 0
          THEN N'REJEITADO: valor deve ser positivo.'

          ELSE N'APROVADO'
    END AS status_transformacao

FROM staging.vendas_csv;

/*
Por que Carla não é rejeitada pelo valor 80,50?

Porque a transformação:

REPLACE
(
valor_unitario,
N',',
N'.'
)

produz:

80.50
 

que pode ser convertido para DECIMAL(12,2).

O problema impeditivo da linha continua sendo:

quantidade = duas

Por que o cliente inválido para na data?

O CASE avalia as condições de cima para baixo.
*/

-- Resumo por status

SELECT
    status_transformacao,
    COUNT(*) AS total
FROM
(
    SELECT
        CASE
            WHEN data_venda IS NULL
              OR LTRIM(RTRIM(data_venda)) = N''
            THEN N'REJEITADO: data ausente'

            WHEN COALESCE
                 (
                     TRY_CONVERT
                     (
                         DATE,
                         data_venda,
                         23
                     ),

                     TRY_CONVERT
                     (
                         DATE,
                         data_venda,
                         103
                     )
                 ) IS NULL
            THEN N'REJEITADO: data inválida'

            WHEN cliente_email IS NULL
              OR LTRIM(RTRIM(cliente_email)) = N''
            THEN N'REJEITADO: email ausente'

            WHEN TRY_CONVERT
                 (
                     INT,
                     quantidade
                 ) IS NULL
            THEN N'REJEITADO: quantidade não numérica'

            WHEN TRY_CONVERT
                 (
                     INT,
                     quantidade
                 ) <= 0
            THEN N'REJEITADO: quantidade deve ser positiva'

            WHEN TRY_CONVERT
                 (
                     DECIMAL(12,2),
                     REPLACE(valor_unitario, N',', N'.')
                 ) IS NULL
            THEN N'REJEITADO: valor não numérico'

            ELSE N'APROVADO'
        END AS status_transformacao

    FROM staging.vendas_csv
) AS validacao
GROUP BY status_transformacao
ORDER BY status_transformacao;

