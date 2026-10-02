USE master;
GO

-- Esse if Begin é apenas para ser reexecutável em outros contextos, dispositivos. Também assim, a consulta não da erro caso já exista um banco ou não

IF DB_ID(N'DataCommerce_TesteRestore') IS NOT NULL -- Caso já exista um banco, reexecute tudo abaixo...
BEGIN
	ALTER DATABASE DataCommerce_TesteRestore
		SET SINGLE_USER -- Coloca temporariamente o banco em modo de usuario único
		-- O objetivo é impedir que outras sessões mantenham conexões abertas enquanto tentamos excluir o banco de teste.
		WITH ROLLBACK IMMEDIATE;

		/*
		Solicita o encerramento imediato de outras transações e conexões existentes no banco, revertendo trabalho não confirmado.
		Isso é destrutivo para sessões conectadas àquele banco. Aqui estamos aplicando somente ao banco descartável:
		*/

	DROP DATABASE DataCommerce_TesteRestore; -- Exclui a cópia antiga antes de refazer o teste.
	-- Sem essa limpeza, uma segunda execução poderia falhar porque o banco e arquivos físicos já existiram
END;
GO

RESTORE DATABASE DataCommerce_TesteRestore -- Esse será o nome da nova cópia registrada na instância
FROM DISK = N'/var/opt/mssql/backup/DataCommerce_full2.bak' -- Onde no disco se encontra o backup
WITH
	MOVE N'DataCommerce'
		TO
N'/var/opt/mssql/data/DataCommerce_TesteRestore.mdf',
-- Esse primeiro MOVE pode ser lido como:
	-- Pegue o arquivo lógico de dados DataCommerce, existente dentro do backup, e restaure-o neste novo caminho físico

	MOVE N'DataCommerce_log'
		TO
N'/var/opt/mssql/data/DataCommerce_TesteRestore_log.ldf',
-- Já o segundo, lê-se:
	-- Faça o mesmo feito anteriormente, porém com o arquivo de log (A existência de ambos os arquivos podem ser vistas pelo RESTORE FILELISTONLY)

/*
Porque estes já pertencem ao banco ativo:

/var/opt/mssql/data/DataCommerce.mdf
/var/opt/mssql/data/DataCommerce_log.ldf

Usaremos novos nomes físicos:

/var/opt/mssql/data/DataCommerce_TesteRestore.mdf
/var/opt/mssql/data/DataCommerce_TesteRestore_log.ldf

Assim, o banco original e o restaurado podem coexistir.

Renomear o banco no restore não renomeia automaticamente os nomes lógicos internos. 
O MOVE muda os caminhos físicos.
*/

	RECOVERY, -- Finaliza a recuperação e deixa o banco disponível para uso.
-- Neste laboratório, não aplicaremos backups diferenciais ou de log depois do backup completo. Portanto, a restauração pode ser finalizada imediatamente.
	CHECKSUM, -- Pede que os checksums existentes no bakcup sejam verificados durante o restore.
	STATS = 10; -- Mostra o progresso na aba Mensagens em porcentagens de 10 em 10
GO

-- Validação de banco restaurado:

SELECT
	name AS banco,
	state_desc AS estado,
	recovery_model AS modelo_recuperacao,
	create_date AS registrado_na_instancia
FROM sys.databases
WHERE name IN
(
	N'DataCommerce',
	N'DataCommerce_TesteRestore'
)
ORDER BY name;

-- Validação dos arquivos físicos restaurados:

USE DataCommerce_TesteRestore;
GO

Select
	name as nome_logico,
	type_desc AS tipo,
	physical_name AS caminho_fisico,
	CAST(size * 8.0 / 1024 AS DECIMAL(12,2)) AS tamanho_mb,
	state_desc AS estado
FROM sys.database_files
ORDER BY file_id;

-- Validação dos dados

SELECT
	COUNT(*) AS total_aulas
FROM auditoria.controle_aulas;

SELECT
	COUNT(8) AS total_fontes
FROM auditoria.fontes_dados;

SELECT
	COUNT(*) AS total_parametros
FROM auditoria.parametros;

-- Comparar original e restaurado

use master;
GO

SELECT
	N'Original' AS origem,
	COUNT(*) AS total_fontes
FROM DataCommerce.auditoria.fontes_dados

UNION ALL -- Une duas contagens diferentes como se fosse uma mesma tabela. (Comente para ver a diferença sem ele)

SELECT 
	N'Restaurado' AS origem,
	COUNT(*) AS total_fontes
FROM DataCommerce_TesteRestore.auditoria.fontes_dados;

-- Voltando para o banco base para não preencher o banco errado

USE DataCommerce;

GO
SELECT DB_NAME() AS banco_atual

SELECT
    fonte_id,
    nome_fonte,
    tipo,
    destino,
    observacao
FROM DataCommerce.auditoria.fontes_dados

EXCEPT

SELECT
    fonte_id,
    nome_fonte,
    tipo,
    destino,
    observacao
FROM DataCommerce_TesteRestore.auditoria.fontes_dados;

SELECT
    fonte_id,
    nome_fonte,
    tipo,
    destino,
    observacao
FROM DataCommerce_TesteRestore.auditoria.fontes_dados

EXCEPT

SELECT
    fonte_id,
    nome_fonte,
    tipo,
    destino,
    observacao
FROM DataCommerce.auditoria.fontes_dados;


-- Revisando se ainda estamos no banco certo com tudo correto;

USE DataCommerce;
GO

SELECT
	DB_NAME() AS banco_atual,
	SUSER_SNAME() AS login_atual;
GO

SELECT
	s.name AS schema_nome,
	t.name AS tabela_nome
FROM sys.tables AS t -- Lê as tabelas conhecidas no banco atual
INNER JOIN sys.schemas AS s /* 
- Relaciona cada tabela ao seu schema. É justamente um relacionamento
entre duas visões de catálogo:

sys.tables.schema_id
           ↓
sys.schemas.schema_id


*/
	ON s.schema_id = t.schema_id
WHERE s.name = N'origem'
  AND t.name IN
  (
      N'clientes',
	  N'produtos',
	  N'pedidos',
	  N'itens_pedidos'
  )
ORDER BY t.name;