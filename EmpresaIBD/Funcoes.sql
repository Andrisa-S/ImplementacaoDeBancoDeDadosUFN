-- FUN합ES

	-- FUN합ES ESCALARES

	CREATE FUNCTION fn_Dobro(@Numero INT)

	RETURNS INT
	AS
	BEGIN
		RETURN @Numero*2;
	END;

SELECT dbo.fn_Dobro(5) AS 'Resultado';
GO
--

	CREATE FUNCTION fn_CalcularIdade(@Data DATE)
	RETURNS INT
	AS
	BEGIN
		DECLARE @idade INT;
		SET @idade = YEAR(GETDATE()) - YEAR(@Data); --DATEDIFF(YEAR, @Data, GETDATE());
		IF MONTH(GETDATE()) > MONTH(@Data) OR MONTH(GETDATE()) =  MONTH(@Data) AND DAY(@Data) > DAY(GETDATE())
			BEGIN
				SET @idade -= 1
			END;

		RETURN @idade;
	END;

	SELECT F.Pnome, dbo.fn_CalcularIdade(F.Datanasc)
	FROM FUNCIONARIO AS F;
	GO

	--FUN합ES INLINE
	CREATE FUNCTION fn_RetornarFuncionarios (@Tbl_funionarios VARCHAR(40))
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT F.Pnome
		FROM FUNCIONARIO AS F
		INNER JOIN DEPARTAMENTO AS D
		ON F.Dnr = D.Dnumero
		WHERE D.Dnome = @Tbl_funionarios
	);


	SELECT * FROM dbo.fn_RetornarFuncionarios('Pesquisa');

	GO

	--FUN합ES MULTI-STATEMENT

