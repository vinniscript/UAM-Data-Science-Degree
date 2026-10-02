SELECT
    COUNT(*) AS linhas_antes
FROM staging.clientes_csv;

-- Teste temporário de inserção

BEGIN TRANSACTION;

INSERT INTO staging.clientes_csv
(
    nome,
    email,
    cpf,
    cidade,
    uf
)
VALUES
(
    N'Cliente Temporário 1',
    N'temporario1@datacommerce.com',
    N'10101010101',
    N'São Paulo',
    N'SP'
),
(
    N'Cliente Temporário 2',
    N'temporario2@datacommerce.com',
    N'20202020202',
    N'Curitiba',
    N'PR'
);

SELECT
    nome,
    email,
    cpf,
    cidade,
    uf
FROM staging.clientes_csv
WHERE email IN
(
    N'temporario1@datacommerce.com',
    N'temporario2@datacommerce.com'
);

SELECT
    COUNT(*) AS linhas_durante
FROM staging.clientes_csv;

ROLLBACK;

-- Vamos tentar forçar um erro em staging, que é bem tolerante a eles. Vamos tentar passar a
-- barreira estipulada pelo NVARCHAR() de nome - 120 caracteres

BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO staging.clientes_csv
    (
        nome,
        email,
        cpf,
        cidade,
        uf
    )
    VALUES
    (
        N'Cliente válido antes do erro',
        N'antesdoerro@datacommerce.com',
        N'30303030303',
        N'Santos',
        N'SP'
    ); -- Em tese, até aqui ta show. Ainda estamos dentro do TRY
    
    INSERT INTO staging.clientes_csv
    (
        nome,
        email,
        cpf,
        cidade,
        uf
    )
    VALUES
    (
        REPLICATE(N'X',150),-- Digite 'X' 150x - para quebrar o limite de caracteres
        N'erro@datacommerce.com',
        N'40404040404',
        N'São Paulo',
        N'SP'
    ); -- Aqui já era.
        
        COMMIT; -- COMMIT nunca vai entrar, pois o segundo INSERT quebra regras de inserção.
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK; -- Aqui desfaz tudo, mesmo que o primeiro INSERT seja completamente válido.
    END;

    SELECT
        ERROR_NUMBER() AS numero_erro,
        ERROR_MESSAGE() AS mensagem_erro;

END CATCH;

-- Validando para ver que não houve carga parcial

SELECT
    nome,
    email
FROM staging.clientes_csv
WHERE email IN
(
    N'antesdoerro@datacommerce.com',
    N'erro@datacommerce.com'
); -- é para conter um retorno vazio.


