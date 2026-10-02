USE DataCommerce;
GO

IF OBJECT_ID
(
	N'auditoria.execucoes_procedures',
	N'U' -- Esse 'u' é de USER TABLE. Deixa explícito que buscamos TABELAS, e evita de conflitar com VIEWS de mesmo nome
			-- Afinal, é tudo objeto mesmo.
) IS NULL
BEGIN
	CREATE TABLE auditoria.execucoes_procedures
	(
		execucao_id INT IDENTITY(1,1) NOT NULL,

		nome_procedure NVARCHAR(160) NOT NULL,

		parametros NVARCHAR (1000) NOT NULL,

		login_execucao SYSNAME NOT NULL -- SYSNAME é um tipo utilizado pelo SQL Server para armazenar nomes de objetos e identidades.
			CONSTRAINT DF_execucores_procedures_login
			DEFAULT SUSER_SNAME(),

		data_execucao DATETIME2 NOT NULL
			CONSTRAINT DF_execucao_procedures_data
			DEFAULT SYSDATETIME(),

		CONSTRAINT PK_execucao_procedures
			PRIMARY KEY (execucao_id)
	);
END;
GO

-- Registro manual inicial

INSERT INTO auditoria.execucoes_procedures
(
	nome_procedure,
	parametros
) 
VALUES
(
	N'origem.sp_vendas_por_periodo',
	N'2026-08-01 a 2026-09-30'
);
GO

SELECT *
FROM auditoria.execucoes_procedures
ORDER BY execucao_id;

-- Fiz cagada e dupliquei a chamada

SELECT
    execucao_id,
    nome_procedure,
    parametros,
    login_execucao,
    data_execucao
FROM auditoria.execucoes_procedures
WHERE execucao_id = 2;

DECLARE @LinhasExcluidas INT;

BEGIN TRANSACTION

DELETE FROM auditoria.execucoes_procedures
WHERE execucao_id = 2;

SET @LinhasExcluidas = @@ROWCOUNT;

SELECT
	@LinhasExcluidas as Linhas_excluidas;

SELECT *
FROM auditoria.execucoes_procedures
ORDER BY execucao_id;

IF @LinhasExcluidas = 1
BEGIN
	COMMIT;
END
ELSE
BEGIN
	ROLLBACK;

	THROW 50005,
		  N'A limpeza deveria excluir exatamente um registro.',
		  1;
END;

