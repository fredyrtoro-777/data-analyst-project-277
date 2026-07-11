-- Esta consulta cuenta el número total de clientes registrados en la tabla customers

SELECT COUNT(*) AS customers_count
FROM customers;

-- REPORTE 1: Los 10 vendedores con mayor facturación total
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, COUNT(s.sales_id) AS operations, FLOOR(SUM(s.quantity * p.price)) AS income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id ORDER BY income DESC LIMIT 10;

-- REPORTE 2: Vendedores con ingresos promedio por venta inferiores al promedio general
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, FLOOR(AVG(s.quantity * p.price)) AS average_income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id HAVING AVG(s.quantity * p.price) < (SELECT AVG(s2.quantity * p2.price) FROM sales s2 JOIN products p2 ON s2.product_id = p2.product_id) ORDER BY average_income ASC;

-- REPORTE 3: Resumen de ingresos acumulados por vendedor según el día de la semana
SELECT TRIM(CONCAT(e.first_name, ' ', e.last_name)) AS seller, TRIM(LOWER(TO_CHAR(s.sale_date, 'Day'))) AS day_of_week, FLOOR(SUM(s.quantity * p.price)) AS income FROM sales s JOIN employees e ON s.sales_person_id = e.employee_id JOIN products p ON s.product_id = p.product_id GROUP BY e.first_name, e.last_name, e.employee_id, TRIM(LOWER(TO_CHAR(s.sale_date, 'Day'))), EXTRACT(ISODOW FROM s.sale_date) ORDER BY EXTRACT(ISODOW FROM s.sale_date) ASC, seller ASC;
