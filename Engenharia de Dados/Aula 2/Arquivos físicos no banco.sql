USE DataCommerce;
GO

SELECT
	file_id, -- Identificador do arquivo
	name AS nome_logico, -- Nome lógico que o SQL Server usa internamente para identificar o arquivo. Não é necessariamente igual ao nome físico do arquivo.
	type_desc AS tipo_arquivo, -- Tipo do arquivo | ROWS - Representa os dados; LOG - Representa arquivo de log transacional 
	physical_name AS caminho_fisico, -- É o caminho reconhecido pelo sistema operacional onde o SQL Server está executando.
	CAST(size * 8.0 / 1024 AS DECIMAL(12,2)) AS tamanho_mb, /*
		O SQL Server organiza os dados em páginas de 8 KB, que são sua unidade básica de armazenamento.
		Por isso, "size" (em páginas) × 8 / 1024 converte o tamanho para MB.

		size
		 Retorna a quantidade de páginas de 8 KB que o arquivo possui.

		size × 8.0
		 Converte a quantidade de páginas em KB, pois cada página possui 8 KB.

		size × 8.0 ÷ 1024
		 Converte o tamanho de KB para MB, pois 1 MB corresponde a 1.024 KB.

		 Exemplo rápido

		Se size = 128:

		128 páginas × 8 KB = 1.024 KB
		1.024 KB ÷ 1.024 = 1 MB

		O .0 também é útil: ele força o cálculo decimal e evita que o 
		SQL Server faça somente divisão inteira, que poderia eliminar as casas decimais.

	*/
	state_desc AS estado -- Mostra o estado do arquivo
FROM sys.database_files
ORDER BY file_id

-- Identificar o ambiente do servidor

SELECT
	@@SERVERNAME AS servidor,
	SERVERPROPERTY('MachineName') AS maquina,
	SERVERPROPERTY('ServerName') AS instancia,
	SERVERPROPERTY('Edition') AS edicao,
	SERVERPROPERTY('ProductVersion') AS versao,
	DB_NAME() AS banco_atual;

	/*
	Ajuda a comparar:

	onde o SSMS está aberto
	versus
	onde o SQL Server está executando
	*/

EXEC master.dbo.xp_fileexist
	N'/var/opt/mssql/backup';

-- Não é bom utilizar caminhos internos do windows no SQL Server em um docker.

-- Vamos registrar um parâmetro específico para backup:

USE DataCommerce;
GO

IF NOT EXISTS
(
	SELECT 1
	FROM auditoria.parametros
	WHERE parametro = N'PASTA_BACKUP_SQL'
)
BEGIN
	INSERT INTO auditoria.parametros
	(
		parametro,
		valor,
		descricao
	)
	VALUES
	(
		N'PASTA_BACKUP_SQL',
		N'/var/ópt/mssql/backup',
		N'Pasta de backup visível para o SQL Server no contêiner Linux'
	);
END;
GO

-- Correção, pois eu escrevi errado o valor da primeira linha
UPDATE auditoria.parametros
SET valor = N'/var/opt/mssql/backup'
WHERE parametro = N'PASTA_BACKUP_SQL';

-- Valide

SELECT
	parametro,
	valor,
	descricao
FROM auditoria.parametros
ORDER BY parametro;

-- Outro backup com mais parâmetros

USE master;
GO

BACKUP DATABASE DataCommerce
TO DISK = N'/var/opt/mssql/backup/DataCommerce_full2.bak' -- Define qual o arquivo de destino visto pelo SQL Server
WITH -- Iniciador de parâmetros quando usado logo após o função de backup
	INIT, -- Reinicializa o arquivo de backup de destino (Não apaga o banco)
	COMPRESSION, -- Diminui o tamanho do arquivo
	CHECKSUM, -- Cria um hash para consolidar a integridade do backup
	STATS = 10, -- De quanto em quanto será a mostragem do progresso em porcentagem | 10%, 20%, 30%...
	NAME = N'Backup completo DataCommerce'; -- Um nome descritivo
GO
