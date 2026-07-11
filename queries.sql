-- Esta consulta cuenta el número total de clientes registrados en la tabla customers

SELECT COUNT(*) AS customers_count
FROM customers;

-- REPORTE 1: Los 10 vendedores con mayor facturación total
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, COUNT(s.sales_id) AS operations, FLOOR(SUM(s.quantity * p.price)) AS income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id ORDER BY income DESC LIMIT 10;

-- REPORTE 2: Vendedores con ingresos promedio por venta inferiores al promedio general
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, FLOOR(AVG(s.quantity * p.price)) AS average_income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id HAVING AVG(s.quantity * p.price) < (SELECT AVG(s2.quantity * p2.price) FROM sales s2 JOIN products p2 ON s2.product_id = p2.product_id) ORDER BY average_income ASC;

-- REPORTE 3: Resumen de ingresos acumulados por vendedor según el día de la semana
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, TRIM(LOWER(TO_CHAR(s.sale_date, 'Day'))) AS day_of_week, FLOOR(SUM(s.quantity * p.price)) AS income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id, TRIM(LOWER(TO_CHAR(s.sale_date, 'Day'))), EXTRACT(ISODOW FROM s.sale_date) ORDER BY EXTRACT(ISODOW FROM s.sale_date) ASC, seller ASC;

-- REPORTE 4: Distribución de clientes agrupados por rangos de edad
SELECT sub.age_category, COUNT(*) AS age_count FROM (SELECT CASE WHEN age BETWEEN 16 AND 25 THEN '16–25' WHEN age BETWEEN 26 AND 40 THEN '26–40' WHEN age > 40 THEN '40+' END AS age_category FROM customers) sub GROUP BY sub.age_category ORDER BY CASE sub.age_category WHEN '16–25' THEN 1 WHEN '26–40' THEN 2 WHEN '40+' THEN 3 END;

-- REPORTE 5: Cantidad de clientes únicos e ingresos generados desglosados por año y mes
SELECT TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month, COUNT(DISTINCT s.customer_id) AS total_customers, FLOOR(SUM(s.quantity * p.price)) AS income FROM sales s JOIN products p ON s.product_id = p.product_id GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM') ORDER BY selling_month ASC;

-- REPORTE 6: Clientes cuya primera compra absoluta en la tienda coincidió con una promoción de precio cero
WITH first_purchases AS (SELECT s.customer_id, TRIM(CONCAT(c.first_name, ' ', c.last_name)) AS customer, TO_CHAR(s.sale_date, 'YYYY-MM-DD') AS sale_date, TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, p.price, ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.sale_date ASC) as rn FROM sales s JOIN customers c ON s.customer_id = c.customer_id JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id) SELECT customer, sale_date, seller FROM first_purchases WHERE rn = 1 AND price = 0 ORDER BY customer_id ASC;
