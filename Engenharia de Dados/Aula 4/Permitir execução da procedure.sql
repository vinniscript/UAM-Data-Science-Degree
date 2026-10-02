USE DataCommerce;
GO

GRANT EXECUTE
ON OBJECT::origem.sp_vendas_por_periodo
TO perfil_consulta_operacional;
GO

/*

Leia assim:

Conceda à role perfil_consulta_operacional
permissão para executar a procedure origem.sp_vendas_por_periodo.

*/

-- Validando sem executar

EXECUTE AS USER = N'aluno_leitura';

SELECT
	HAS_PERMS_BY_NAME
	(
		N'origem.sp_vendas_por_periodo',
		N'OBJECT',
		N'EXECUTE'
	) AS pode_executar_procedure;

REVERT;

-- Executando como aluno_leitura

EXECUTE AS USER = N'aluno_leitura';

EXEC origem.sp_vendas_por_periodo
    @data_ini = '2026-08-01',
    @data_fim = '2026-09-30';

REVERT;

-- A procedure também tentará inserir uma linha em: auditoria.execucoes_procedures

/*
O usuário não recebeu INSERT diretamente nessa tabela. 
Entretanto, como a operação está encapsulada na procedure e os objetos possuem o
mesmo proprietário, o SQL Server pode permitir o acesso pela cadeia de propriedade do módulo. 
O teste confirmará o comportamento real no seu ambiente.

Depois, conectado novamente como sa, consulte:
*/

SELECT TOP 5 -- Retorna no máximo 5 linhas
    execucao_id,
    nome_procedure,
    parametros,
    login_execucao,
    data_execucao
FROM auditoria.execucoes_procedures
ORDER BY execucao_id DESC; -- Em ordem descendente

-- Remover temporariamente o GRANT EXECUTE

REVOKE EXECUTE
ON OBJECT::origem.sp_vendas_por_periodo
FROM perfil_consulta_operacional;
GO

EXECUTE AS USER =  N'aluno_leitura';

SELECT
    HAS_PERMS_BY_NAME
    (
        N'origem.sp_vendas_por_periodo',
        N'OBJECT',
        N'EXECUTE'
    ) AS pode_executar_apos_revoke;

REVERT;

-- Restaurando

GRANT EXECUTE
ON OBJECT::origem.sp_vendas_por_periodo
TO perfil_consulta_operacional
GO

-- Valide outra vez

EXECUTE AS USER = N'aluno_leitura';

SELECT
    HAS_PERMS_BY_NAME
    (
        N'origem.sp_vendas_por_periodo',
        N'OBJECT',
        N'EXECUTE'
    ) AS pode_executar_restaurado;
REVERT;
