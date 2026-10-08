BACKUP DATABASE DataCommerce
TO DISK = '/var/opt/mssql/backups/DataCommerce_pre_ELT_A1.bak'
WITH INIT,
/*
INIT: 
reinicia o arquivo e sobrescreve. Fazer backups sem init ele vai criando sets
Cada set contem um cabeçalho do estado do banco e o horário em que foi feito.
Fazer backups diversos sem o INIT vai crescre indefinidamente o arquivo e na hora do RESTORE,
Ele sempre vai trazer o primeiro SET, o mais antigo por padrão. Você define o Set com

WITH FILE = x -> 'x' sendo o numero do FILE que você pega na position quando faz:
	RESTORE HEADERONLY FROM DISK = 'caminho/bkp.bak'
*/
	COMPRESSION,
	STATS = 10;

-- Conferindo o backup

RESTORE VERIFYONLY -- Retorna se o arquivo é legível e aplicável pelo SQL Server
FROM DISK = '/var/opt/mssql/backups/DataCommerce_pre_ELT_A1.bak';
