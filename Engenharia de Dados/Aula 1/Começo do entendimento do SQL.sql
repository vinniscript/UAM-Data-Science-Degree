-- Informações sobre a conexão e a instância do SQL Server

SELECT @@SERVERNAME AS servidor;
-- Nome do servidor ou da instância à qual a consulta está conectada.

SELECT @@VERSION AS versao;
-- Versão e informações de compilação do mecanismo do SQL Server.
-- Não retorna a versão do SSMS.

SELECT SERVERPROPERTY('Edition') AS edicao;
-- Edição da instância do SQL Server, como Express, Developer ou Standard.
-- Não retorna a edição do SSMS.

SELECT 
	SERVERPROPERTY('ProductVersion') AS versao_produto,
	SERVERPROPERTY('ProductLevel') AS nivel_produto;

SELECT DB_NAME() AS banco_atual;
-- Banco de dados usado como contexto atual da consulta.

SELECT SUSER_SNAME() AS login_atual;
-- Nome do login associado ao contexto de segurança atual.

-- 1 Query, 1+ retornos:
SELECT
    @@SERVERNAME AS servidor,
    DB_NAME() AS banco_atual;
        -- Cada expressão separada por vírgula na lista do SELECT cria uma coluna no resultado requisitado.