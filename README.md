# 🎵 Digital Music Store Data Analysis (SQL)

## 📋 Project Overview
This data analytics project evaluates operational metrics, regional market distribution, and customer purchasing cohorts for a global digital music retailer. The goal is to provide data-driven business intelligence strategies using relational database modeling.

* **Program:** Ededge Groups Industry Engagement Program (EGIEP) Capstone
* **Tech Stack:** MySQL, Microsoft Excel, PowerPoint
* **Project Deliverables:** 
  * `music_store_analysis.sql` (Full 10-Task Script)
  * `Presentation.pptx` (Executive Slide Deck)

---

## 🚀 Executive Presentation Video
🎥 **[Click Here to Watch My Full Presentation Video on LinkedIn](https://www.linkedin.com/feed/update/urn:li:activity:7467297127191474177/)**

---

## 📊 Strategic Business Insights (Featured Analytics)

### 🏙️ Task 4: High-Revenue Geographic Markets
* **Objective:** Identify the city that generated the highest total revenue to maximize regional marketing distribution.

```sql
SELECT billing_city, SUM(total) AS total_revenue 
FROM invoice 
GROUP BY billing_city 
ORDER BY total_revenue DESC 
LIMIT 1;
```
* **Output Result:** **Prague** (Total Revenue: **$90.24**)
* **Strategic Insight:** Prague stands out as our top global revenue driver, making it a primary target for upcoming localized marketing campaigns.

---

### 👑 Task 5: Customer Lifetime Value (VIP Profiles)
* **Objective:** Isolate our highest-spending customer to profile our core target buyer persona.

```sql
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spent 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC 
LIMIT 1;
```
* **Output Result:** **František Wichterlová** (Total Spent: **$144.54**)
* **Strategic Insight:** Establishing a premium VIP tier or exclusive loyalty rewards program targeting buyers matching this spending cohort will maximize customer retention rates.

---

### 🎸 Task 6: Audience Segmentation for Email Marketing
* **Objective:** Extract a clean list of customer contact details targeting Rock music listeners for targeted promotional campaigns.

```sql
SELECT DISTINCT c.email, c.first_name, c.last_name 
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id 
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
JOIN track t ON il.track_id = t.track_id 
JOIN genre g ON t.genre_id = g.genre_id 
WHERE g.name = 'Rock' 
ORDER BY c.email;
```
* **Output Result:** Aligned list of user emails across our global consumer base.
* **Strategic Insight:** This 5-table join creates automated marketing segments, preventing budget waste on disinterested demographics.

---

### ⏱️ Task 8: Audio Content Length Evaluation
* **Objective:** Benchmark baseline track lengths to understand user streaming consumption patterns.

```sql
SELECT name, milliseconds 
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track) 
ORDER BY milliseconds DESC;
```
* **Output Result:** Average Track Length Benchmark: **393,599 ms (~6.5 minutes)**
* **Strategic Insight:** Long-form tracks dominate our classic catalog, showing that a significant portion of our user base values complete albums and deep cuts over short commercial singles.

---

### 🌍 Task 10: Dominant Regional Music Genres
* **Objective:** Track consumer genre affinity patterns divided across international boundaries.

```sql
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
```
* **Output Result:** **Rock Music** ranked #1 across almost all major global markets.
* **Strategic Insight:** Relational analytics verify that Rock is our core user acquisition funnel. Licensing and promoting prominent Rock artists should remain our top content procurement strategy.

---

## 📈 Final Recommendations
1. **Geographic Focus:** Reallocate 15% of general marketing spend toward hyper-local ads in high-performing cities like **Prague**.
2. **Loyalty Infrastructure:** Launch exclusive perks for top-tier loyalty brackets (e.g., users like **František**).
3. **Inventory Strategy:** Expand licensing deals for premium Rock catalogs to keep our primary conversion funnel healthy.
