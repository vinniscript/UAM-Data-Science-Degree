-- Agora que temos os dados brutos gravados e suas transformações, partiremos para a gravação dos dados em linhas aprovadas pela estrutura tipada

-- Criar uma staging tratada

USE DataCommerce
GO

IF OBJECT_ID
(
	N'staging.vendas_tratadas',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE staging.vendas_tratadas
	(
		data_venda DATE NOT NULL,

		cliente_email NVARCHAR(160) NOT NULL,

		sku NVARCHAR(30) NOT NULL,

		filial NVARCHAR(80) NOT NULL,

		quantidade INT NOT NULL,

		valor_unitario DECIMAL(12,2) NOT NULL,

		arquivo_origem NVARCHAR(200) NULL,

		data_transformacao DATETIME2 NOT NULL
			CONSTRAINT DF_vendas_tratadas_data
			DEFAULT SYSDATETIME(),

		CONSTRAINT CK_vendas_tratadas_quantidade
			CHECK 
			(
				quantidade > 0
			),

		CONSTRAINT CK_vendas_tratadas_valor
			CHECK
			(
				valor_unitario > 0
			)

	);
END;
GO

/*
Por que essa tabela é diferente da staging bruta?

Na tabela bruta:

data_venda → NVARCHAR
quantidade → NVARCHAR
valor_unitario → NVARCHAR

Na tabela tratada:

data_venda → DATE
quantidade → INT
valor_unitario → DECIMAL

A bruta preserva o que chegou.

A tratada guarda somente o que já passou pelas regras técnicas.
*/

SELECT
    ORDINAL_POSITION AS posicao,

    COLUMN_NAME AS coluna,

    DATA_TYPE AS tipo,

    CHARACTER_MAXIMUM_LENGTH AS tamanho,

    NUMERIC_PRECISION AS precisao,

    NUMERIC_SCALE AS escala,

    IS_NULLABLE AS aceita_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'staging'
  AND TABLE_NAME = N'vendas_tratadas'
ORDER BY ORDINAL_POSITION;

-- Visualizar o que será carregado. Antes do INSERT, execute somente o SELECT

SELECT
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
	) AS data_venda,

	LOWER
	(
		LTRIM
		(
			RTRIM
			(
				cliente_email	
			)
		)
	) AS cliente_email,

	LTRIM
	(
		RTRIM
		(
			sku
		)
	) AS sku,

	LTRIM
	(
		RTRIM
		(
			filial
		)
	) AS filial,

	TRY_CONVERT
	(
		INT,
		quantidade
	) AS quantidade,

	TRY_CONVERT
	(
		DECIMAL(12,2),

		REPLACE
		(
			valor_unitario,
			N',',
			N'.'
		)
	) AS valor_unitario,

	arquivo_origem

FROM staging.vendas_csv -- Essa que iremos inserir. Estamos tratando no SELECT para depois mandar no INSERT, já ciente como vai entrar

WHERE COALESCE
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
	  ) IS NOT NULL

AND cliente_email IS NOT NULL

AND LTRIM
	(
		RTRIM
		(
			cliente_email
		)
	) <> N''

AND TRY_CONVERT
	(
		INT,
		quantidade
	) > 0

AND TRY_CONVERT
	(
		DECIMAL(12,2),
		REPLACE
		(
			valor_unitario,
			N',',
			N'.'
		)
	) > 0

-- Executar a carga com transaçõa

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE staging.vendas_tratadas; -- Limpa a tabela toda, porém mantendo todas as regras para os novos dados

	INSERT INTO staging.vendas_tratadas
	(
		data_venda,
		cliente_email,
		sku,
		filial,
		quantidade,
		valor_unitario,
		arquivo_origem
	)
	SELECT -- Ao invés de inventar valores manuais, o SELECT busca, transforma e filtra linhas de outra tabela, e o INSERT grava o resultado no destino.
			-- O SQL Server aceita tanto VALUES quanto um conjunto de resultados produzido por uma consulta como fonte do INSERT.
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
		),

		LOWER(LTRIM(RTRIM(cliente_email))),
		LTRIM(RTRIM(sku)),
		LTRIM(RTRIM(filial)),

		TRY_CONVERT
		(
			INT,
			quantidade
		),

		TRY_CONVERT
		(
			DECIMAL(12,2),

			REPLACE
			(
				valor_unitario,
				N',',
				N'.'
			)
		),
		
		arquivo_origem

FROM staging.vendas_csv
WHERE COALESCE -- Aqui vamos definir quais linhas devem aparecer. Cada linha deve respeitar o seguinte:
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
	  ) IS NOT NULL

	AND cliente_email IS NOT NULL

	AND LTRIM(RTRIM(cliente_email)) <> N''

	AND TRY_CONVERT
	(
		INT,
		quantidade
	) > 0

	AND TRY_CONVERT
	(
		DECIMAL(12,2),
		REPLACE
		(
			valor_unitario,
			N',',
			N'.'
		)
	) > 0;

	-- A leitura desse INSERT É: Insira em staging.vendas_tratadas todas as linhas produzidas por este SELECT.

	DECLARE @LinhasGravadas INT;

	SET @LinhasGravadas = @@ROWCOUNT

	IF @LinhasGravadas <> 2
	BEGIN
		THROW 50030,
			N'A carga deveria gravar exatamente duas vendas aprovadas.',
			1;
		END;

	COMMIT;

	SELECT
		@LinhasGravadas AS linhas_gravadas;
END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK;
	END;

	SELECT
		ERROR_NUMBER() AS NUMERO_ERRO,
		ERROR_MESSAGE() AS MENSAGEM_ERRO

END CATCH;
GO

-- Validar tabela tratada

SELECT
    data_venda,
    cliente_email,
    sku,
    filial,
    quantidade,
    valor_unitario,
    quantidade * valor_unitario AS valor_total,
    arquivo_origem,
    data_transformacao
FROM staging.vendas_tratadas
ORDER BY data_venda;

-- Conferência das três etapas

SELECT
	N'staging_bruta' AS etapa,
	COUNT(*) AS total
FROM staging.vendas_csv

UNION ALL

SELECT
	N'staging tratada',
	COUNT(*)
FROM staging.vendas_tratadas