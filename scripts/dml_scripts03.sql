-- =============================================
-- SCRIPTS DE ALTERAÇÃO/DELEÇÃO (DML)
-- =============================================

-- Script 1: Atualizar nacionalidade de um autor
UPDATE autores SET nacionalidade = 'Brasileira (naturalizado)' WHERE cod_autor = 2;

-- Script 2: Atualizar o preço de livros de uma área específica
UPDATE itenspedido SET preco_unitario = preco_unitario * 1.1 
WHERE num_serie IN (
    SELECT e.num_serie FROM exemplares e
    JOIN livros l ON e.isbn = l.isbn
    WHERE l.cod_area = 1
);

-- Script 3: Alterar o status de pedidos antigos
UPDATE pedidos SET status = 'entregue' WHERE data_pedido < '2023-02-01' AND status = 'enviado';

-- Script 4: Atualizar o departamento de um funcionário
UPDATE funcionarios SET cod_departamento = 2 WHERE cod_funcionario = 6;

-- Script 5: Mover exemplares para nova localização
UPDATE exemplares SET localizacao = 'Depósito Externo' WHERE estado = 'danificado';

-- Script 6: Atualizar o responsável de um departamento
UPDATE departamentos SET responsavel = 'Paulo Mendes' WHERE cod_departamento = 5;

-- Script 7: Atualizar dados de contato de cliente
UPDATE clientes SET telefone = '(11) 99876-5432', email = 'novo.email@exemplo.com' WHERE cod_cliente = 3;

-- Script 8: Cancelar pedidos pendentes antigos
UPDATE pedidos SET status = 'cancelado' 
WHERE status = 'pendente' AND data_pedido < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Script 9: Aumentar quantidade de itens em pedidos grandes
UPDATE itenspedido SET quantidade = quantidade + 1 
WHERE cod_pedido IN (SELECT cod_pedido FROM pedidos WHERE status = 'pendente');

-- Script 10: Alterar descrição de áreas de conhecimento
UPDATE areasconhecimento SET descricao = 'Ciências da Computação e Tecnologia' WHERE cod_area = 4;

-- Script 11: Excluir palavras-chave sem uso
DELETE FROM palavraschave 
WHERE cod_palavra NOT IN (SELECT DISTINCT cod_palavra FROM livrospalavraschave);

-- Script 12: Remover exemplares vendidos e sem pedidos
DELETE FROM exemplares 
WHERE estado = 'vendido' AND num_serie NOT IN (SELECT DISTINCT num_serie FROM itenspedido);

-- Script 13: Excluir registro duplicado de cliente
DELETE c1 FROM clientes c1
JOIN clientes c2 ON c1.email = c2.email AND c1.cod_cliente > c2.cod_cliente;

-- Script 14: Deletar funcionários de departamento específico
DELETE FROM funcionarios WHERE cod_departamento = 5 AND cargo = 'Estagiário';

-- Script 15: Remover associações de livros com palavras-chave específicas
DELETE FROM livrospalavraschave WHERE cod_palavra IN (SELECT cod_palavra FROM palavraschave WHERE descricao = 'obsoleto');

-- Script 16: Excluir pedidos cancelados antigos
DELETE FROM pedidos 
WHERE status = 'cancelado' AND data_pedido < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Script 17: Remover autores sem livros publicados
DELETE FROM autores 
WHERE cod_autor NOT IN (SELECT DISTINCT cod_autor FROM livrosautores);

-- Script 18: Excluir livros sem exemplares
DELETE FROM livros 
WHERE isbn NOT IN (SELECT DISTINCT isbn FROM exemplares);

-- Script 19: Remover associações de livros fora de catálogo
DELETE FROM livrospalavraschave 
WHERE isbn IN (SELECT isbn FROM livros WHERE data_publicacao < '1950-01-01');

-- Script 20: Limpar histórico de pedidos de clientes inativos
DELETE FROM pedidos 
WHERE cod_cliente IN (
    SELECT cod_cliente FROM clientes 
    WHERE cod_cliente NOT IN (
        SELECT DISTINCT cod_cliente FROM pedidos 
        WHERE data_pedido > DATE_SUB(NOW(), INTERVAL 1 YEAR)
    )
);