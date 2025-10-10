-- TRY CATCH

BEGIN TRY
	SELECT 1/0; --ERRO
	PRINT 'Não cheguei aqui';
END TRY
BEGIN CATCH
	PRINT 'DEU ERRO!';
	PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem: ' + ERROR_MESSAGE();
END CATCH

-- TRY CATCH + TRANSACTION

BEGIN TRY
	BEGIN TRAN;

	UPDATE FUNCIONARIO
	SET Dnr = 1212
	WHERE Cpf = '98765432168'

	COMMIT TRAN
	PRINT 'Realizada alteração de departamento!'
END TRY
BEGIN CATCH
	-- XACT_STATE() retorna o estado da transação 1
	-- 1 - Transação em aberto
	-- 0 - Não existe Transação em aberto
	IF XACT_STATE() <> 0
		ROLLBACK TRAN;
	PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	PRINT 'Mensagem: ' + ERROR_MESSAGE();
END CATCH