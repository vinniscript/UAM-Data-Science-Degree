USE DataCommerce;
GO

CREATE TABLE auditoria.controle_aulas
(
	aula INT NOT NULL PRIMARY KEY, 
	tema NVARCHAR(200) NOT NULL,
	data_prevista DATE NOT NULL,
	concluida BIT NOT NULL DEFAULT 0,
	data_registro DATETIME2 NOT NULL DEFAULT
SYSDATETIME()
);
GO

-- Entendendo

/*
A instrução:

CREATE TABLE auditoria.controle_aulas

pode ser lida como:

'Crie uma tabela chamada controle_aulas dentro do schema auditoria.'

Depois do nome, os parênteses delimitam a definição das colunas:

(
definição da coluna 1,
definição da coluna 2,
definição da coluna 3
)

A forma geral de uma coluna é:

'nome tipo regras'

Exemplo:

SQL
tema NVARCHAR(200) NOT NULL
Mostrar mais linhas

Temos:

tema nome da coluna
NVARCHAR(200) tipo e tamanho
NOT NULL regra de obrigatoriedade

A vírgula separa a definição de uma coluna da próxima.



------------------------> TIPOS e REGRAS: <------------------------

°INT
  L Define que essa coluna aceita apenas números inteiros; (1, 10, 500, -3...)
  
	- O tipo de dado define o formato técnico permitido, mas não garante sozinho que o valor faça sentido para o negócio.

°NOT NULL 
  L Significa que a coluna PRECISA receber um valor.

	Lembrando:
	NULL ≠ zero
	NULL ≠ texto vazio
	NULL ≠ espaço

°PRIMARY KEY
  L Define a coluna aula como a chave primária.

  A chave primária:
    - Identifica cada linha;
    - Não aceita NULL;
    - Não aceita valores duplicados.
	
Assim, isto pode existir:

aula = 1
aula = 2 
aula = 3

Mas isto não:

aula = 1
aula = 1

Por que não usar o tema como chave?

Porque temas:
- podem mudar;
- podem ser longos;
- podem se repetir;
- não são bons identificadores técnicos.

É mais seguro identificar a aula por um número estável

°NVARCHAR
  L Armazena texto de tamanho variável com suporte Unicode

  Isto permite armazenar corretamente caracteres como:
  - Introdução
  - Administração
  - Informação
  - João

O N está associado ao auporte a texto Unicode (200)
Que significa que a coluna aceita até 200 caracteres.

°DATE
  L Armazena uma data:
	    2026-08-10
Não armazena horário

A forma:
AAAA-MM-DD

É a melhor forma para scripts, pois evita ambiguidades.

°BIT
  L Representa um estado binário:

	0 = falso
	1 = verdadeiro

No nosso contexto:

0 = aula não concluída
1 = aula concluída

  DEFAULT 0
   - Define um valor padrão.
		Se inserirmos uma aula sem informar concluída, o SQL usará 0.
		DEFAULT não impede valor explícito.

Isso define regra. Toda aula começa como não concluída, salvo se for informado o contrário.

ºDATETIME2
  L Armazena data e horário
		Exemplo conceitual:
		2026-09-01 20:10:30.1234567

Diferentemente de DATE, que guarda apenas a data, DATETIME2 consegue representar:
ano;
mês;
dia;
hora;
minuto;
segundo;
fração de segundo.

°SYSDATETIME()
  L É uma função do SQL que devolve a data e horário atuais do sistema onde o mecanismo está executando.

Como ela está em:

DEFAULT SYSDATETIME()
se não informarmos manualmente uma data de registro, o SQL Server preencherá a coluna no momento da inserção.

A ideia é:

data_prevista = quando a aula está planejada
data_registro = quando esta linha foi gravada

Não confunda as duas.


--- RESUMO DA ESTRUTURA ---

controle_aulas
├── aula
│   ├── inteiro
│   ├── obrigatório
│   └── identificador único
│
├── tema
│   ├── texto Unicode
│   ├── até 200 caracteres
│   └── obrigatório
│
├── data_prevista
│   ├── data
│   └── obrigatória
│
├── concluida
│   ├── estado 0 ou 1
│   ├── obrigatório
│   └── padrão 0
│
└── data_registro
    ├── data e horário
    ├── obrigatório
    └── padrão SYSDATETIME()
*/

