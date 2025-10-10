--Transa��es
-- TRANSACTION
-- ROLLBACK
-- COMMIT
-- SAVE POINT

BEGIN TRANSACTION;
	INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr)
	VALUES ('Andrisa', 'S', 'Silva', '03320204856', '2005-01-11', 'Santa Maria', 'F', 50000, NULL, 8);

	SELECT * FROM FUNCIONARIO;

	INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
	VALUES ('TESTE TRANSA��O', 5);

	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Erro detectado, transa��o revertida';
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION;
			PRINT 'Transa��o conclu�da com sucesso';
		END;
GO

--

BEGIN TRANSACTION;
	INSERT INTO FUNCIONARIO (Pnome, Unome)
	VALUES ('Jo�o', 'Silva'),
	('Jo�o', 'Santos'),
	('Jo�o', 'Machado');

	SELECT * FROM FUNCIONARIO;

	UPDATE FUNCIONARIO
	SET Salario = 1000
	WHERE Pnome = 'Jo�o';

	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Erro detectado, transa��o revertida';
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION;
			PRINT 'Transa��o conclu�da com sucesso';
		END;
GO

--
-- Case

SELECT
	F.Pnome AS 'Nome',
	F.Unome AS 'Sobrenome',
	F.Salario,
	CASE
		WHEN F.Salario < 20000 THEN 'Baixo'
		WHEN F.Salario BETWEEN 20000 AND 40000 THEN 'Medio'
		WHEN F.Salario > 40000 THEN 'Alto'
		ELSE 'Sem Registro'
	END AS 'Categoria'
FROM FUNCIONARIO AS F;

--

SELECT
	F.Pnome,
	F.Unome,
	F.Data_Admissao,
	CAST(GETDATE() AS DATE) AS 'Hoje',
	CASE
		WHEN DATEDIFF(DAY, F.Data_Admissao, GETDATE()) <= 365 THEN 'Rec�m-contratado'
		ELSE 'Admitido h� mais de 1 ano'
	END AS 'Status'
FROM FUNCIONARIO AS F;

--

BEGIN TRANSACTION -- Transa��o INCORRETA
	UPDATE FUNCIONARIO
	SET Salario = 30000
	WHERE Pnome = 'Carlos';

	IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION;
			PRINT 'Erro detectado, transa��o revertida';
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION;
			PRINT 'Transa��o conclu�da com sucesso';
		END;
GO

BEGIN TRAN
	UPDATE FUNCIONARIO
	SET Salario = 30000
	WHERE Pnome = 'Carlos';

	SELECT * FROM FUNCIONARIO ORDER BY Pnome; -- Verifica��o

	ROLLBACK TRAN;

GO

BEGIN TRAN
	DECLARE @registroAfetado INT = 0;

	UPDATE FUNCIONARIO
	SET Salario = 30000
	WHERE Pnome = 'Carlos';
	SET @registroAfetado = @@ROWCOUNT + @registroAfetado; --Impede mais de uma linha afetada

	IF @registroAfetado <> 1
	BEGIN
		ROLLBACK TRAN;
		PRINT 'Altera��o N�O realizada. Linha afetada != 0'
	END;
	ELSE
	BEGIN
		COMMIT TRANSACTION;
		PRINT 'Altera��o realizada com sucesso!';
	END;
GO
--
-- ISOLAMENTO

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Transa��o 1
BEGIN TRAN;
SELECT * FROM FUNCIONARIO;
PRINT 'SELECT conclu�do em: ' + CONVERT(VARCHAR(23), SYSDATETIME(), 121);

--Pausa de 20 segundos
WAITFOR DELAY '00:00:20'
COMMIT TRAN;
PRINT 'COMMIT conclu�do em: ' + CONVERT(VARCHAR(23), SYSDATETIME(), 121);

--Transa��o 2
BEGIN TRAN;
INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf)
VALUES ('Gustavo', 'G', 'Sefrin', '32990409344')
PRINT 'INSERT conclu�do em: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
COMMIT TRAN;
PRINT 'COMMIT conclu�do em: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);

-- SAVE POINT
BEGIN TRAN;

INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('Marketing', 88)

SAVE TRAN dptOk;

INSERT INTO DEPARTAMENTO (Dnome, Dnumero)
VALUES ('Marketing', 1);

ROLLBACK TRAN dptOk;

COMMIT TRANSACTION;