-- PROCEDIMENTOS

CREATE PROCEDURE usp_ExibirNome (@Nome VARCHAR(30))
	AS
	BEGIN
		PRINT 'Meu nome é ' + @Nome
	END

EXEC usp_ExibirNome 'Andrisa';
GO
--

CREATE PROCEDURE usp_FuncionarioDepartamento
AS
BEGIN
	SELECT 
		F.Pnome + ' ' + F.Minicial + ' ' + F.Unome AS 'Nome Completo',
		D.Dnome AS 'Departamento'
	FROM FUNCIONARIO AS F
	INNER JOIN DEPARTAMENTO AS D
	ON F.Dnr = D.Dnumero
END

EXEC usp_FuncionarioDepartamento;

	-- DA O SCRIPT
EXEC sp_helptext usp_FuncionarioDepartamento;
GO

--

	--PROCEDIMENTO CRIPTOGRAFADO
CREATE PROCEDURE usp_Funcionario
WITH ENCRYPTION
AS
SELECT *
FROM FUNCIONARIO

EXEC usp_Funcionario;

EXEC sp_helptext usp_Funcionario;
GO

--

CREATE PROCEDURE usp_AtualizarSalario
	@cpf CHAR(11),
	@novoSalario DECIMAL (10, 2)
AS
BEGIN
	DECLARE @retorno DECIMAL

	--ENCONTRA O FUNCIONARIO
	SET @retorno = (
					SELECT F.Salario
					FROM FUNCIONARIO AS F
					WHERE F.Cpf = @cpf
					)

	IF @retorno IS NULL
		BEGIN
			PRINT 'Funcionário não encontrado'
		END
	ELSE 
		BEGIN
			PRINT 'Salário atualizado!'
		END

	--ATUALIZA
	UPDATE FUNCIONARIO
	SET Salario = @novoSalario
	WHERE Cpf = @cpf

	/*IF @@ROWCOUNT = 0
		PRINT 'Ninguém com o CPF: ' + @cpf;
	*/
END

EXEC usp_AtualizarSalario '11012005367', 15000.50;
EXEC usp_AtualizarSalario '88866555576', 15000.00;

GO

--

CREATE PROCEDURE usp_InserirFuncionario 
	@Pnome VARCHAR(15),
	@Minicial CHAR,
    @Unome VARCHAR(15),
    @Cpf CHAR(11),
    @Datanasc DATE,
    @Sexo CHAR,
    @Salario DECIMAL(10,2),
    @Dnr INT

AS
BEGIN
	DECLARE @retorno VARCHAR(15) --IF EXISTS
	SET @retorno = (
		SELECT F.Pnome
		FROM FUNCIONARIO AS F
		WHERE F.Pnome = @Pnome AND F.Minicial = @Minicial AND F.Unome = @Unome);

	IF @retorno IS NULL 
		BEGIN
			INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Sexo, Salario, Dnr)
			VALUES (@Pnome, @Minicial, @Unome, @Cpf, @Datanasc, @Sexo, @Salario, @Dnr)
			PRINT 'Funcionário adicionado!'
		END
	ELSE
		PRINT 'Funcionário já existente'

END

EXEC usp_InserirFuncionario 'Andrisa', 'S', 'Silva', '00033897420', '2005-01-11', 'F', 27000, 8;
EXEC usp_InserirFuncionario 'Mariana', 'L', 'Gomes', '11288960452', '1999-09-09', 'F', 13000, 3;
GO

--

CREATE PROCEDURE usp_InserirDepartamento
	@Dnome VARCHAR(15),
	@Dnumero INT,
	@Dlocal VARCHAR (15)

AS
BEGIN
	IF EXISTS (
				SELECT *
				FROM DEPARTAMENTO AS D
				WHERE D.Dnome = @Dnome OR D.Dnumero = @Dnumero)
		BEGIN
			PRINT 'Departamento já existente'
			RETURN;
		END
		
	ELSE
		BEGIN
			INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
			VALUES (@Dnome, @Dnumero)

			INSERT INTO LOCALIZACAO_DEP (Dnumero, Dlocal)
			VALUES (@Dnumero, @Dlocal)

			PRINT 'Departamento e localização inseridos!'
		END
END

EXEC usp_InserirDepartamento 'Internacional', 9, 'Auckland';
EXEC usp_InserirDepartamento 'RH', 7, 'Santa Maria';
GO

--

CREATE PROCEDURE usp_ListarFuncionariosDepartamento (@nomeDpt VARCHAR(15) = NULL)
AS
BEGIN
	IF @nomeDpt IS NOT NULL
		SELECT
			F.Pnome + ' ' + F.Minicial + ' ' + F.Unome AS 'Nome Completo',
			D.Dnome AS 'Departamento'
		FROM FUNCIONARIO AS F
		FULL JOIN DEPARTAMENTO AS D
		ON F.Dnr = D.Dnumero
		WHERE D.Dnome = @nomeDpt;
	ELSE
		SELECT
			F.Pnome + ' ' + F.Minicial + ' ' + F.Unome AS 'Nome Completo'
		FROM FUNCIONARIO AS F
END

EXEC usp_ListarFuncionariosDepartamento;
EXEC usp_ListarFuncionariosDepartamento 'TI';
GO

--
	--PARÂMETRO DE SAÍDA
CREATE PROCEDURE usp_dobro (@numero AS INT OUTPUT)
AS
SELECT @numero*2
RETURN

--TESTANDO
DECLARE @valor AS INT = 7;
EXEC usp_dobro @valor OUTPUT;
PRINT @valor;
GO

--
