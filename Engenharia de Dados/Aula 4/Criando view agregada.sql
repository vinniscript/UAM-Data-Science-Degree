USE DataCommerce;
GO

CREATE OR ALTER VIEW origem.vw_vendas_por_cliente
AS

SELECT
	c.cliente_id,

	c.nome AS Cliente,

	c.uf,

	SUM
	(
		i.quantidade * i.valor_unitario	
	) AS total_vendas

FROM origem.clientes AS c

INNER JOIN origem.pedidos AS p
	ON p.cliente_id = c.cliente_id

INNER JOIN origem.itens_pedido AS i
	ON i.pedido_id = p.pedido_id

GROUP BY
	c.cliente_id,
	c.nome,
	c.uf;
GO

-- Validando o objeto

SELECT
	s.name AS schema_nome,
	v.name AS view_nome,
	v.create_date AS data_criacao,
	v.modify_date AS data_modificacao
FROM sys.views AS v

INNER JOIN sys.schemas AS s
	ON s.schema_id = v.schema_id

WHERE s.name = N'origem'
  AND v.name = 'vw_vendas_por_cliente';

  -- Criando a procedure que receberá a UF

CREATE OR ALTER PROCEDURE origem.sp_vendas_por_uf
	@uf CHAR(2)
AS
BEGIN
	SET NOCOUNT ON;

	IF @uf IS NULL
	BEGIN
		THROW 50010,
			  N'A UF é obrigatória.',
			  1;
	END;

	IF LEN -- Conta os caracteres restantes
	(
		LTRIM -- Remove espaços à esquerda
		(
			RTRIM(@uf) -- Remove os espaços à direita
		)
	) <> 2
		-- LEN(LTRIM(RTRIM(@uf))) <> 2 pergunta: Depois de remover os espaços de ambas as extremidades, o valor possui valor diferente de dois?
		BEGIN
			THROW 50011,
				  N'A UF deve possuir exatamente 2 caracteres.',
				  1;
		END;

		SELECT
			cliente_id,
			cliente,
			uf,
			total_vendas
		FROM origem.vw_vendas_por_cliente
		WHERE uf = UPPER(@UF) -- Converte a UF para caixa alta
		ORDER BY cliente;
END;
GO

-- Testes válidos

EXEC origem.sp_vendas_por_uf
	@uf = 'SP';

EXEC origem.sp_vendas_por_uf
	@uf = 'RJ';

-- Valores em minusculo (salvos pelo UPPER)

EXEC origem.sp_vendas_por_uf
	@uf = 'sp';

EXEC origem.sp_vendas_por_uf
	@uf = 'rj';

-- Testes inválidos:

--EXEC origem.sp_vendas_por_uf
    --@uf = NULL; -- nenhum valor

--EXEC origem.sp_vendas_por_uf
    --@uf = 'S'; -- Valores incompletos

-- No contexto de aluno_leitura

-- Primeiro concedemos o acesso para tal

GRANT SELECT
ON OBJECT::origem.vw_vendas_por_cliente
TO perfil_consulta_operacional;
GO

GRANT EXECUTE
ON OBJECT::origem.sp_vendas_por_uf
TO perfil_consulta_operacional
GO

EXECUTE AS USER = N'aluno_leitura';

SELECT
    HAS_PERMS_BY_NAME
    (
        N'origem.vw_vendas_por_cliente',
        N'OBJECT',
        N'SELECT'
    ) AS pode_consultar_view,

    HAS_PERMS_BY_NAME
    (
        N'origem.sp_vendas_por_uf',
        N'OBJECT',
        N'EXECUTE'
    ) AS pode_executar_procedure;

EXEC origem.sp_vendas_por_uf
    @uf = 'SP';

REVERT;

