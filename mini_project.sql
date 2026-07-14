/*BASIC LEVEL (1–20)*/



SELECT * FROM mini_project.zepto_v2;
SELECT  name, mrp FROM mini_project.zepto_v2;
SELECT * FROM mini_project.zepto_v2 WHERE ï»¿Category = 'Fruits & Vegetables';
SELECT name FROM mini_project.zepto_v2 WHERE mrp > 3000;
SELECT name FROM mini_project.zepto_v2 WHERE discountPercent = 15;
SELECT name FROM mini_project.zepto_v2 WHERE outOfStock = FALSE;
SELECT name,weightInGms FROM mini_project.zepto_v2 WHERE weightInGms > 500;
SELECT name FROM  mini_project.zepto_v2 WHERE availableQuantity > 5;
SELECT DISTINCT ï»¿Category FROM mini_project.zepto_v2;
SELECT count(name) FROM mini_project.zepto_v2;
SELECT * FROM mini_project.zepto_v2 ORDER BY mrp ASC;
SELECT * FROM mini_project.zepto_v2 ORDER BY discountPercent DESC;
SELECT * FROM mini_project.zepto_v2 ORDER BY mrp DESC limit 10;
SELECT name FROM mini_project.zepto_v2 WHERE name LIKE 'T%';
SELECT count(name) FROM mini_project.zepto_v2 WHERE outOfStock = TRUE;
SELECT name FROM  mini_project.zepto_v2 WHERE quantity > 50;
SELECT name FROM  mini_project.zepto_v2 WHERE mrp BETWEEN 2000 AND 4000;
SELECT name FROM  mini_project.zepto_v2 WHERE discountedSellingPrice < 1500;
SELECT name FROM  mini_project.zepto_v2 WHERE weightInGms = 1000;
SELECT * FROM mini_project.zepto_v2 WHERE ï»¿Category like 'Fruits & Vegetables';

---------------------------------------------------------------------------------------
/*INTERMEDIATE LEVEL (21–35)*/

SELECT ï»¿Category,max(mrp) AS MAX FROM mini_project.zepto_v2  group by ï»¿Category;
SELECT ï»¿Category, min(discountedSellingPrice) AS MIN FROM mini_project.zepto_v2  group by ï»¿Category;
SELECT ï»¿Category,count(name) AS COUNT FROM mini_project.zepto_v2  group by ï»¿Category;
SELECT ï»¿Category,avg(mrp) AS AVG FROM mini_project.zepto_v2  group by ï»¿Category;
SELECT ï»¿Category,sum(quantity)AS TOTAL FROM mini_project.zepto_v2  group by ï»¿Category;
SELECT * FROM mini_project.zepto_v2 WHERE (mrp-discountedSellingPrice)>1000;
SELECT name,(mrp-discountedSellingPrice) AS Discount FROM mini_project.zepto_v2 WHERE (mrp-discountedSellingPrice) > (SELECT avg(mrp-discountedSellingPrice) FROM mini_project.zepto_v2) ; 
SELECT ï»¿Category,count(*) AS COUNT_NAME  FROM mini_project.zepto_v2 group by ï»¿Category  HAVING count(*) > 50;
SELECT name,discountPercent FROM mini_project.zepto_v2 order by discountPercent desc limit 5 ;
SELECT name,mrp,(mrp*0.5) AS Half_mrp,discountedSellingPrice FROM mini_project.zepto_v2 where discountedSellingPrice < (mrp*0.5);
SELECT name FROM mini_project.zepto_v2 WHERE name like'%Coconut%';
SELECT name,(discountedSellingPrice*availableQuantity) AS Total_Stock_Value FROM mini_project.zepto_v2 ;
SELECT name,max(mrp-discountedSellingPrice) AS Max_Discount FROM mini_project.zepto_v2 GROUP BY ï»¿Category;
SELECT ï»¿Category,AVG(mrp - discountedSellingPrice) AS Avg_Discount FROM mini_project.zepto_v2 GROUP BY ï»¿Category;
SELECT  name, ï»¿Category, availableQuantity, outOfStock FROM mini_project.zepto_v2 WHERE availableQuantity = 0 AND outOfStock = FALSE;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ADVANCED LEVEL (36–50)*/
ALTER TABLE mini_project.zepto_v2 RENAME COLUMN ï»¿Category to Category;
SELECT name, mrp,RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS RANKS FROM mini_project.zepto_v2 ;
SELECT name,category,mrp FROM (SELECT name,category,mrp,DENSE_RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rnk FROM mini_project.zepto_v2) ranked WHERE rnk = 2;
SELECT category,name,availableQuantity,SUM(availableQuantity) OVER (PARTITION BY category ORDER BY name ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_quantity FROM mini_project.zepto_v2 ORDER BY category, name;
SELECT name,category,mrp FROM (SELECT name,category,mrp,AVG(mrp) OVER (PARTITION BY category) AS avg_mrp FROM mini_project.zepto_v2 ) t WHERE mrp > avg_mrp;
SELECT name,discountPercent,category FROM (SELECT name,category,discountPercent,AVG(discountPercent) OVER (PARTITION BY category) AS avg_Discountpercent FROM mini_project.zepto_v2 ) t WHERE discountPercent > avg_Discountpercent;
CREATE VIEW in_stock_high_discounts AS
SELECT 
    name,
    category,
    mrp,
    discountedSellingPrice,
    availableQuantity,
    ((mrp - discountedSellingPrice) / mrp * 100) AS discountPercent
FROM mini_project.zepto_v2
WHERE availableQuantity > 0
  AND ((mrp - discountedSellingPrice) / mrp * 100) > 20;

DELIMITER $$

UPDATE mini_project.zepto_v2
SET outOfStock = TRUE
WHERE availableQuantity = 0;



CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(100))
BEGIN
    SELECT 
        name,
        category,
        mrp,
        discountedSellingPrice,
        availableQuantity,
        discountPercent
    FROM mini_project.zepto_v2
    WHERE category = cat_name;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION GetDiscountAmount(mrp DECIMAL(10,2), discountedSellingPrice DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount DECIMAL(10,2);
    SET discount = mrp - discountedSellingPrice;
    RETURN discount;
END $$

DELIMITER ;

SELECT 
    name,
    COUNT(*) AS duplicate_count
FROM mini_project.zepto_v2
GROUP BY name
HAVING COUNT(*) > 1;

SELECT 
    name,
    category,
    mrp
FROM (
    SELECT 
        name,
        category,
        mrp,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY mrp ASC) AS rnk
    FROM mini_project.zepto_v2
) t
WHERE rnk <= 3
ORDER BY category, mrp;

SELECT 
    category,
    SUM(mrp * availableQuantity) AS total_stock_value
FROM mini_project.zepto_v2
GROUP BY category
HAVING SUM(mrp * availableQuantity) > 100000;

SELECT 
    category,
    SUM(mrp * availableQuantity) AS total_stock_value
FROM mini_project.zepto_v2
GROUP BY category
HAVING SUM(mrp * availableQuantity) > 100000;

SELECT 
    category,
    COUNT(*) AS total_products,
    AVG(mrp) AS avg_mrp,
    AVG(discountPercent) AS avg_discount
FROM mini_project.zepto_v2
GROUP BY category
ORDER BY category;


SELECT 
    name,
    category,
    mrp
FROM mini_project.zepto_v2
WHERE mrp > (
    SELECT AVG(mrp) 
    FROM mini_project.zepto_v2
);












 
