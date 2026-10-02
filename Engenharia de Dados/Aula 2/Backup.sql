BACKUP DATABASE DataCommerce -- Define qual banco será copiado
TO DISK = '/var/opt/mssql/backup/DataCommerce_full.bak' -- O arquivo de destino
WITH
	INIT, -- Sobrescreve o conteúdo anterior do arquivo.bak, caso já exista
	COMPRESSION, -- Solicita a compactação do backup
	NAME = 'Backup completo Datacommerce'; -- Atribui um nome descritivo ao conjunto de backup
GO -- Encerra e envia o lote para execução.

/*

O arquivo saiu do contêiner:


/var/opt/mssql/backup/DataCommerce_full.bak


e foi copiado para:


/mnt/c/users/vini/OneDrive - Cast Informatica SA/Documentos/UAM/8º Semestre/Engenharia de Dados/Meus estudos/DataCommerce/Backups SQL/DataCommerce_full.bak


O tamanho transferido foi de aproximadamente 899 kB.

Para conferir o arquivo no OneDrive pelo Ubuntu:


ls -lh "$BKP/DataCommerce_full.bak"


Para abrir a pasta no Explorador do Windows:


explorer.exe "$(wslpath -w "$BKP")"


E, se quiser conferir com segurança que a cópia está idêntica ao arquivo do contêiner, compare os hashes SHA-256:


docker exec 298833a861ad sha256sum /var/opt/mssql/backup/DataCommerce_full.bak

sha256sum "$BKP/DataCommerce_full.bak"


Os dois hashes devem ser exatamente iguais. Agora você tem:

uma cópia dentro do contêiner, para realizarmos o restore da aula;
uma cópia fora do Docker, na pasta sincronizada pelo OneDrive;
proteção caso o contêiner seja removido ou corrompido.

Backup preservado. Bora para o restore de validação.

*/