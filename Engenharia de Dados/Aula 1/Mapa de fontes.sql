-- Mapa de fontes

/*
O objetivo é documentar quais fontes alimentarão o projeto durante o semestre. O material prevê quatro fontes:

arquivo CSV de clientes;
arquivo Excel de metas;
arquivo JSON de atendimentos;
avaliações armazenadas no MongoDB.

Cada fonte aponta para um destino futuro no schema staging.

A tabela fontes_dados não armazenará necessariamente o conteúdo do CSV, Excel ou JSON.

Ela armazenará informações sobre essas fontes:

- qual é a fonte?
- qual é o tipo?
- para onde seus dados deverão ir?
- qual é sua finalidade?
*/

USE DataCommerce;
GO

IF OBJECT_ID
(
	'auditoria.fontes_dados',
	'U' -- 'Criada por usuário'
) IS NULL
BEGIN
	CREATE TABLE auditoria.fontes_dados
	(
		fonte_id INT IDENTITY(1,1) PRIMARY KEY,
		nome_fonte NVARCHAR(80), -- Armazena o nome ou identificação da fonte | 'clientes.csv', 'metas_comerciais'...
		tipo NVARCHAR(40), -- Claissifica formato ou tecnologia | 'CSV', 'Excel', 'JSON', 'NoSQL'...
		destino NVARCHAR(80), -- Documenta a tabela para qual os dados deverão ser enviados | 'staging.clientes_csv', 'staging.metas_excel'
		observacao NVARCHAR(300) -- Explica a finalidade da fonte | 'Carga externa de clientes', 'Metas por filial', 'Atendimentos digitais'...
	);
END;
GO

-- Validação

SELECT
	COLUMN_NAME AS coluina,
	DATA_TYPE AS tipo,
	CHARACTER_MAXIMUM_LENGTH as tamanho_maximo,
	IS_NULLABLE as aceita_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'auditoria'
  AND TABLE_NAME = 'fontes_dados'
ORDER BY ORDINAL_POSITION;

-- IDENTITY (1,1), é a coluna de ID, onde começa e de quanto em quanto ele soma

/*

A sequência esperada será:
fonte_id 1
fonte_id 2
fonte_id 3
fonte_id 4

se fosse IDENTITY(100,10)

a sequência esperada seria:

100
110
120
130
*/

-- Inserindo as fontes

IF NOT EXISTS
(
    SELECT 1 -- Essa linha é só por que o SQL Server pede esse estrutura SELECT\FROM, sem o SELECT, não funciona. Deixamos então um valor 1 por convenção.
    FROM auditoria.fontes_dados
)
BEGIN
    INSERT INTO auditoria.fontes_dados
    (
        nome_fonte,
        tipo,
        destino,
        observacao
    )
    VALUES
        (
            N'clientes.csv',
            N'CSV',
            N'staging.clientes_csv',
            N'Carga externa de clientes'
        ),
        (
            N'metas_comerciais.xlsx',
            N'Excel',
            N'staging.metas_excel',
            N'Metas por filial'
        ),
        (
            N'atendimentos.json',
            N'JSON',
            N'staging.atendimentos_json',
            N'Atendimentos digitais'
        ),
        (
            N'MongoDB.avaliacoes',
            N'NoSQL',
            N'staging.avaliacoes',
            N'Avaliações de clientes'
        );
END;
GO

-- Não incluimos fonte_id por que ela foi definida como IDENTITY(x,x); O próprio SQL Server gerará o ID.

/*
Por que listar explicitamente as colunas?

O material utiliza:

INSERT INTO auditoria.fontes_dados
VALUES (...);

Isso depende da ordem das colunas da tabela.

Preferimos:

INSERT INTO auditoria.fontes_dados
(
    nome_fonte,
    tipo,
    destino,
    observacao
)
VALUES (...);

Essa forma deixa explícito:

quais colunas receberão valores;
em qual ordem;
quais colunas serão preenchidas automaticamente;
quais colunas foram intencionalmente omitidas.

Se a tabela sofrer mudanças no futuro, a lista explícita das colunas também reduz a chance de um valor ir parar no lugar errado.
*/

-- Consultando e validando
SELECT
    fonte_id,
    nome_fonte,
    tipo,
    destino,
    observacao
FROM auditoria.fontes_dados

-- Validando a quantidade de elementos

SELECT 
    COUNT(*) AS total_fontes
FROM auditoria.fontes_dados;

-- Primeira agregação

SELECT  
    tipo,
    COUNT(*) AS quantidade -- 2° Pega cada resultado que o GRUP BY separa e conta a quantidade de cada resultado por linha
FROM auditoria.fontes_dados
GROUP BY tipo -- 1° Separa todos os resultados possiveis da coluna 'tipo'
ORDER BY tipo; -- 3° Pega em ordem alfabética as colunas em tipo e outputa elas

