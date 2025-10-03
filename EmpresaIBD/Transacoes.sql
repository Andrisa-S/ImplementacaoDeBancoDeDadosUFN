--Transa��es

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
