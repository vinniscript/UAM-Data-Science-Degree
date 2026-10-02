USE DataCommerce;
GO

SELECT DB_NAME() AS banco_atual,

	compatibility_level -- OPENJSON exige nível de compatibilidade 130 ou superior
	-- salvo quando uma configuração específica do banco permite a função em todos os níveis.
FROM sys.databases
WHERE name = DB_NAME();

-- Armazenar o JSON em uma variável

DECLARE @json NVARCHAR(MAX);

SET @json = N'
[
	{
		"atendimento_id": 1,
		"cliente_email": "ana@datacommerce.com",
		"canal": "app",
		"assunto": "entrega",
		"nota": 5
	},
	{
		"atendimento_id": 2,
		"cliente_email": "bruno@datacommerce.com",
		"canal": "site",
		"assunto": "Preço",
		"nota": 3
	},
	{
		"atendimento_id": 3,
		"cliente_email": "carla@datacommerce.com",
		"canal": "whatsapp",
		"assunto": "Atendimento",
		"nota": 4
	}
]';

SELECT
	@json AS json_recebido;
-- Usamos o prefixo N porque o JSON contém caracteres Unicode, como 'preço'

-- Validando JSON para ver se é válido


SELECT
    ISJSON(@json) AS json_valido;

/*
1 → texto reconhecido como JSON válido
0 → texto inválido
NULL → entrada nula
*/


-- Explorando OPENJSON sem estrutura explícita

SELECT -- Sem WITH, OPENJSON retorna por padrão:
	[key], -- Contém o índice de cada elemento
	[value],
	[type] -- 5 é um objeto JSON
FROM OPENJSON(@json);

/*
Para um array, cada elemento aparece em uma linha e key contém o índice do elemento.

Resultado conceitual esperado:

key 0 → documento da Ana
key 1 → documento do Bruno
key 2 → documento da Carla
*/

-- Convertendo JSON em linhas relacionais

SELECT
	atendimento_id,
	cliente_email,
	canal,
	assunto,
	nota
FROM OPENJSON(@json)
WITH
( -- $ representa a raiz do documento atual, assim '$.atendimento_id' significa - Na raiz do documento, leia a propriedade atendimento_id
	atendimento_id INT '$.atendimento_id',

	cliente_email NVARCHAR(160) '$.cliente_email',

	canal NVARCHAR(40) '$.canal',

	assunto NVARCHAR(80) '$.assunto',

	nota INT '$.nota'
)

/*
OPENJSON analisa texto JSON e retorna linhas e colunas. A cláusula WITH 
permite declarar explicitamente as colunas, seus tipos e os caminhos das propriedades do documento.
*/

-- Após interpretar o JSON

SELECT 
	atendimento_id,
	cliente_email,
	canal,
	assunto,
	nota
FROM OPENJSON(@json) 
WITH
(
	atendimento_id INT '$.atendimento_id',
	cliente_email NVARCHAR(160) '$.cliente_email',
	canal NVARCHAR(40) '$.canal',
	assunto NVARCHAR(80) '$.assunto',
	nota INT '$.nota'
)
WHERE nota >= 4;

-- Eternizando esse JSON numa tabela dedicada

USE DataCommerce;
GO

IF OBJECT_ID
(
	N'origem.eventos_json',
	N'U'
) IS NULL
BEGIN
	CREATE TABLE origem.eventos_json
	(
		evento_id INT IDENTITY(1,1) NOT NULL,

		origem NVARCHAR(60) NOT NULL,

		PAYLOAD NVARCHAR(MAX) NOT NULL,

		data_evento DATETIME2 NOT NULL
			CONSTRAINT DF_eventos_json_data_evento
			DEFAULT SYSDATETIME(),

		CONSTRAINT PK_eventos_json
			PRIMARY KEY (evento_id),

		CONSTRAINT CK_eventos_json_payload
			CHECK
			(
				ISJSON(payload) = 1
			)
	);
END;
GO

-- INSERÇÃO SEGURA

IF NOT EXISTS 
(
	SELECT 1
	FROM origem.eventos_json
	WHERE origem = N'api-atendimento'
	  AND JSON_VALUE
		(
			payload,
			'$.cliente'
		) = N'ana@datacommerce.com'
	AND JSON_VALUE
		(
			payload,
			'$.nota'
		) = N'5'
)
BEGIN
	INSERT INTO origem.eventos_json
	(
		origem,
		payload
	)
	VALUES
	(
		N'api-atendimento',

		N'{
			"cliente": "ana@datacommerce.com",
			"canal": "app",
			"nota": 5
		}'
	);
END;
GO

-- Consultando propriedades com JSON VALUE

SELECT
	evento_id,

	origem,

	JSON_VALUE
	(
		payload,
		'$.cliente'
	) AS cliente,

	JSON_VALUE
	(
		payload,
		'$.canal'
	) AS canal,

	JSON_VALUE
	(
		payload,
		'$.nota'
	) AS nota,

	-- Se quiséssemos a nota numérica

	/*
	CONVERT
	(
		INT,
		JSON_VALUE
		(
			payload,
			'$.nota'
		) 
	) AS nota
	*/
	
	data_evento
FROM origem.eventos_json
ORDER BY evento_id;

-- Testando a constraint com segurança

BEGIN TRY

	INSERT INTO origem.eventos_json
	(
		origem,
		payload
	)
	VALUES
	(
		N'teste-json-invalido',
		N'isto não é um documento JSON'
	);
END TRY
BEGIN CATCH

	SELECT
		ERROR_NUMBER() AS numero_erro,
		ERROR_MESSAGE() AS mensagem_erro

END CATCH;

-- Confirmando

SELECT
    evento_id,
    origem,
    payload,
    data_evento
FROM origem.eventos_json
WHERE origem = N'teste-json-invalido'; -- não é pra retornar linha alguma

-- Diferença entre OPENJSON e JSON_VALUE

/*
OPENJSON
Transforma objetos ou arrays em conjunto de linhas e colunas.
 
JSON_VALUE
Extrai uma propriedade escalar de um documento.

Exemplos:

FROM OPENJSON(@json)

produz várias linhas.

JSON_VALUE(payload, '$.cliente')

produz um valor por linha consultada.
*/

