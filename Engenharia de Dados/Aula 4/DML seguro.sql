-- Faremos uma transação temporaria para relembrar

BEGIN TRANSACTION

UPDATE origem.clientes
SET uf = 'MG'
WHERE email = N'ana@datacommerce.com';

SELECT
	cliente_id,
	nome,
	email,
	uf
FROM origem.clientes
WHERE email = N'ana@datacommerce.com';

SELECT
	@@ROWCOUNT AS [Linhas afetadas pela ultima instrução] -- Mostra quantas linhas o foram afetadas pela ultima instrução.

ROLLBACK;

SELECT
	cliente_id,
	nome,
	email,
	uf
FROM origem.clientes
WHERE email = N'ana@datacommerce.com';

-- Para sabermos quantas linhas foram alteradas, fazemos da seguinte forma:

DECLARE @LinhasAtualizadas INT;

BEGIN TRANSACTION;

UPDATE origem.clientes
SET  uf = 'SP'
WHERE email = N'ana@datacommerce.com'

SET @LinhasAtualizadas = @@ROWCOUNT; -- Aqui pega o tanto de linha retornada
-- O SET vem logo depois para preservar o resultado do 
-- UPDATE antes que outra instrução substitua @@ROWCOUNT.

if @LinhasAtualizadas = 1 -- Se o total de linhas afetadas foi 1

BEGIN
	COMMIT; -- então comita
END

ELSE -- Se não

BEGIN
	ROLLBACK; -- Retorne e dê o retorne o erro abaixo

	THROW 50004,
		N'A atualização deveria afetar exatamente um cliente.', -- Por email ter a CONSTRAINT unique, se retornar mais de uma linha, então tem um erro grave ai
		1;
END;

SELECT
	cliente_id,
	nome,
	email,
	uf
FROM origem.clientes
WHERE email = N'ana@datacommerce.com';

