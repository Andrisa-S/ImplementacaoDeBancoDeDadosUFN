-- VIEW
CREATE VIEW vw_Informacoes AS
SELECT isbn AS 'ISBN', titulo AS 'Título', ano AS 'Ano', Editora.nome AS 'Editora', concat(Autor.nome, ' (',nacionalidade,')') AS 'Autor/Nacionalidade', tipo_categoria AS 'Categoria'
FROM Livro, Editora, Categoria, Autor, LivroAutor
WHERE Livro.fk_editora = Editora.id
AND Livro.fk_categoria = Categoria.id
ANd LivroAutor.fk_autor = Autor.id
AND LivroAutor.fk_livro = Livro.isbn;

SELECT * FROM vw_Informacoes ORDER BY Título;