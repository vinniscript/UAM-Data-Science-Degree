-- Uma transação é um tudo ou nada.

/*
Imagine que você precise executar duas operações:

1. Criar um pedido.
2. Inserir os itens desse pedido.

Se a primeira funcionar e a segunda falhar, teremos:

Pedido criado
Itens não criados

O resultado é um pedido vazio ou incompleto.

É isso que uma transação evita.
*/

-- Conferindo tabela de teste:

SELECT
	sku,
	produto,
	categoria,
	preco
FROM origem.produtos
ORDER BY produto_id;

-- Testando o BEGIN TRANSACTION

BEGIN TRANSACTION;

UPDATE origem.produtos -- UPDATE determina qual tabela será alterada
SET preco = preco * 1.10 -- Determina a coluna e sua alteração
WHERE categoria = N'informática'; -- Filtro de onde ocorrerá a alteração de SET

/*
Antes de executar um UPDATE, uma prática útil é testar o filtro com SELECT:


SELECT *
FROM origem.produtos
WHERE categoria = N'Informática';


Se esse SELECT retornar exatamente as linhas desejadas,
o mesmo WHERE poderá ser usado no UPDATE com mais segurança.

*/

SELECT
	sku,
	produto,
	categoria,
	preco
FROM origem.produtos
ORDER BY produto_id;

-- SELECT @@TRANCOUNT AS transacoes_abertas;

ROLLBACK;

SELECT
	sku,
	produto,
	categoria,
	preco
FROM origem.produtos
ORDER BY produto_id;

-- Como saber se existem transações abertas?

SELECT @@TRANCOUNT AS transacoes_abertas;

-- Para não alterar a tabela original, criaremos uma temporaria para realizar o incremento de preço

IF OBJECT_ID(N'tempdb..#teste_transacao', N'U') IS NOT NULL
BEGIN
	DROP TABLE #teste_transacao;
END;


CREATE TABLE #teste_transacao -- '#' é o caractere que define a propriedade de temporaria para a tabela.
(
	id INT,
	descricao NVARCHAR(100)
); -- Ela existe somente no contexto temporário da sessão e não faz parte definitiva do modelo DataCommerce.
GO

BEGIN TRANSACTION

INSERT INTO #teste_transacao
(
	id,
	descricao
)
VALUES
(
	1,
	N'Linha confirmada'
);

COMMIT;

SELECT *
FROM #teste_transacao

-- Agora, com o ROLLBACK

BEGIN TRANSACTION;

INSERT INTO #teste_transacao
(
	id,
	descricao
)
VALUES
(
	2,
	N'Linha desfeita'
);

ROLLBACK;

SELECT *
FROM #teste_transacao;

/*
Comparação

Linha 1
Foi inserida e recebeu COMMIT.
Permaneceu.
 
Linha 2
Foi inserida e recebeu ROLLBACK.
Foi desfeita.
*/