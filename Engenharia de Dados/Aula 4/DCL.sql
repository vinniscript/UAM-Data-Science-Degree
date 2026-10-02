-- DCL = Data Control Language

/*
Enquanto:

DDL → estrutura
DML → dados
DQL → consultas

O DCL controle:

Quem pode fazer o quê

Comandos que veremos serão:

GRANT
DENY
REVOKE
*/

-- Senha temporaria muito forte

-- N'Gr0up!4Dm1n@22'

USE MASTER;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.server_principals -- Contém identidades conhecidas no nível da instância, incluindo logins
	WHERE name = N'aluno_leitura'
)
BEGIN
	CREATE LOGIN aluno_leitura
	WITH
		PASSWORD = N'Gr0up!4Dm1n@22',
		CHECK_POLICY = ON, -- Solicita aplicação da política de senha disponível no ambiente.
		CHECK_EXPIRATION = OFF; -- Não queremos que a senha expire nesse laboratório
END;
GO

-- Criação do usuário no DataCommercer

USE DataCommerce;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.database_principals
	WHERE name = N'aluno_leitura'
)
BEGIN
	CREATE USER aluno_leitura
	FOR LOGIN aluno_leitura;
END;
GO

/*
O login poderia existir sem usuário no DataCommerce. Nesse caso, 
conseguiria autenticar na instância, mas não teria automaticamente acesso funcional ao banco.
*/

-- Criando a role

IF NOT EXISTS
(
	SELECT 1
	FROM sys.database_principals
	WHERE NAME = N'perfil_consulta_operacional'
	  AND TYPE = 'R' -- Significa que procuramos uma Role
)
BEGIN
	CREATE ROLE perfil_consulta_operacional;
END;
GO

-- Adicionando usuário à role

IF NOT EXISTS
(
	SELECT 1
	FROM sys.database_role_members AS drm

	INNER JOIN sys.database_principals AS r
		ON r.principal_id = drm.role_principal_id

	INNER JOIN sys.database_principals AS u
		ON u.principal_id = drm.member_principal_id

	WHERE r.name = N'perfil_consulta_operacional'
		AND u.name = N'aluno_leitura'
)
BEGIN 
	ALTER ROLE perfil_consulta_operacional
	ADD MEMBER aluno_leitura;
END;
GO

-- Concedendo acesso somente à view

GRANT SELECT
ON OBJECT::origem.vw_vendas_operacionais -- nossa view
TO perfil_consulta_operacional; -- nossa role
GO

-- Negando alterações no schema

DENY INSERT, UPDATE, DELETE
ON SCHEMA::origem -- Aplica a negação a todas as tabelas do schema origem
TO perfil_consulta_operacional; -- e a todos cujo estão com essa ROLE definidas em seu usuário
GO

-- Validando a estrutura de segurança

SELECT
	dp.name AS usuario,
	dp.type_desc AS tipo
FROM sys.database_principals AS dp
WHERE dp.name IN
(
	N'aluno_leitura',
	N'perfil_consulta_operacional'
)
ORDER BY dp.name;

-- Agora suas associações

SELECT 
	r.name AS role_nome,
	u.name AS membro
FROM sys.database_role_members AS drm

INNER JOIN sys.database_principals AS r
	ON r.principal_id = drm.role_principal_id

INNER JOIN sys.database_principals AS u
	ON u.principal_id = drm.member_principal_id

WHERE r.name = N'perfil_consulta_operacional';

-- Visualizando as permissões concedidas
SELECT
    pr.name AS principal,

    pe.state_desc AS estado,

    pe.permission_name AS permissao,

    pe.class_desc AS classe,

    CASE
        WHEN pe.class_desc = N'SCHEMA'
        THEN SCHEMA_NAME(pe.major_id)

        WHEN pe.class_desc = N'OBJECT_OR_COLUMN'
        THEN OBJECT_SCHEMA_NAME(pe.major_id)
    END AS schema_alvo,

    CASE
        WHEN pe.class_desc = N'OBJECT_OR_COLUMN'
        THEN OBJECT_NAME(pe.major_id)

        WHEN pe.class_desc = N'SCHEMA'
        THEN N'Todos os objetos do schema'
    END AS objeto_alvo

FROM sys.database_permissions AS pe

INNER JOIN sys.database_principals AS pr
    ON pr.principal_id = pe.grantee_principal_id

WHERE pr.name = N'perfil_consulta_operacional'

ORDER BY
    pe.class_desc,
    pe.state_desc,
    pe.permission_name;

-- Testando sem abrir outra permissão

USE DataCommerce;
GO

EXECUTE AS USER = N'aluno_leitura';

/*
testa o contexto e as permissões do usuário dentro do banco.

Isso não testa a autenticação real do login com senha pela rede. 
Para testar login e senha, seria necessário abrir uma nova conexão no SSMS. 
Para validar as permissões de banco nesta etapa, a simulação é suficiente.
*/

SELECT
	USER_NAME() AS usuario_simulado;

-- Teste permitido

SELECT
    pedido_id,
    cliente,
    vendedor,
    produto,
    valor_total
FROM origem.vw_vendas_operacionais
ORDER BY
    pedido_id,
    produto;

-- Teste de alteração com proteção adicional

BEGIN TRY 
	BEGIN TRANSACTION

	UPDATE origem.clientes
	SET uf = 'MG'
	WHERE email = N'ana@datacommerce.com'; -- Aqui vai dar erro de SELECT, ironicamente, pois na ordem, primeiro o banco tenta achar o atributo para bater a informação, depois vem o UPDATE
		-- Porém o aluno_leitura tem permissão de leitura apenas NA VIEW, não em origem.clientes. Então o erro nem vai dar no UPDATE, vai ser direto no SELECT

	ROLLBACK;

	SELECT
		N'Atenção: o UPDATE foi permitido, mas foi desfeito.';
END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK;
	END;

	SELECT
		ERROR_NUMBER() AS numero_erro,
		ERROR_MESSAGE() AS mensagem_erro;

END CATCH;

-- Retornando ao usuario anterior

REVERT;

SELECT
	USER_NAME() AS usuario_restaurado,
	SUSER_SNAME() AS login_atual;

-- Teste direto do DENY UPDATE
	-- Podemos verificar a permissão efetiva sem tentar alterar nada

USE DataCommerce;
GO

EXECUTE AS USER = N'aluno_leitura';

SELECT
	HAS_PERMS_BY_NAME
	(
		N'origem.clientes',
		N'OBJECT',
		N'SELECT'
	) AS [Pode dar 'SELECT' em clientes?],

	HAS_PERMS_BY_NAME
	(
		N'origem.clientes',
		N'OBJECT',
		N'UPDATE'
	) AS [Pode dar 'UPDATE' em clientes?],

	HAS_PERMS_BY_NAME
	(
		N'origem.vw_vendas_operacionais',
		N'OBJECT',
		N'SELECT'
	) AS [Pode dar 'SELECT' na VIEW?],

	HAS_PERMS_BY_NAME
	(
		N'origem.vw_vendas_operacionais',
		N'OBJECT',
		N'UPDATE'
	) AS [Pode dar 'UPDATE' na VIEW?];

REVERT;

