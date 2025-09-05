-- Declaração de Variáveis
DECLARE @idade INT,
		@nome VARCHAR(40),
		@data DATE,
		@dinheiro MONEY;

SET @nome = 'Andrisa Santos';
SET @data = '2005-01-11';
SET @dinheiro = 7;
SET @idade = YEAR(GETDATE()) - YEAR(@data);

SELECT @nome AS 'Nome', @data AS 'Data_Nasc',
		@idade AS 'Idade', @dinheiro AS 'Dinheiro';

PRINT 'Meu nome é: ' + @nome
	+ ', nascida em: ' + CAST(@data AS VARCHAR(11));

--
DECLARE @departamento_nome VARCHAR(40);

SET @departamento_nome = (SELECT D.Dnome
					FROM DEPARTAMENTO AS D
					WHERE D.Dnumero = 4);

PRINT @departamento_nome;

-- CAST (Converte para String)
DECLARE @nome_funcionaria VARCHAR(40),
		@salario MONEY,
		@data_funcionaria DATE,
		@idade_funcionaria INT;

SET @nome_funcionaria = 'Fernando';

SET @salario = (
				SELECT F.Salario
				FROM FUNCIONARIO AS F
				WHERE F.Pnome = @nome_funcionaria) * 1.1;

SET @data_funcionaria = (
						SELECT F.Datanasc
						FROM FUNCIONARIO AS F
						WHERE F.Pnome = @nome_funcionaria);

SET @idade_funcionaria = YEAR(GETDATE()) - YEAR(@data_funcionaria);
IF MONTH(GETDATE()) < MONTH(@data_funcionaria)
	BEGIN
		SET @idade_funcionaria -= 1
	END;

PRINT 'Meu nome é: ' + @nome_funcionaria
	+ ', meu salário é: ' + CAST(@salario AS VARCHAR(11))
	+ ', tenho ' + CAST(@idade_funcionaria AS VARCHAR(11)) + ' anos';




-- CONVERT (Data - Estilo)
PRINT CONVERT(VARCHAR(10), @data_funcionaria, 103);

-- IF/ELSE
DECLARE @media_salarial MONEY;

SET @media_salarial = (
						SELECT AVG(F.Salario)
						FROM FUNCIONARIO AS F);

IF @salario < @media_salarial
	BEGIN
		PRINT @nome_funcionaria  + ' tem o salário menor que a média';
	END;
ELSE
	BEGIN
		PRINT @nome_funcionaria +  ' tem o salário maior que a média';
	END;

DECLARE @aposentadoria INT,
		@aposentadoria_compulsoria INT;

SET @aposentadoria = 55;
SET @aposentadoria_compulsoria = 65;

IF @idade_funcionaria > @aposentadoria AND @idade_funcionaria < @aposentadoria_compulsoria
	BEGIN
		PRINT @nome_funcionaria + ' está perto de se aposentar';
	END;
ELSE IF @idade_funcionaria > @aposentadoria_compulsoria
	BEGIN
		PRINT @nome_funcionaria + ' deve se aposentar imediatamente';
	END;
ELSE
	BEGIN
		PRINT @nome_funcionaria + ' não está perto de se aposentar';
	END;


--
DECLARE @tamanho_dpt INT;
DECLARE @nr_dpt INT;

SET @nr_dpt = 5;

SET @tamanho_dpt = (
					SELECT COUNT(F.Cpf)
					FROM DEPARTAMENTO AS D
					INNER JOIN FUNCIONARIO AS F
					ON D.Dnumero = F.Dnr
					WHERE D.Dnumero = @nr_dpt);

IF @tamanho_dpt <= 1
	BEGIN
		PRINT CAST(@tamanho_dpt AS VARCHAR(5)) + ' funcionários. Departamento pequeno'
	END;
ELSE IF @tamanho_dpt = 2 OR @tamanho_dpt = 3
	BEGIN
		PRINT CAST(@tamanho_dpt AS VARCHAR(5)) + ' funcionários. Departamento médio'
	END;
ELSE
	BEGIN
		PRINT CAST(@tamanho_dpt AS VARCHAR(5)) + ' funcionários. Departamento grande'
	END;


-- WHILE

DECLARE @valor INT;

SET @valor = 0;

WHILE @valor < 10
	BEGIN
		PRINT 'Número: ' + CAST(@valor AS VARCHAR(3))
		SET @valor = @valor + 1
	END;


DECLARE @salario MONEY;

SET @salario = (
				SELECT F.Salario
				FROM FUNCIONARIO AS F
				WHERE F.Pnome = 'Joice' AND F.Unome = 'Leite');


WHILE @salario <= 30000
	BEGIN
		PRINT 'Salário de Joice Leite: ' + CAST(@salario AS VARCHAR(30))
		SET @salario = @salario * 1.05
	END;
