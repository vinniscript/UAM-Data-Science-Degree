/*
Por que não colocar tudo em dbo?

Quando você cria uma tablea sem indicar explicitamente um schemam é comum ela acabar no
schema padrão do usuário, frequentemente o dbo.

Exemplo:

CREATE TABLE clientes
(
	cliente_id INT
);

Isso pode resultar conceitualmente em:

dbo.clientes

Para um banco pequeno de estudo, até funcionaria. Mas no DataCommerce teremos objetos com funções diferentes:

- dados obtidos de arquivos ou sistemas;
- dados temporários para tratamento;
- registros de problemas de qualidade;
- estruturas analíticas;
- controles de execução;
- objetos relacionados à segurança.

Jogar tudo no dbo seria parecido com guardar:

° scripts
° logs
° instaladores
° relatórios
° senhas
° evidências
° Mostrar mais linhas

todos diretamente em:

C:\

Funciona? Talvez.
Fica organizado? Nem ferrando.

*/

-- Papel dos schemas no projeto

/*
DataCommerce
├── origem
├── staging
├── qualidade
├── dw
├── auditoria
└── seguranca

Vamos entender a intenção de cada área

origem
  L Representa dados próximos de sua forma operacional ou original.

Exemplos futuros:

origem.clientes
origem.produtos
origem.pedidos
  L Pense em: 'Dados provenientes do funcionamento normal da empresa.'

---

staging
  L Área intermediária destinada à recepção e preparação de dados.

Exemplos previstos no projeto:

staging.clientes_csv
staging.metas_excel
staging.atendimentos_json
staging.avaliacoes

O material descreve um pipeline que passa pelas fontes, SQL Server, staging, qualidade, ETL, DW e Power BI.

Analogia de infraestrutura

O staing é parecido com

C:\Temp\PacoteEmProcessamento
	L Você recebe algo, verifica, converte e prepara antes de mover ao destino definitivo.
		É uma área de controle de passagem.
---

qualidade
  L Agrupa objetos destinados a avaliar, registrar ou tratar problemas nos dados.

Exemplos conceituais:

qualidade.clientes_invalidos
qualidade.pedidos_duplicados
qualidade.resultado_validacoes

Possíveis verificações:

- CPF ausente;
- e-mail inválido;
- venda com valor negativo;
- pedido duplicado;
- produto inexistente;
- data em formato inesperado.

---

dw (Data Warehouse)
  L Essa área receberá estruturas destinadas à análise, histórico e geração de indicadores

Exemplos conceituais:

dw.dim_cliente
dw.dim_produto
dw.fato_vendas

Estudarei isso mais a fundo depois.

---

auditoria
  L Armazena controles, parâmetros, registro de execução e evidências do processo.

auditoria.controle_aulas
auditoria.fontes_dados

A primeira regista a evolução dos laboratórios. A segunda documenta as fontes utilizadas pelo projeto.

Outros exemplos conceituais:

auditoria.execucoes_etl
auditoria.erros_carga
auditoria.parametros

Logs e registros, num geral.

---

seguranca
  L Agrupa objetos relacionados ao controle de acesso ou à aplicação de regras de segurança.

Exemplos conceituais:

seguranca.usuarios_perfil
seguranca.filiais_permitidas

Não significa proteção de uma tabela. O schema ajuda na organização e pode participar do
modelo de permissões, mas as permissões ainda precisam ser configuradas.
*/

-- Nome completo de um objeto

/*
Quando escrevemos:
auditoria.controle_aulas

estamos usando:
schema.objeto

Quando for necessária tornar o banco explícito:

DataCommerce.auditoria.controle_aulas
  Teremos: banco.schema.objeto


Criando um schema

CREATE SCHEMA auditoria;
GO

É como criar uma pasta vazia chamada 'auditoria'
*/

-- Criando todos os SCHEMA de forma reexecutável;

USE DataCommerce;
GO

IF SCHEMA_ID('origem') IS NULL
	EXEC('CREATE SCHEMA origem');
GO

IF SCHEMA_ID('staging') IS NULL
	EXEC('CREATE SCHEMA staging');
GO

IF SCHEMA_ID('dw') IS NULL
	EXEC('CREATE SCHEMA dw');
GO

IF SCHEMA_ID('auditoria') IS NULL
	EXEC('CREATE SCHEMA auditoria');
GO

IF SCHEMA_ID('qualidade') IS NULL
	EXEC('CREATE SCHEMA qualidade');
GO

IF SCHEMA_ID('seguranca') IS NULL
	EXEC('CREATE SCHEMA seguranca');
GO

-- Por que o EXEC()? e não BEGIN & END?

/*
EXEC pede ao SQL server para executar esse texto como uma instrução.

Isso permite que a criação condicional seja executada separadamente dentro do IF.

O BEGIN e END não foram usados por quê?

IF SCHEMA_ID('auditoria') IS NULL
EXEC('CREATE SCHEMA auditoria');
	L Só é válido, pois o IF está controlando apenas uma instrução, o EXEC.

Se fossem várias, seria necessário:
*/

IF SCHEMA_ID('auditoria') IS NULL
BEGIN
	EXEC('CREATE SCHEMA auditoria');

	PRINT 'Schema auditoria criado.';
END;

-- Regra: IF com 1 instrução -> BEGIN/END opcionais, IF com 2 ou mais -> BEGIN/END necessários

-- Mesmo com uma instrução, há uma convernção em sempre usar BEGIN e END por legibilidade. Não é errado

-- CHECAGEM ---

SELECT
	name AS schema_nome,
	schema_id AS identificador
FROM sys.schemas
WHERE name IN -- IN cria uma condicional, onde 'name' (schema_nome) precisa bater a lista a seguir, imprimindo sempre que encontrara algúem nela
(
	'origem',
	'staging',
	'qualidade',
	'dw',
	'auditoria',
	'seguranca'
)
ORDER BY name -- Retorna por nome, apenas uma forma de organização do retorno

-- Validação por contagem
	-- Também podemos perguntar quantos dos schemas esperados foram encontrados:

SELECT
	COUNT(*) AS total_schemas_encontrados
FROM sys.schemas
WHERE name IN
(
	'origem',
	'staging',
	'qualidade',
	'dw',
	'auditoria',
	'seguranca'
);

-- COUNT(*)
	-- Conta quantas linhas atenderam ao filtro, nesse caso todas atenderam