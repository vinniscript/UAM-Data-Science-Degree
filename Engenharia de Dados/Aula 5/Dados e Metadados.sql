-- Dados versus metadados

/*
Os dados carregados são:

Ana Silva
ana@datacommerce.com
São Paulo
SP

Os metadados descrevem o processo:

Processo: Carga simulada de clientes
Fonte: clientes.csv
Destino: staging.clientes_csv
Linhas lidas: 5
Linhas gravadas: 5
Status: SUCESSO
Fim: data e horário da execução
*/

-- Criar uma nova tabela em staging que salva processos

USE DataCommerce;
GO

IF OBJECT_ID
(
	N'auditoria.log_etl',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE auditoria.log_etl
	(
		log_id INT IDENTITY(1,1) NOT NULL,

		processo NVARCHAR(160) NOT NULL,

		fonte NVARCHAR(260) NULL,

		destino NVARCHAR(160) NULL,

		status NVARCHAR(20) NOT NULL,

		linhas_lidas INT NULL,

		linhas_gravadas INT NULL,

		mensagem NVARCHAR(1000) NULL,

		inicio DATETIME2 NOT NULL
			CONSTRAINT DF_log_etl_inicio
			DEFAULT SYSDATETIME(),

		fim DATETIME2 NULL

		CONSTRAINT PK_log_etl
			PRIMARY KEY (log_id),

		CONSTRAINT CK_log_etl_status
			CHECK
			(
				status IN
				(
					N'INICIADO',
					N'SUCESSO',
					N'FIM'
				)
			),

		CONSTRAINT CK_log_etl_linhas_lidas
			CHECK
			(
				linhas_lidas IS NULL
				OR linhas_lidas >= 0
			),

		CONSTRAINT CK_log_etl_linhas_gravadas
			CHECK
			(
				linhas_gravadas IS NULL
				OR linhas_gravadas >= 0
			)
	);
END;
GO

/*
Por que linhas_lidas e linhas_gravadas não são obrigatórias?

Quando um processo começa, talvez ainda não saibamos quantas linhas serão encontradas.

Por isso, um registro inicial poderia ser:

status = INICIADO
linhas_lidas = NULL
linhas_gravadas = NULL
fim = NULL

Ao terminar, esses valores seriam atualizados.
*/

/*
Por que há uma constraint em status?

Sem a constraint, poderiam aparecer valores inconsistentes:

Sucesso
SUCESSO
sucesso
Finalizado
OK
Concluído
...

A CONSTRAINT limita o vocabúlário
*/

-- Validação da estrutura

SELECT
    ORDINAL_POSITION AS posicao,
    COLUMN_NAME AS coluna,
    DATA_TYPE AS tipo,
    CHARACTER_MAXIMUM_LENGTH AS tamanho_texto,
    IS_NULLABLE AS aceita_null,
    COLUMN_DEFAULT AS valor_padrao
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'auditoria'
  AND TABLE_NAME = N'log_etl'
ORDER BY ORDINAL_POSITION;

-- As constraints também

SELECT
	cc.name AS constraint_nome,
	cc.definition AS definicao
FROM sys.check_constraints AS cc
INNER JOIN sys.tables AS t
	ON t.object_id = cc.parent_object_id
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id
WHERE s.name = N'auditoria'
  AND t.name = N'log_etl'
ORDER BY cc.name;

-- Inserindo o registro em auditoria com proteção para o F5

DECLARE @LinhasRecebidas INT;

SELECT
	@LinhasRecebidas = COUNT(*)
FROM staging.clientes_csv;

SELECT
	@LinhasRecebidas AS linhas_recebidas
-- Para sabermos quantas linhas temos em staging.clientes_csv

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.log_etl
	WHERE processo = N'Carga simulada de clientes'
	AND fonte = N'clientes.csv'
	AND destino = N'staging.clientes_csv'
	AND status = N'SUCESSO'
	AND linhas_lidas = @LinhasRecebidas
	AND linhas_gravadas = @LinhasRecebidas
)
BEGIN
	INSERT INTO auditoria.log_etl
	(
		processo,
		fonte,
		destino,
		status,
		linhas_lidas,
		linhas_gravadas,
		mensagem,
		fim
	)
	VALUES
	(
		N'Carga simulada de clientes',
		N'clientes.csv',
		N'staging.clientes_csv',
		N'SUCESSO',
		@LinhasRecebidas,
		@LinhasRecebidas,
		N'Lote didático inserido manualmente na staging',
		SYSDATETIME()
	);
END;
GO

-- Validando

SELECT -- *
    log_id,
    processo,
    fonte,
    destino,
    status,
    linhas_lidas,
    linhas_gravadas,
    mensagem,
    inicio,
    fim
FROM auditoria.log_etl
ORDER BY log_id;

