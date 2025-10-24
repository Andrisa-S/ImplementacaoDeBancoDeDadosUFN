-- Cria um banco para a aula de restrições
CREATE DATABASE RESTRICOES;
--
GO;
-- Coloca o banco em uso
USE RESTRICOES;
GO;

CREATE TABLE petShop
(
	id INT PRIMARY KEY IDENTITY,
	nomeDono VARCHAR(50) UNIQUE,
	nomePet VARCHAR(50),
	idadePet INT CHECK (idadePet > 0),
	sexoPet CHAR CHECK (sexoPet IN ('M', 'F', 'N'))
);

-- Testando as restrições
INSERT INTO petShop VALUES('Andrisa', 'Kim', 2, 'F');
INSERT INTO petShop VALUES('Nadine', 'Petra', -2, 'F');

GO;

-- CASCADE
CREATE TABLE Produto
(
	cod INT PRIMARY KEY,
	nome VARCHAR(50),
	categoria VARCHAR(50),
);

CREATE TABLE Inventario
(
	id INT PRIMARY KEY IDENTITY,
	codProduto INT,
	qtd INT,
	minLevel INT,
	maxLevel INT,
	CONSTRAINT fk_inv_produto
		FOREIGN KEY (codProduto)
		REFERENCES Produto (cod)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- Outra forma de criar restrições
/*ALTER TABLE Inventario
ADD CONSTRAINT fk_inv_produto
		FOREIGN KEY (codProduto)
		REFERENCES Produto (cod)
		ON DELETE CASCADE
		ON UPDATE CASCADE;
*/

CREATE TABLE Venda
(
	id INT PRIMARY KEY IDENTITY,
	codProduto INT,
	qtd INT
);

ALTER TABLE Venda
ADD CONSTRAINT fk_Venda_produto
		FOREIGN KEY (codProduto)
		REFERENCES Produto (cod)
		ON DELETE SET NULL
		ON UPDATE CASCADE;

-- Cadastrando produtos
INSERT INTO Produto
VALUES (1, 'Sabonete', 'Higiene'),
	   (2, 'Coca-Cola', 'Bebidas'),
	   (3, 'Vodka', 'Bebidas'),
	   (4, 'Chocolate', 'Doces'),
	   (5, 'Bala de goma', 'Doces'),
	   (6, 'Baly', 'Bebidas'),
	   (7, 'Chiclete', 'Doces');

INSERT INTO Inventario (codProduto, qtd, minLevel, maxLevel)
VALUES (1, 8, 2, 20),
	   (2, 100, 50, 500),
	   (3, 70, 30, 300),
	   (4, 150, 70, 1000),
	   (5, 50, 25, 700),
	   (6, 100, 30, 350),
	   (7, 300, 100, 1300);

-- Simulando algumas vendas
INSERT INTO Venda
VALUES (87, 5),
	   (3, 3),
	   (4, 7),
	   (5, 10),
	   (6, 2),
	   (3, 1),
	   (7, 3);

SELECT * FROM Produto AS P
INNER JOIN Inventario AS I ON I.codProduto = P.cod;

SELECT * FROM Produto AS P
RIGHT JOIN Venda AS V ON V.codProduto = P.cod;

DELETE FROM Produto
WHERE cod = 5;

UPDATE Produto
SET cod = 2
WHERE cod = 87;

ALTER TABLE Venda
DROP CONSTRAINT fk_Venda_produto;