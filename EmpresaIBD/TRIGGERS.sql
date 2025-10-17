-- TRIGGERS

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial, Datanasc, Dnr)
VALUES ('14859756888', 'Juca', 'Figueiredo', 'R', '1987-06-06', 5);
-- 1987-06-06

SELECT * FROM DEPARTAMENTO;
SELECT * FROM FUNCIONARIO;

--
GO
CREATE OR ALTER TRIGGER trg_InserirFuncionario
ON FUNCIONARIO
INSTEAD OF INSERT
AS
DECLARE @nome VARCHAR(100);
SELECT @nome = Pnome FROM inserted; -- FROM INSERTED
PRINT 'Nenhum funcionário de nome ' + @nome + ' inserido.'
GO

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial)
VALUES ('15489756888', 'Teste', 'Figueiredo', 'R');

-- Desabilitar o trigger criado
ALTER TABLE FUNCIONARIO
DISABLE TRIGGER trg_InserirFuncionario;

-- Verificar triggers na tabela
EXEC sp_helptrigger @tabname = FUNCIONARIO;

--
GO
CREATE OR ALTER TRIGGER trg_AlterarFuncionario
ON FUNCIONARIO
AFTER INSERT,UPDATE
AS
BEGIN
IF UPDATE(Pnome)
	BEGIN
		DECLARE @nomeNovo VARCHAR(100);
		DECLARE @nomeAntigo VARCHAR(100);
		SELECT @nomeNovo = Pnome FROM inserted;
		SELECT @nomeAntigo = Pnome FROM deleted;
		PRINT 'Nome ' + @nomeAntigo + ' alterado para ' + @nomeNovo;
	END
ELSE
	BEGIN
		PRINT 'Nome não alterado'
	END
END
GO

UPDATE FUNCIONARIO
SET Pnome = 'Joana'
WHERE Cpf = '12345678966';

--

-- COM AFTER
GO
CREATE OR ALTER TRIGGER trg_InserirNomeCompletoFuncionario
ON FUNCIONARIO
AFTER INSERT
AS
BEGIN
	DECLARE @Duplicados INT;
	SELECT @Duplicados = COUNT(*)
	FROM (
		SELECT Pnome, Unome, Minicial
		FROM FUNCIONARIO
		GROUP BY Pnome, Unome, Minicial
		HAVING COUNT(*) > 1
		) AS Duplicados;
	IF @Duplicados > 0
		BEGIN
			PRINT 'Já existe um funcionário com este nome completo'
			ROLLBACK TRANSACTION;
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION;
			PRINT 'Novo funcionário registrado';
		END
END
GO

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial)
VALUES ('15488556888', 'Valéria', 'Figueiredo', 'R');

ALTER TABLE FUNCIONARIO
DISABLE TRIGGER trg_InserirNomeCompletoFuncionario;

-- COM INSTEAD OF
GO
CREATE OR ALTER TRIGGER trg_InsteadNomeCompleto
ON FUNCIONARIO
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @Pnome VARCHAR(50),
			@Minicial CHAR(1),
			@Unome VARCHAR(50);
	SELECT @Pnome = Pnome, @Minicial = Minicial, @Unome = Unome
	FROM inserted;

	IF EXISTS (
		SELECT 1
		FROM FUNCIONARIO
		WHERE @Pnome = Pnome
		AND @Minicial = Minicial
		AND @Unome = Unome)
	BEGIN
		PRINT 'Já existe alguém com este nome completo!'
		RAISERROR('Erro: Nome duplicado', 16, 0);
	END
	ELSE
	BEGIN
		INSERT INTO FUNCIONARIO (Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr, Bonus, Data_Admissao)
		SELECT Pnome, Minicial, Unome, Cpf, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr, Bonus, Data_Admissao
		FROM inserted;
	END
END
GO

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial)
VALUES ('15488556888', 'Valéria', 'Figueiredo', 'R');

-- EXERCÍCIO 
/*CREATE TABLE Log_Funcionario ( 
				LogID INT IDENTITY(1,1) PRIMARY KEY, 
				Cpf CHAR(11), 
				Operacao VARCHAR(10), 
				Data_Hora DATETIME DEFAULT GETDATE() 
);
Crie um trigger que seja disparado depois que uma 
operação de inserção ocorra na tabela 
FUNCIONARIO. Esse trigger deve registrar o CPF do 
novo funcionário inserido e a operação realizada 
(neste caso, "INSERT") em uma tabela de log 
(Log_Funcionario), juntamente com a data e hora da 
inserção. Esse trigger ajudará a manter um histórico 
das inserções realizadas na tabela de funcionários.
*/

CREATE TABLE Log_Funcionario ( 
		LogID INT IDENTITY(1,1) PRIMARY KEY, 
		Cpf CHAR(11), 
		Operacao VARCHAR(10), 
		Data_Hora DATETIME DEFAULT GETDATE() 
);

GO
CREATE OR ALTER TRIGGER trg_AfterLog
ON FUNCIONARIO
AFTER INSERT
AS
BEGIN
	INSERT INTO Log_Funcionario (Cpf, Operacao)
	SELECT Cpf, 'INSERT'
	FROM inserted;
END
GO

INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Minicial)
VALUES ('15488545688', 'Testalda', 'Figueiredo', 'R');

SELECT * FROM Log_Funcionario;

--
GO
CREATE OR ALTER TRIGGER trg_AfterLogUpdate
ON FUNCIONARIO
AFTER UPDATE
AS
BEGIN
	INSERT INTO Log_Funcionario (Cpf, Operacao)
	SELECT Cpf, 'UPDATE'
	FROM inserted;
END
GO

UPDATE FUNCIONARIO
SET Minicial = 'A'
WHERE Cpf = '15488545688';

-- EXERCÍCIO
/*
Crie um trigger que seja disparado em vez de uma 
exclusão na tabela FUNCIONARIO. Esse trigger deve 
verificar se o funcionário que está sendo excluído é 
gerente de algum departamento. Se for, a exclusão 
deve setar NULL na gerência do departamento, data 
de início do gerente, e em todos os funcionários que 
ele gerencia.
*/