-- Criação segura

USE DataCommerce;
GO

IF OBJECT_ID
(
	'auditoria.controle_aulas',
	'U'
) IS NULL
BEGIN
	CREATE TABLE auditoria.controle_aulas
	(
		aula INT NOT NULL PRIMARY KEY,
		tema NVARCHAR(200) NOT NULL,
		data_prevista DATE NOT NULL,
		concluida BIT NOT NULL DEFAULT 0,
		data_registro DATETIME2 NOT NULL DEFAULT
SYSDATETIME()
	);
END;
GO

-- OBJECT_ID

/*

Recebe:

'auditoria.controle_aulas' = nome do objeto
'U' = tabela criada pelo usuário

Se a tabela não existir: NULL
Se existir: algum identificador númerico aleatório

Portanto, o bloco diz:

Se a tabela de usuário auditoria.controle_aulas não existir, crie-a.
*/

-- Validando a estrura

SELECT
	TABLE_SCHEMA AS schema_nome,
	TABLE_NAME AS tabela_nome,
	COLUMN_NAME AS coluna_nome,
	DATA_TYPE AS tipo,
	IS_NULLABLE AS aceita_null
FROM INFORMATION_SCHEMA.COLUMNS -- Informação de Schemas (colunas)
WHERE TABLE_SCHEMA = 'auditoria' -- Nosso interesse é apenas o schema auditoria
  AND TABLE_NAME = 'controle_aulas' -- Mais uma condição necessária a ser atendida
ORDER BY ORDINAL_POSITION; -- Mantém a ordem de definição das colunas



--------------------> Inserindo a primeira linha <--------------------


INSERT INTO auditoria.controle_aulas
(
	aula,
	tema,
	data_prevista
)
VALUES
(
	1,
	N'Introdução e ambiente SQL Server Express',
	'2026-08-10'
);

/*
°INSERT INTO
  L Significa:
	  Insira uma nova linha nesta tabela.

Lista de colunas

(
aula,
tema,
data_prevista
)
Determina às quais colunas enviaremos valores explicitamente.

°VALUES
  L Fornece os valores correspondentes.

Lista de valores
(
1,
N'Introdução e ambiente SQL Server Express',
'2026-08-10'
);

O pareamento ocorre pela posição:

aula → 1
tema → Introdução e ambiente SQL Server Express
data_prevista → 2026-08-10

E as duas colunas ausentes?

Não informamos:

concluida
data_registro

Então seus valores padrão serão aplicados:

concluida → 0
data_registro → SYSDATETIME()

Por que existe N antes do texto?

"N'Introdução e ambiente SQL Server Express'"

O prefixo N indica um literal de texto Unicode.
  Como a coluna é NVARCHAR, é uma boa prática usar:
	: N'texto' :
Apenas convenção
*/

-- Consultando linhas 

SELECT
	aula,
	tema,
	data_prevista,
	concluida,
	data_registro
FROM auditoria.controle_aulas;

-- Agora o select está consultando uma tabela real.

/*
FROM auditoria.controle_aulas
↓
localizar a fonte dos dados
 
SELECT aula, tema, ...
↓
escolher quais colunas retornar
*/

-- Carga reexecutável

IF NOT EXISTS
(
    SELECT 1
    FROM auditoria.controle_aulas
    WHERE aula = 1
)
BEGIN
    INSERT INTO auditoria.controle_aulas
    (
        aula,
        tema,
        data_prevista
    )
    VALUES
    (
        1,
        N'Introdução e ambiente SQL Server Express',
        '2026-08-10'
    );
END;
