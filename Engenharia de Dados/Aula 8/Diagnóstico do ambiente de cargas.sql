USE DataCommerce;
GO

SELECT
	DB_NAME() AS banco_atual,
	SUSER_SNAME() AS usuario_atual,
	@@VERSION AS versao_sql_server;

GO

-- Entendendo o ponto que estamos

SELECT
    s.name AS schema_nome,
    t.name AS tabela_nome
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE s.name IN
(
    N'staging',
    N'auditoria'
)
ORDER BY
    s.name,
    t.name;

-- Revisão de mecanismos
    -- BULK INSERT | É adequado para carregar arquivos tabulares, especialmente texto e CSV, diretamente em uma tabela.

BULK INSERT staging.avaliacoes_mongodb_importacao
FROM
'/var/opt/mssql/import/avaliacoes_mongodb_utf16_bom.csv'
WITH
(
    DATAFILETYPE = 'widechar',
    FIRSTROW = 2,
    FIELDTERMINATOR = '0x3B00',
    ROWTERMINATOR = '0X0A00'
);

SELECT
    BulkColumn
FROM OPENROWSET
(
    BULK '/var/opt/mssql/import/atendimentos.json',
    SINGLE_CLOB
) AS fonte;

/*
BulkColumn

Esse é o nome fixo da coluna que OPENROWSET retorna quando você usa SINGLE_CLOB (ou SINGLE_NCLOB, ou SINGLE_BLOB).

    Não é uma coluna que você escolhe.

    É o nome que o SQL Server dá automaticamente à coluna que contém o arquivo inteiro.

    Se você fizesse SELECT * FROM OPENROWSET(...), veria uma única coluna chamada BulkColumn.

Então:


SELECT BulkColumn
FROM OPENROWSET(BULK '...', SINGLE_CLOB) AS fonte;

significa: "me devolva a coluna BulkColumn da tabela virtual fonte" — ou seja, o conteúdo inteiro do arquivo como uma única string.
*/

--- XML

DECLARE @xml XML;

SELECT
    @xml = CAST
    (
        BulkColumn AS XML
    )
FROM OPENROWSET
(
    BULK '/var/opt/mssql/import/produtos.xml',
    SINGLE_BLOB
) AS x;

SELECT
    p.value
    (
        '(sku/text())[1]',
        'nvarchar(30)'
    ) AS sku,

    p.value
    (
        '(nome/text())[1]',
        'nvarchar(120)'
    ) AS produto,

    p.value
    (
        '(preco/text())[1]',
        'decimal(18,2)'
    ) AS preco

FROM @xml.nodes
(
    '/produtos/produto'
) AS T(p);

/*
Aqui há duas diferenças importantes em relação ao JSON:
SINGLE_BLOB (em vez de SINGLE_CLOB)

    SINGLE_BLOB → lê o arquivo como binário (VARBINARY(MAX)).

    Por que binário e não texto? Porque o XML pode ter encoding declarado no próprio arquivo (ex: <?xml version="1.0" encoding="UTF-8"?>). Ao ler como binário e depois fazer CAST(... AS XML), o SQL Server respeita o encoding declarado — o que evita problemas de acentuação.

    Se você usasse SINGLE_CLOB, o SQL Server trataria como texto ANSI e poderia distorcer caracteres não-ASCII.

    CAST(BulkColumn AS XML)

    Pega o conteúdo binário e converte para o tipo XML.

    Nessa conversão, o SQL Server:

        interpreta os bytes respeitando o encoding declarado;

        valida se é XML bem formado. Se não for, dá erro na hora.

    Resultado: @xml agora é um documento XML em memória, navegável por XPath.

FROM @xml.nodes('/produtos/produto') AS T(p);

O que é .nodes()

.nodes() é um método do tipo XML que faz uma coisa específica:

    Pega um XPath e devolve um conjunto de linhas, onde cada linha é um nó XML que casou com o XPath.

Ou seja: é o equivalente XML do OPENJSON. Ele transforma a estrutura hierárquica em linhas relacionais.

No seu caso:

    XPath: '/produtos/produto'

    Significa: "para cada elemento <produto> dentro de <produtos>, me dê uma linha".

Se o XML for:
xml

<produtos>
    <produto><sku>A1</sku><nome>Caneta</nome><preco>2.50</preco></produto>
    <produto><sku>B2</sku><nome>Lápis</nome><preco>1.00</preco></produto>
</produtos>

.nodes('/produtos/produto') devolve 2 linhas, cada uma contendo um <produto> inteiro (com seus filhos <sku>, <nome>, <preco>).
O que é AS T(p)

Essa sintaxe merece atenção porque é confusa:
text

AS T(p)

    T → é o alias da tabela virtual (o conjunto de linhas devolvido por .nodes()).

    (p) → é o nome da coluna que contém o nó XML de cada linha.

    p → é uma referência a essa coluna, que representa o nó <produto> atual daquela linha.

Ou seja:
Parte	O que é
T	nome da "tabela"
p	nome da coluna dessa tabela, do tipo XML
Cada linha de p	um <produto> diferente

Quando você escreve p.value(...) no SELECT, está chamando um método sobre a coluna p daquela linha específica. Ou seja, para cada <produto>, ele extrai um valor.

Pegadinha importante;

.nodes() sempre devolve uma coluna do tipo XML, e o nome dela é obrigatório entre parênteses. Não é opcional. Por isso o (p).

Se você escrevesse só AS T, daria erro — o SQL Server exige que você nomeie a coluna.
*/


DECLARE @ArquivoExiste INT;

EXEC master.dbo.xp_fileexist
    N'/var/opt/mssql/import/produtos.xml', -- 1° Parâmetro
    @ArquivoExiste OUTPUT; -- 2º Parâmetro
    -- Quando passamos um parâmetro de saída (2° parâmetro), ele retorna apenas se o arquivo existe
        -- Deixando de retornar sobrew diretório pai e afins.

SELECT 
    @ArquivoExiste AS [Arquivo existe?]

