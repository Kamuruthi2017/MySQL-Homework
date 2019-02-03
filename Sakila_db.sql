-- To activate the database.
USE sakila;

-- To run the table
SELECT * FROM actor;

--  Display the first and last names of all actors from the table actor.
SELECT first_name,last_name FROM actor;

-- To display the first and last name of each actor in a single column in upper case letters.
-- To label the new column Actor_Name.
SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name FROM actor;

-- query to obtain information about Joe.
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'JOE';

-- To find all actors whose last name contain the letters `GEN'.
select * from actor where last_name like '%GEN%';

-- To find all actors whose last names contain the letters `LI`.
-- To order the rows by last name and first name.
select * from actor where last_name like '%LI%'
ORDER BY last_name, first_name;

-- Using `IN` to display the `country_id` and `country` columns of Afghanistan, Bangladesh, and China
SELECT country_id, country
  FROM country
 WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
 
-- Create a column in the table `actor` named `description` and use the data type `BLOB` 
SELECT * FROM ACTOR;
ALTER TABLE actor 
ADD COLUMN description BLOB(50);

-- Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;

-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name;

-- Names that are shared by at least two actors
SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name
HAVING Count > 2;

-- Write a query to fix the record from `GROUCHO WILLIAMS` to `HARPO WILLIAMS`
UPDATE actor 
SET first_name= 'HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

 -- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';
--  query to re-create Address table
SHOW CREATE TABLE address; 

-- Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`.
SELECT * FROM staff;
SELECT * FROM address;
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
staff.address_id=address.address_id;

-- Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
-- Use tables `staff` and `payment.
SELECT * FROM staff;
SELECT * FROM payment;
SELECT staff.first_name, staff.last_name, payment.amount
from payment
INNER JOIN staff on 
staff.staff_id = payment.staff_id 
WHERE payment_date LIKE "%2005-08%";

-- List each film and the number of actors who are listed for that film.
-- Use tables `film_actor` and `film`. Use inner join.
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT COUNT(*) Totalcount,
	   film_actor.actor_id,
       film.title
FROM film
         INNER JOIN film_actor
              ON film.film_id = film_actor.film_id
GROUP BY film_actor.actor_id;

-- How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT * FROM film;
SELECT COUNT(title)
FROM film
WHERE title='Hunchback Impossible';

-- Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT * FROM payment;
SELECT * FROM customer;
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'TOTAL'
FROM customer 
LEFT JOIN payment 
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

--  Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT * FROM film;
SELECT title 
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id=(SELECT language_id FROM language where name='English');

-- Use subqueries to display all actors who appear in the film `Alone Trip`
SELECT * FROM actor;
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));
        
-- names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT * FROM customer;
SELECT * FROM address;
SELECT first_name, last_name, email 
FROM customer 
JOIN address  ON (customer.address_id = address.address_id)
JOIN city  ON (address.city_id=city.city_id)
JOIN country  ON (city.country_id=country.country_id);

-- Identify all movies categorized as _family_ films
SELECT * FROM film_list;
SELECT title,category
FROM film_list
WHERE category = 'family';

-- Display the most frequently rented movies in descending order
SELECT * FROM rental;
SELECT title, COUNT(film.film_id) AS 'Count_of_Rented_Movies'
FROM  film 
JOIN inventory  ON (film.film_id= inventory.film_id)
JOIN rental  ON (inventory.inventory_id=rental.inventory_id)
GROUP BY title 
ORDER BY Count_of_Rented_Movies DESC;

-- Write a query to display how much business, in dollars, each store brought in
SELECT * FROM staff;
SELECT staff.store_id, SUM(payment.amount) 
FROM payment 
JOIN staff  ON (payment.staff_id=staff.staff_id)
GROUP BY store_id;

-- Write a query to display for each store its store ID, city, and country
SELECT store_id, city, country FROM store 
JOIN address  ON (store.address_id=address.address_id)
JOIN city  ON (address.city_id=city.city_id)
JOIN country  ON (country.country_id=country.country_id);

-- List the top five genres in gross revenue in descending order. 
SELECT * FROM category;

SELECT c.name,SUM(p.amount)
FROM payment p
JOIN rental r ON p.rental_id=r.rental_id
JOIN inventory i ON r.inventory_id=i.inventory_id
JOIN film_category fc ON i.film_id=fc.film_id
JOIN category c ON fc.category_id=c.category_id
GROUP BY c.name 
ORDER BY SUM(p.amount) DESC 
LIMIT 5;

-- Use the solution from the problem above to create a view
CREATE VIEW Top_5_Genres as 
SELECT c.name,SUM(p.amount)
FROM payment p
JOIN rental r ON p.rental_id=r.rental_id
JOIN inventory i ON r.inventory_id=i.inventory_id
JOIN film_category fc ON i.film_id=fc.film_id
JOIN category c ON fc.category_id=c.category_id
GROUP BY c.name 
ORDER BY SUM(p.amount) DESC 
LIMIT 5;

-- display the view that you created in 8a
SELECT * FROM Top_5_Genres;

-- You find that you no longer need the view `top_five_genres`. Write a query to delete it
DROP VIEW Top_5_Genres;