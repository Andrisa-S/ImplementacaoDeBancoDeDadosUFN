-- TRY CATCH

BEGIN TRY
	SELECT 1/0; --ERRO
	PRINT 'N�o cheguei aqui';
END TRY
BEGIN CATCH
	PRINT 'DEU ERRO!';
	PRINT 'N�mero: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem: ' + ERROR_MESSAGE();
END CATCH

-- TRY CATCH + TRANSACTION

BEGIN TRY
	BEGIN TRAN;

	UPDATE FUNCIONARIO
	SET Dnr = 1212
	WHERE Cpf = '98765432168'

	COMMIT TRAN
	PRINT 'Realizada altera��o de departamento!'
END TRY
BEGIN CATCH
	-- XACT_STATE() retorna o estado da transa��o 1
	-- 1 - Transa��o em aberto
	-- 0 - N�o existe Transa��o em aberto
	IF XACT_STATE() <> 0
		ROLLBACK TRAN;
	PRINT 'N�mero: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem: ' + ERROR_MESSAGE();
END CATCH