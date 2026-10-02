-- Antes de criar, primeiro, descobrimos onde estamos;

SELECT
	@@SERVERNAME AS servidor,
	DB_NAME() as banco_atual,
	SUSER_SNAME() as login_atual; -- Lembrando que cada expressão separada por vírgula, produz uma coluna

	-- Select não altera nada.

-- Banco master é o banco de sistema do SQL Server. 
/*
Ele guarda informações fundamentais relacionadas à instância, incluindo a existência
dos bancos administrador por ela.

Você não deve criar as tabelas do projeto dentro do master.

O objetivo é:

Instância
├── master
├── model
├── msdb
├── tempdb
└── DataCommerce -> banco separado, desticado ao nosso laboratório
*/

-- Primeiro contato com o CREATE DATABASE;

CREATE DATABASE DataCommerce; --> 'Crie um banco de dados chamado DataCommerce'

/*

	CREATE -> Cria algo. Comando de definição estrutral.
		|
	DATABASE -> Determina qual tipo de objeto criado.
		|
		└ O SQL Server cria nesta instância um banco de dados chamado DataCommerce

Diferente do SELECT, esse altera o ambiente. Ele cria;
  - Uma estrutura lógica de banco;
  - Arquivos físicos associados ao banco;
  - Registros internos para que a instância conheça esse banco.

Veremos arquivos de dados e logs na aula 2.
*/

-- Se o banco já existir, o SQL Server retornará um erro.
	-- Isso acontece porque uma mesma instância não pode ter dois bancos com o mesmo nome.

-- Para estudar com segurança, podemos verificar antes:
if DB_ID('DataCommerce') is NULL 
BEGIN
	CREATE DATABASE DataCommerce;
END;

/*
DB_ID() -> procura o identificador interno de um banco;
	DB_ID('DataCommerce') pergunta conceitualmente
	"Existe um banco chamado DataCommerce nesta instância? Se existir, qual é seu identificador?"

Se o banco não existir, o resultado será NULL, que é um valor desconhecido (não é 0, 1, '', espaço em branco e nem a palavra 'NULL'. É a literal ausência de um valor)
Portanto; "DB_ID('DataCommerce) IS NULL" pode ser lido como:
		O identificador do banco DataCommerce está ausente?
Se estiver, significa que o banco não foi encontrado.
*/

-- IF cria uma decisão:

/*
SE determinada condição for verdadeira
FAÇA determinada ação

Neste caso:
IF DB_ID('DataCommerce') IS NULL
L 'Se o identificador 'DataCommerce' não existir nessa instância...
*/

-- BEGIN e END Delimitam o bloco controlado pelo IF:

/*
BEGIN
	CREATE DATABASE DataCommerce;
END;
L '... Então execute tudo que estiver entre BEGIN e END.'
*/

-- Fluxo Completo

/*
Procurar DataCommerce
		↓
O banco existe?
	┌────┴────┐
	NÃO		 SIM
	↓		  ↓
	Criar	Não criar

*/

-------------------------------> USE <-------------------------------

-- O que o USE master faz?

USE master;

/*
Muda o contexto atual da sessão para o banco master
  Pode ser lido como "A partir daqui, considere master com o banco atual."

Mantem-se a mesma instância e conexão, apenas se muda o banco.

Antes:

Instância: .\SQLEXPRESS
Banco atual: qualquer banco anteriormente selecionado

Depois:

Instância: .\SQLEXPRESS
Banco atual: master
*/

-- O que é o GO?

/*
Aqui existe uma pegadinha importante:

  - GO não uma instrução T-SQL processada diretaemnte pelo mecanismo do SQL Server.

Ele é um separador de loter reconhecidos por ferramentas como o SSMS.

E o que é um lote?

Um lote, ou batch, é um grupo de instruções enviado em conjunto para o SQL Server.

Observe:
*/

USE master;
GO

SELECT DB_NAME() AS banco_atual;

/*
O SSMS divide isso em dois lotes:

Lote 1
USE master;

lote 2
SELECT DB_NAME() AS banco_atual;

Analogia
  Imagine que o SSMS esteja montando envelopes:

Envelope 1:
USE master;

Envelope 2:
...

Quando encontra um GO, ele fecha o envelope atual e envia aquele conjunto de comandos ao SQL Server.

GO não pede vírgula; O ponto e vírgula encerra instruções T-SQL. Como GO é um separador
interpretado pea ferramenta cliente, ele fica sozinho na linha.
*/

-- Mudando para o novo banco;
  -- Após a criação, execute:

USE DataCommerce;
GO

SELECT DB_NAME() AS banco_atual;

-- SCRIPT COMPLETO:

USE master;
GO

IF DB_ID('DataCommerce') IS NULL
BEGIN
	CREATE DATABASE DataCommerce;
END;
GO

USE DataCommerce;
GO

SELECT
	@@SERVERNAME AS servidor,
	DB_NAME() AS banco_atual,
	SUSER_SNAME() AS login_atual;

-- Checando existência do banco sem usar o Object Explorer

SELECT
	name AS nome_banco,
	database_id AS identificador,
	state_desc AS estado
FROM sys.databases
WHERE name = 'DataCommerce';

/*
Leitura inicial
  FROM sys.databases
		L Significa que os dados serão lidos da visão de sistema:

  sys.databases
		L Ela fornece informações sobre bancos conhecidos pela instância.

  WHERE name = 'DataCommerce'
		L Filtra o resultado:
			'Retorne somente a linha cujo nome seja DataCommerce.'

Resultado esperado:

nome_banco		|	identificador	|	 estado
DataCommerce	|	algum número	| ONLINE
*/

/*
É importante validar com o SQL, por o Object Exploter pode:
 - Estar desatualizado visualmente;
 - Estar conectado a outra instância;
 - Não ter sido atualizado após a criação;
 - Mostrar muitos objetos e dificultar a conferência.
*/