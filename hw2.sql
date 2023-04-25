CREATE DATABASE hw2;
USE hw2;

-- Задание 1. Используя операторы языка SQL, создайте таблицу «sales». Заполните ее данными. 
CREATE TABLE sales(
	id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    count_product INT NOT NULL
);

INSERT INTO sales(order_date, count_product)
VALUES 
	('2022-01-01', 156),
    ('2022-01-02', 180),
    ('2022-01-03', 21),
    ('2022-01-04', 124),
    ('2022-01-05', 341);

SELECT * FROM sales;

-- Задание 2. Для данных таблицы «sales» укажите тип заказа в зависимости от кол-ва
ALTER TABLE sales
ADD COLUMN 
	type_order VARCHAR(20);

UPDATE sales
SET type_order =
	CASE 
		WHEN count_product < 100 THEN 'Маленький заказ'
		WHEN count_product between 100 AND 300 THEN 'Средний заказ'
		WHEN count_product > 300 THEN 'Большой заказ'
	END;

SELECT 
	id AS 'id заказа',
	type_order AS 'Тип заказа'
FROM sales;

-- Задание 3. Создайте таблицу «orders», заполните ее значениями
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
    employee_id VARCHAR(8) NOT NULL,
    amount DECIMAL(7, 2) NOT NULL,
    order_status VARCHAR(15) NOT NULL
);

INSERT INTO orders(employee_id, amount, order_status)
VALUES
	('e03', 15.00, 'OPEN'),
    ('e01', 25.50, 'OPEN'),
    ('e05', 100.70, 'CLOSED'),
    ('e02', 22.18, 'OPEN'),
    ('e04', 9.50, 'CANCELLED');

SELECT * FROM orders;

-- Выберите все заказы. В зависимости от поля order_status 
-- выведите столбец full_order_status
SELECT id, employee_id, amount, 
	CASE 
		WHEN order_status = 'OPEN' THEN 'Order is in open state'
		WHEN order_status = 'CLOSED' THEN 'Order is closed'
		WHEN order_status = 'CANCELLED' THEN 'Order is cancelled'
	END AS 'full_order_status'	
FROM orders; 

-- Через IF, с учетом того, что статусов может быть больше 3
SELECT id, employee_id, amount, 
	IF(order_status = 'OPEN', 'Order is in open state',
		IF(order_status = 'CLOSED', 'Order is closed', 
			IF(order_status = 'CANCELLED', 'Order is cancelled', order_status)
        )
    ) AS 'full_order_status'	
FROM orders; 
