-- A3 | TechCommerce
	-- Vinicius Pereira de Sousa | 12523163043

USE MASTER; -- Selecionando o banco master para criação
GO

CREATE DATABASE A3_TechCommerce; -- Banco do projeto
GO

USE A3_TechCommerce; -- Trabalharemos em cima dele a partir daqui
GO

-- Validando

SELECT DB_NAME() AS [Nome do banco atual:];

-- Criando a arquitetura

CREATE SCHEMA staging;
GO

CREATE SCHEMA qualidade;
GO

CREATE SCHEMA origem;
GO

CREATE SCHEMA auditoria;
GO

-- Confirmando a criação dos schemas;

SELECT
	name AS schema_name
FROM sys.schemas
WHERE name IN 
(
	N'staging',
	N'qualidade',
	N'origem',
	N'auditoria'
)
ORDER BY name;
	-- Tudo certo até aqui. Agora vamos para a auditoria

CREATE TABLE auditoria.lotes
(
	lote_id INT IDENTITY(1,1) NOT NULL,

	arquivo_origem NVARCHAR(255) NOT NULL,
	tipo_entidade NVARCHAR(50) NOT NULL,

	data_inicio DATETIME2 NOT NULL
		CONSTRAINT DF_auditoria_lotes_data_inicio
		DEFAULT SYSDATETIME(),

	data_fim DATETIME2 NULL,

	registros_recebidos INT NOT NULL
		CONSTRAINT DF_auditoria_lotes_registros_recebidos
		DEFAULT 0,

	registros_aprovados INT NOT NULL
		CONSTRAINT DF_auditoria_lotes_registros_aprovados
		DEFAULT 0,

	registros_rejeitados INT NOT NULL
		CONSTRAINT DF_auditoria_lotes_registros_rejeitados
		DEFAULT 0,

	status_processamento NVARCHAR(30) NOT NULL
		CONSTRAINT DF_auditoria_lotes_status_processamento
		DEFAULT 'INICIADO',

)

SELECT *
FROM auditoria.lotes;

