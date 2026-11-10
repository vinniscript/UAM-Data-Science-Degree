-- A3 | TechCommerce
	-- Vinicius Pereira de Sousa | 12523163043

USE MASTER; -- Selecionando o banco master para criação
GO

IF DB_ID(N'A3_TechCommerce') IS NULL
BEGIN
	CREATE DATABASE A3_TechCommerce;
END
GO

GO

USE A3_TechCommerce; -- Trabalharemos em cima dele a partir daqui
GO

-- Validando

SELECT DB_NAME() AS [Nome do banco atual:];

-- Criando a arquitetura

IF SCHEMA_ID(N'staging') IS NULL -- SCHEMA_ID aceita nome quando chamado com parâmetro, sem ele retorna um número
BEGIN
    EXEC ('CREATE SCHEMA staging;');
END
GO


IF SCHEMA_ID(N'qualidade') IS NULL
BEGIN
	EXEC ('CREATE SCHEMA qualidade;')
END
GO

IF SCHEMA_ID(N'origem') IS NULL
BEGIN
	EXEC ('CREATE SCHEMA origem;')
END
GO

IF SCHEMA_ID(N'auditoria') IS NULL
BEGIN
	EXEC ('CREATE SCHEMA auditoria;')
END
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

IF OBJECT_ID
(
	N'auditoria.lotes',
	N'U'
) IS NULL
BEGIN

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

	CONSTRAINT PK_auditoria_lotes_lote_id 
	PRIMARY KEY (lote_id)
);
END
GO

SELECT *
FROM auditoria.lotes;

-- Testando a inserção

INSERT INTO auditoria.lotes
(
    arquivo_origem,
    tipo_entidade
)
VALUES
(
    'TESTE.csv',
    'TESTE'
);

SELECT *
FROM auditoria.lotes;

/*
Nota-se que:

- Apenas 2 inserções manuais, justamente aqueles que não tem constraint DEFAULT ou seja PRIMARY KEY com IDENTITY
- Os registros não são obrigatórios e como não inserimos, eles serão 0 nessa inserção
- data_inicio quem lida é o próprio SQL Server, então não inserimos ele manualmente
*/

-- Apagando o teste

DELETE FROM auditoria.lotes
WHERE arquivo_origem = 'TESTE.csv';
GO

-- Agora criaremos a tabela que receberá os erros

IF OBJECT_ID
(
	N'qualidade.rejeicoes',
	N'U'
) IS NULL
BEGIN

CREATE TABLE qualidade.rejeicoes
    (
        rejeicao_id BIGINT IDENTITY(1,1) NOT NULL,
        lote_id INT NOT NULL,

        entidade NVARCHAR(50) NOT NULL,
        identificador_origem NVARCHAR(100) NULL,

        campo NVARCHAR(100) NULL,
        valor_recebido NVARCHAR(1000) NULL,
        motivo NVARCHAR(1000) NOT NULL,

        data_rejeicao DATETIME2 NOT NULL
            CONSTRAINT DF_rejeicoes_data
            DEFAULT SYSDATETIME(),

        CONSTRAINT PK_rejeicoes
            PRIMARY KEY (rejeicao_id),

        CONSTRAINT FK_rejeicoes_lotes
            FOREIGN KEY (lote_id)
            REFERENCES auditoria.lotes(lote_id)
    );
END
GO

/*

0 rejeições

ou

1 rejeição

ou

N rejeições

Mas cada rejeição(ões) deve estar atrelada a 1 lote

*/

SELECT	
	s.name AS schema_nome,
	t.name AS tabela_nome
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
	ON s.schema_id = t.schema_id

-- Staging

IF OBJECT_ID(N'staging.clientes', N'U') IS NULL
BEGIN
	CREATE TABLE staging.clientes
	(
		staging_cliente_id BIGINT IDENTITY(1,1) NOT NULL,

		lote_id INT NULL,

		cliente_origem_id NVARCHAR(50) NULL,
		nome NVARCHAR(250) NULL,
		email NVARCHAR(250) NULL,
		cidade NVARCHAR(150) NULL,
		uf NVARCHAR(150) NULL,
		data_cadastro NVARCHAR(50) NULL,
		segmento NVARCHAR(100) NULL,
		ativo NVARCHAR(30) NULL,

		arquivo_origem NVARCHAR(255) NULL,
		data_carga DATETIME2 NOT NULL
			CONSTRAINT DF_staging_clientes_data
			DEFAULT SYSDATETIME(),

		CONSTRAINT PK_staging_clientes
			PRIMARY KEY (staging_cliente_id)
	);
END;
GO

