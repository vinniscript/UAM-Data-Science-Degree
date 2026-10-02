-- Atualizando a procedure para automaticamente registrar em auditoria.execucoes_procedures

CREATE OR ALTER PROCEDURE origem.sp_vendas_por_periodo
	@data_ini DATE,
	@data_fim DATE
AS
BEGIN
	SET NOCOUNT ON;

	IF @data_ini IS NULL
	BEGIN
		THROW 50001,
			  N'A data inicial é obrigatória.',
			  1;
	END;

	IF @data_fim IS NULL
	BEGIN
		THROW 50002,
			  N'A data final é obrigatória.',
			  1;
	END;

	IF @data_ini > @data_fim
	BEGIN
		THROW 50003,
			  N'A data inicial não pode ser posterior a data final.',
			  1;
	END;

	INSERT INTO auditoria.execucoes_procedures
	(
		nome_procedure,
		parametros
	)
	VALUES
	(	
		N'origem.sp_vendas_por_periodo',

		CONCAT
		(
			CONVERT
			(
				CHAR(10),
				@data_ini,
				23
			), -- Transforma a data incial em texto, no formato; AAAA-MM-DD

			N' a ', -- Coloca um 'a' no meio. Para ficar algo como "2026-08-01 a 2026-09-30"

			CONVERT
			(
				CHAR(10),
				@data_fim,
				23
			) 
		)
	);

	SELECT
		filial,
		SUM(valor_total) AS faturamento
	FROM origem.vw_vendas_operacionais
	WHERE data_pedido BETWEEN @data_ini AND @data_fim
	GROUP BY filial
	ORDER BY filial

END;
GO

-- Validando quantos registros temos na tabela de auditoria de procedures

SELECT
COUNT(*) AS total_antes
FROM auditoria.execucoes_procedures; -- a esse ponto, precisa retornar apenas 1

-- Agora vamos executar a procedura. É para adicionar sozinha agora na auditoria

EXEC origem.sp_vendas_por_periodo
	@data_ini = '2026-08-01',
	@data_fim = '2026-08-31';

-- Agora consultamos para ver se realmente foi o caso:

SELECT
    execucao_id,
    nome_procedure,
    parametros,
    login_execucao,
    data_execucao
FROM auditoria.execucoes_procedures
ORDER BY execucao_id;

-- Vendo se ele realmente não está registrando erros

SELECT
COUNT(*) AS total_antes_erro
FROM auditoria.execucoes_procedures;

EXEC origem.sp_vendas_por_periodo
    @data_ini = NULL,
    @data_fim = '2026-08-31';

SELECT
    COUNT(*) AS total_depois_erro
FROM auditoria.execucoes_procedures;

/*
Não execute mais 

INSERT INTO auditoria.execucoes_procedures

Agora o registro pertence à própria rotina. Cada execução válida produzirá uma linha legítima de auditoria, 
mesmo que os parâmetros sejam iguais aos de uma execução anterior.
*/

DECLARE @LinhasExcluidas INT;

BEGIN TRANSACTION

DELETE FROM auditoria.execucoes_procedures
WHERE execucao_id IN
(
	4,
	5
);

SET @LinhasExcluidas = @@ROWCOUNT

SELECT	
	@LinhasExcluidas AS linhas_excluidas;

SELECT *
FROM auditoria.execucoes_procedures
ORDER BY execucao_id;

IF @LinhasExcluidas = 2
BEGIN
	COMMIT;
END
ELSE
BEGIN
	ROLLBACK;
	THROW 50006,
		  N'A limpeza deveria excluir apenas dois registros',
		  1
END;

