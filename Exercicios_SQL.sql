-- Exercícios usando os comandos do MySQL e a base de dados sakila:
-- Comando SELECT para mostrar todos os atributos da tabela actor:
 SELECT * FROM sakila.actor
-- Selecionar só primeiro nome e o último nome dos atores:
SELECT first_name Nome, last_name Sobrenome FROM sakila.actor;
-- Juntar duas colunas:
SELECT CONCAT(first_name," ", last_name) Nome_Completo, actor_id FROM sakila.actor;
-- Comando WHERE para filtrar uma determinada linha o qual o filtro pertença:
SELECT * FROM sakila.actor WHERE last_name = "MIRANDA" AND first_name = "TOM"
-- Selecione os dados da tabela country onde o country é Brasil
SELECT * FROM sakila.country WHERE country = 'BRAZIL';
-- Comando SELECT/ORDER BY DESC serve para ordenar o atributo first_name da tabela actor por ordem decrescente:
SELECT * FROM sakila.actor ORDER BY first_name DESC;
SELECT * FROM sakila.actor WHERE last_name = "CAGE" ORDER BY first_name DESC;
-- Ordene os dados da tabela filme pelo nome do filme em ordem alfabética:
SELECT * FROM sakila.film ORDER BY title;
-- Comando SELECT / BETWEEN para selecionar por exemplo um intervalo de datas:
SELECT * FROM sakila.actor WHERE last_update BETWEEN "2006-01-01" AND "2006-10-01"
-- Insira um novo ator na tabela actor passando manualmente todos os dados, incluindo actor_id e last_update
INSERT INTO sakila.actor VALUES (202, "MARINA","MIRANDA", "2023-01-23 20:11:33");
-- Comando UPDATE: Atualize na tabela film o valor dos atributos rental_duration para 10, replacement_cost para 5.00 do filme “Citizen Shrek”
UPDATE  sakila.film
SET rental_duration = 10, replacement_cost = 5.5
WHERE title = 'Citizen Shrek';
-- Depois de inserir um ator no id 201, deletá-lo:
DELETE FROM sakila.actor WHERE actor_id = 201;
-- Crie uma tabela de frutas com o comando CREATE TABLE , ALTERE dados com ALTER TALE -- e depois exclua com DROP
CREATE TABLE sakila.fruta (
 Nome VARCHAR(50) NOT NULL UNIQUE,
 Cor VARCHAR(20));
-- alteração para adicionar coluna
ALTER TABLE sakila.fruta
ADD COLUMN fruta_id SMALLINT UNSIGNED AUTO_INCREMENT,
ADD PRIMARY KEY (fruta_id);
-- alteração para modificar quantidade de caracter
ALTER TABLE sakila.fruta
MODIFY Nome VARCHAR(100)
-- alteração para adicionar coluna:
ALTER TABLE sakila.fruta
ADD COLUMN Caloria SMALLINT CHECK (Caloria > 2)
-- alteração para deletar coluna:
ALTER TABLE sakila.fruta
 DROP COLUMN Cor;
-- deletar a tabela toda:
DROP TABLE sakila.fruta;  
-- Quantos atores tem o mesmo sobrenome?
  SELECT last_name Sobrenome, COUNT(actor_id) Total FROM sakila.actor GROUP BY last_name ORDER BY Total DESC;
-- Na tabela customer, conte a quantidade de clientes ativos e inativos (bonus: colocar as palavras ativo e inativo, em vez de 0 e 1)
SELECT REPLACE( REPLACE(active, '1', 'ativo'),'0', 'inativo') Situacao, COUNT(customer_id) Total FROM sakila.customer GROUP BY active;
-- Qual o Total do Aluguel para cada filme?
  SELECT title Título, SUM(rental_rate) Total_Aluguel FROM sakila.film GROUP BY title ORDER BY Total_Aluguel DESC;
