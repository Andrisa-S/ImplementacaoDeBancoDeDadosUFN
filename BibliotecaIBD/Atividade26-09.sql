
CREATE PROCEDURE usp_inserirCategoria (@Nome varchar(40))
	AS
	BEGIN
		insert into categoria (tipo_categoria) values (@Nome);
		
	END

	exec usp_inserirCategoria 'História';


	select * from categoria

go

--
CREATE PROCEDURE usp_AtualizarLivro (@Titulo VARCHAR(100), @Ano INT, @isbn VARCHAR(50))
	AS
	BEGIN
		UPDATE Livro
		SET titulo = @Titulo, ano = @Ano
		WHERE isbn = @isbn
	END


EXEC usp_AtualizarLivro 'O Senhor dos Anéis', 1937, '9788581742458';

SELECT * FROM Livro;

GO

--

CREATE PROCEDURE usp_AdicionaAutor (@Nome VARCHAR(100), @Nacionalidade VARCHAR(50))
	AS
	BEGIN
		insert into autor (nome, nacionalidade) values (@Nome, @Nacionalidade);
	END

exec usp_AdicionaAutor 'Érico Veríssimo', 'Brasil';

select * from Autor;

GO


--Gustavo - tive que criar um metodo para excluir o autor por que fiz errado antes e adicionei 32 Éricos Veríssimos
CREATE PROCEDURE usp_ExcluirAutor (@Nome VARCHAR(100), @Nacionalidade VARCHAR(50))
	AS
	BEGIN
		DELETE  
		FROM Autor
		WHERE Autor.nome = @Nome and Autor.nacionalidade = @Nacionalidade
	END

exec usp_ExcluirAutor 'Érico Veríssimo', 'Brasil';

GO

--

CREATE PROCEDURE usp_ExcluirLivroAutor (@IdAutor INT)
	AS
	BEGIN
		DECLARE @idLA INT
		SET @idLA = (
					SELECT LA.id
					FROM LivroAutor AS LA
					INNER JOIN Autor AS A
					ON LA.fk_autor = @IdAutor);

		DELETE FROM Livro WHERE Livro.isbn = @idLA;
		DELETE FROM LivroAutor WHERE LivroAutor.fk_autor = @IdAutor;
		DELETE FROM Autor WHERE Autor.id = @IdAutor;

	END

EXEC usp_ExcluirLivroAutor 1;

SELECT * FROM Livro;
SELECT * FROM Autor;
SELECT * FROM LivroAutor;