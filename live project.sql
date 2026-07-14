SELECT * FROM assignment.orders;
SELECT * FROM assignment.orders WHERE customer_name LIKE '_a_d%';
SELECT * FROM assignment.orders WHERE YEAR(order_date) = 2020 AND MONTH(order_date)=12;
SELECT * FROM assignment.orders WHERE ship_mode NOT IN ('Standard Class','First Class') AND ship_date > '1-09-2020';
SELECT *FROM assignment.orders WHERE customer_name NOT LIKE 'A%' AND customer_name NOT LIKE '%n';
SELECT *FROM assignment.orders WHERE profit>0;
SELECT *FROM assignment.orders WHERE profit<0;
SELECT * FROM assignment.orders WHERE quantity<3 AND profit=0;
SELECT * FROM assignment.orders WHERE region = 'south'AND discount>0;
SELECT * FROM assignment.orders WHERE category = 'furniture'ORDER BY sales desc LIMIT 5;
SELECT * FROM assignment.orders WHERE category IN ('Furniture','Technology') AND YEAR(order_Date) = 2020;
UPDATE assignment.orders SET city =null WHERE order_id IN  ('CA-2020-161389','US-2021-156909')
LIMIT 2;
SELECT * FROM assignment.orders WHERE city is null ;
SELECT category SUM(profit) AS total profit, MAX(order_Date) AS 