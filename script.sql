/*******************************************************************************
🎵 DIGITAL MUSIC STORE DATA ANALYSIS (SQL PROJECT)
   Presented by: [Your Name]
   Date: May 30, 2026
*******************************************************************************/

USE music_store_data;


-- =============================================================================
-- 🔹 PART 1: CORE BUSINESS OPERATIONS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TASK 1: Senior-Most Employee
-- Objective: Identify the senior-most employee based on job title.
-- -----------------------------------------------------------------------------
SELECT employee_id, first_name, last_name, title, levels 
FROM employee 
ORDER BY levels DESC 
LIMIT 1;


-- -----------------------------------------------------------------------------
-- TASK 2: Top Sales Regions
-- Objective: Find the countries with the highest number of invoices.
-- -----------------------------------------------------------------------------
SELECT billing_country, COUNT(*) AS invoice_count 
FROM invoice 
GROUP BY billing_country 
ORDER BY invoice_count DESC;


-- -----------------------------------------------------------------------------
-- TASK 3: Peak Transaction Values
-- Objective: Determine the top 3 highest single invoice values.
-- -----------------------------------------------------------------------------
SELECT total 
FROM invoice 
ORDER BY total DESC 
LIMIT 3;


-- -----------------------------------------------------------------------------
-- TASK 4: High-Revenue Markets
-- Objective: Identify the city that generated the highest total revenue.
-- -----------------------------------------------------------------------------
SELECT billing_city, SUM(total) AS total_revenue 
FROM invoice 
GROUP BY billing_city 
ORDER BY total_revenue DESC 
LIMIT 1;


-- -----------------------------------------------------------------------------
-- TASK 5: High-Value Customer Profile
-- Objective: Find the best customer who has spent the most money overall.
-- -----------------------------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spent 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC 
LIMIT 1;


-- =============================================================================
-- 🔸 PART 2: ADVANCED CONTENT & PORTFOLIO METRICS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TASK 6: Rock Music Target Audience
-- -----------------------------------------------------------------------------
SELECT DISTINCT c.email, c.first_name, c.last_name 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
JOIN track t ON il.track_id = t.track_id 
JOIN genre g ON t.genre_id = g.genre_id 
WHERE g.name = 'Rock' 
ORDER BY c.email;


-- -----------------------------------------------------------------------------
-- TASK 7: Prolific Creators
-- -----------------------------------------------------------------------------
SELECT ar.artist_id, ar.name, COUNT(t.track_id) AS track_count
FROM artist ar
JOIN album2 al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY track_count DESC
LIMIT 10;


-- -----------------------------------------------------------------------------
-- TASK 8: Track Duration Evaluation
-- -----------------------------------------------------------------------------
SELECT name, milliseconds 
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track) 
ORDER BY milliseconds DESC;


-- -----------------------------------------------------------------------------
-- TASK 9: Customer Spending by Artist
-- -----------------------------------------------------------------------------

SELECT c.customer_id, c.first_name, c.last_name, ar.name AS artist_name, 
       SUM(il.unit_price * il.quantity) AS amount_spent 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
JOIN track t ON il.track_id = t.track_id 
JOIN album2 al ON t.album_id = al.album_id 
JOIN artist ar ON al.artist_id = ar.artist_id 
GROUP BY c.customer_id, c.first_name, c.last_name, ar.name 
ORDER BY c.customer_id, amount_spent DESC;



-- -----------------------------------------------------------------------------
-- TASK 10: Dominant Regional Genres
-- -----------------------------------------------------------------------------
WITH popular_genre AS (
    SELECT COUNT(il.quantity) AS purchases, c.country, g.name AS genre_name, 
           ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS RowNo 
    FROM invoice_line il 
    JOIN invoice i ON i.invoice_id = il.invoice_id 
    JOIN customer c ON c.customer_id = i.customer_id 
    JOIN track t ON t.track_id = il.track_id 
    JOIN genre g ON g.genre_id = t.genre_id 
    GROUP BY c.country, g.name, g.genre_id
) 
SELECT * FROM popular_genre WHERE RowNo <= 1;
