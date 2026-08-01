-- ============================================================================
-- Project: Online Bookstore Sales Analysis
-- Database: PostgreSQL
--
-- Description:
-- This file contains basic SQL queries used to analyze sales, customers,
-- inventory, and book information for an online bookstore.
--
-- Author: Shobhit Kushwaha
-- ============================================================================


-- ============================================================================
-- Question 1
-- Retrieve the total number of books sold for each genre.
-- ============================================================================

SELECT
    b.genre,
    SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b
    ON o.book_id = b.book_id
GROUP BY b.genre
ORDER BY total_books_sold DESC;


-- ============================================================================
-- Question 2
-- Find the average price of books in the 'Fantasy' genre.
-- ============================================================================

SELECT
    AVG(price) AS average_price
FROM books
WHERE genre = 'Fantasy';


-- ============================================================================
-- Question 3
-- List customers who have placed at least two orders.
-- ============================================================================

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
HAVING COUNT(o.order_id) >= 2
ORDER BY total_orders DESC;


-- ============================================================================
-- Question 4
-- Find the most frequently ordered book.
-- ============================================================================

SELECT
    b.book_id,
    b.title,
    COUNT(o.order_id) AS total_orders
FROM books b
JOIN orders o
    ON b.book_id = o.book_id
GROUP BY
    b.book_id,
    b.title
ORDER BY total_orders DESC
LIMIT 1;


-- ============================================================================
-- Question 5
-- Display the top three most expensive books in the Fantasy genre.
-- ============================================================================

SELECT
    book_id,
    title,
    author,
    price
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;


-- ============================================================================
-- Question 6
-- Retrieve the total quantity of books sold by each author.
-- ============================================================================

SELECT
    b.author,
    SUM(o.quantity) AS total_books_sold
FROM books b
JOIN orders o
    ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY total_books_sold DESC;


-- ============================================================================
-- Question 7
-- List the cities where customers placed orders worth more than $30.
-- ============================================================================

SELECT DISTINCT
    c.city
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.total_amount > 30
ORDER BY c.city;


-- ============================================================================
-- Question 8
-- Find the customer who spent the highest total amount.
-- ============================================================================

SELECT
    c.customer_id,
    c.name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY total_spent DESC
LIMIT 1;


-- ============================================================================
-- Question 9
-- Calculate the remaining stock after fulfilling all customer orders.
-- ============================================================================

SELECT
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS quantity_sold,
    b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_stock
FROM books b
LEFT JOIN orders o
    ON b.book_id = o.book_id
GROUP BY
    b.book_id,
    b.title,
    b.stock
ORDER BY b.book_id;