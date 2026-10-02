RESTORE FILELISTONLY
FROM DISK = '/var/opt/mssql/backup/DataCommerce_full.bak';
GO

/*
Esses são os nomes lógicos que precisam ser usados no WITH MOVE. 
Eles não são caminhos nem nomes físicos de arquivos.
*/

-- Executando o restore com outro nome

USE master;
GO

RESTORE DATABASE DataCommerce_TesteRestore -- cria um segundo banco a partir do backup
FROM DISK = '/var/opt/mssql/backup/DataCommerce_full.bak'
WITH
	MOVE 'DataCommerce'
		TO
'/var/opt/mssql/data/DataCommerce_TesteRestore.mdf',
	MOVE 'DataCommerce_log'
		TO
'/var/opt/mssql/data/DataCommerce_TesteRestore_log.ldf',
	RECOVERY,
	STATS = 10;
GO

-- VERIFYONLY

RESTORE VERIFYONLY -- Apenas valida a existência do restore
FROM DISK = N'/var/opt/mssql/backup/DataCommerce_full2.bak'
WITH CHECKSUM; -- Bate o SHA256 que criamos no backup, se realmente bater, o restore é valido e não foi alterado/corrompido 
GO

RESTORE HEADERONLY -- Pega o cabeçalho desse restore. Um amalgama de informações do arquivo de sistema
FROM DISK =N'/var/opt/mssql/backup/DataCommerce_full2.bak';
GO

RESTORE FILELISTONLY
FROM DISK =N'/var/opt/mssql/backup/DataCommerce_full2.bak';
GO