-- Combinando funções, vamos combinar as funções CONCAT, SUBSTRING e LOWER
-- Colocando só primeira letra em maiúscula e as outras em minuscula
SELECT CONCAT( SUBSTRING(first_name, 1, 1), LOWER(SUBSTRING(first_name, 2)), ' ', SUBSTRING(last_name, 1, 1), LOWER(SUBSTRING(last_name, 2)) ) AS 'Nome Completo' FROM sakila.actor;
-- Vamos unir  com JOIN os resultados das tabelas film e category:
SELECT * FROM sakila.film  JOIN sakila.category cat ON category_id = film_id
-- Podemos especificar quais campos queremos das duas tabelas do join:
-- vamos juntar duas tabelas o título do filme de uma tabela com a categoria do filme de outra
SELECT title Titulo, name Categoria FROM sakila.film JOIN sakila.category ON category_id = film_id;
-- Faça um select que recupere o nome do cliente na tabela customer e o distrito na tabela address.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, address.district
FROM sakila.customer
JOIN sakila.address ON customer.address_id = address.address_id;
-- Recupere o nome e sobrenome do cliente (customer) e a quantidade de locações (rental) que ele fez, com ordenação do maior para o menor.
SELECT customer.first_name, customer.last_name, sum(rental.customer_id) AS locaçoes
FROM sakila.customer
JOIN sakila.rental ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id
ORDER BY sum(rental.customer_id) DESC;
-- Descobrir qual filme mais lucrativo para a locadora até o momento
SELECT 
sakila.film.title as Filme, SUM(amount) AS Mais_Lucrativos
FROM sakila.payment
LEFT JOIN sakila.rental ON (payment.rental_id=rental.rental_id)
LEFT JOIN sakila.inventory ON (rental.inventory_id=inventory.inventory_id)
LEFT JOIN sakila.film ON (inventory.film_id=film.film_id)
GROUP BY sakila.film.title
ORDER BY Mais_Lucrativos DESC;
-- selecionar apenas uma cidade, do país Brasil:
SELECT * FROM sakila.city
WHERE country_id = (
	SELECT country_id
	FROM sakila.country
	WHERE country = "Brazil")
LIMIT 1;
-- Selecionar apenas 3 filmes usando LIMIT:
SELECT *
FROM sakila.film
LIMIT 3;
-- Selecionar 3 filmes que tenham no titulo a palavra Stone:
SELECT *
FROM sakila.film
WHERE title LIKE "%STONE%"
LIMIT 3;
-- Mostrar a quantidade de atores que já atuaram em mais de 2 filmes, usando HAVING:
SELECT 
CONCAT(a.first_name, ' ', a.last_name) Atores, COUNT(f.film_id) Total FROM sakila.actor a
 JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id 
JOIN sakila.film f ON f.film_id = fa.film_id 
GROUP BY a.actor_id 
HAVING Total > 2 
ORDER By Total DESC;
-- Descobrir qual Loja mais lucrativa para a locadora:
 SELECT 
sakila.store.store_id AS Loja, SUM(amount) AS Loja_mais_Lucrativa
FROM sakila.payment
JOIN sakila.staff ON (payment.staff_id=staff.staff_id)
JOIN sakila.store ON (staff.staff_id=store.store_id)
GROUP BY sakila.store.store_id
ORDER BY Loja_mais_lucrativa DESC;
-- Quais foram os clientes que mais alugaram filmes?
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS Cliente, COUNT(rental_id) AS Mais_alugaram
FROM sakila.rental
JOIN sakila.customer ON (rental.customer_id=customer.customer_id)
GROUP BY Cliente
ORDER BY Mais_alugaram DESC;
-- Clientes que mais pagaram ao longo do cadastro:
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS Cliente, SUM(amount) AS Pagamentos
FROM sakila.payment
JOIN sakila.customer ON (payment.customer_id=customer.customer_id)
GROUP BY Cliente
ORDER BY Pagamentos DESC;
-- Qual a frequencia dos dias de semana em que mais filmes são alugados
-- e a frequencia percentual com duas casas decimais
SELECT 
DAYNAME(rental_date) Semana, 
COUNT(rental_id) Quant_Aluguel, 
(SELECT COUNT(rental_id) FROM sakila.rental) Total,
FORMAT((COUNT(rental_id)/(SELECT COUNT(rental_id) FROM sakila.rental))*100  ,2)  Frequencia_perc
FROM sakila.rental
GROUP BY Semana
ORDER BY Frequencia_perc DESC;
-- Qual a categoria é mais lucrativa?
SELECT 
sakila.category.name  Categoria, SUM(amount)  Mais_Lucrativas
FROM sakila.payment
JOIN sakila.rental ON (payment.rental_id=rental.rental_id)
JOIN sakila.inventory ON (inventory.inventory_id=rental.inventory_id)
JOIN sakila.film ON (film.film_id=inventory.film_id)
JOIN sakila.film_category ON (film.film_id=film_category.film_id)
JOIN sakila.category ON (film_category.category_id=category.category_id)
GROUP BY Categoria
ORDER BY Mais_Lucrativas DESC;
-- Quantos Clientes novos a empresa adquiriu por mês:
SELECT 
CONCAT(MONTHNAME(first_rental_day),"/", YEAR(first_rental_day)) Tempo,
COUNT(customer_id) Qtd
FROM
(SELECT customer_id, MIN(rental_date) first_rental_day
FROM sakila.rental
GROUP BY customer_id) Tabela_derivada
GROUP BY Tempo;
-- Quais distritos que menos alugam filmes?
SELECT 
sakila.address.district  Distrito, SUM(amount)  Total
FROM sakila.payment
JOIN sakila.rental ON (payment.rental_id=rental.rental_id)
JOIN sakila.customer ON (customer.customer_id=rental.customer_id)
JOIN sakila.address ON (address.address_id=customer.address_id)
GROUP BY Distrito
ORDER BY Total;



