CREATE DATABASE hw3;
USE hw3;

CREATE TABLE salespeople( -- продавцы
	snum INT UNIQUE PRIMARY KEY NOT NULL,
    sname VARCHAR(20) NOT NULL,
    city VARCHAR(30) NOT NULL
);

INSERT INTO salespeople
VALUES 
	(1001, 'Peel', 'London'), 
    (1002, 'Serres', 'San Jose'), 
    (1004, 'Motika', 'London'), 
    (1007, 'Rifkin', 'Barcelona'), 
    (1003, 'Axelrod', 'New York');
    
CREATE TABLE customers( -- заказчики
	cnum INT UNIQUE PRIMARY KEY NOT NULL,
    cname VARCHAR(20) NOT NULL,
    city VARCHAR(30) NOT NULL, 
    rating INT NOT NULL, 
    snum INT NOT NULL, 
    FOREIGN KEY (snum)
	REFERENCES salespeople(snum)
);

INSERT INTO customers
VALUES 
	(2001, 'Hoffman', 'London', 100, 1001), 
    (2002, 'Giovanni', 'Rome', 200, 1003), 
    (2003, 'Liu', 'San Jose', 200, 1002), 
    (2004, 'Grass', 'Berlin', 300, 1002), 
    (2006, 'Clemens', 'London', 100, 1001), 
    (2008, 'Cisneros', 'San Jose', 300, 1007), 
    (2007, 'Pereira', 'Rome', 100, 1004);

CREATE TABLE orders( -- заказы
	onum INT UNIQUE PRIMARY KEY NOT NULL,
    amt DECIMAL(7, 2) NOT NULL,
    odate DATE NOT NULL, 
    cnum INT NOT NULL, 
    snum INT NOT NULL, 
    FOREIGN KEY (cnum)
	REFERENCES customers(cnum), 
    FOREIGN KEY (snum)
	REFERENCES salespeople(snum)
);

INSERT INTO orders
VALUES 
	(3001, 18.69, '1990-10-03', 2008, 1007), 
    (3003, 767.19, '1990-10-03', 2001, 1001), 
    (3002, 1900.10, '1990-10-03', 2007, 1004), 
    (3005, 5160.45, '1990-10-03', 2003, 1002), 
    (3006, 1098.16, '1990-10-03', 2008, 1007), 
    (3009, 1713.23, '1990-10-04', 2002, 1003), 
    (3007, 75.75, '1990-10-04', 2004, 1002), 
    (3008, 4723.00, '1990-10-05', 2006, 1001), 
    (3010, 1309.95, '1990-10-06', 2004, 1002), 
    (3011, 9891.88, '1990-10-06', 2006, 1001);

/*
1. Напишите запрос, который вывел бы таблицу со столбцами в следующем 
порядке: city, sname, snum. (к первой или второй таблице, используя SELECT)
2. Напишите команду SELECT, которая вывела бы оценку (rating), 
сопровождаемую именем каждого заказчика в городе San Jose. ("заказчики")
3. Напишите запрос, который вывел бы значения snum всех продавцов 
из таблицы заказов без каких бы то ни было повторений. 
(уникальные значения в "snum" "Продавцы")
4. *Напишите запрос, который бы выбирал заказчиков, чьи имена 
начинаются с буквы G. Используется оператор "LIKE": ("заказчики")
5. Напишите запрос, который может дать вам все заказы со значениями 
суммы выше $1,000. ("Заказы", "amt" – сумма)
6. Напишите запрос, который выбрал бы наименьшую сумму заказа. 
(Из поля "amt" – сумма в таблице "Заказы" выбрать наименьшее значение)
7. Напишите запрос к таблице "Заказчики", который может показать 
всех заказчиков, у которых рейтинг больше 100, и они находятся не в Риме.
*/

-- 1 
SELECT city, sname, snum FROM salespeople;

-- 2 
SELECT rating, cname FROM customers WHERE city='San Jose';

-- 3 
SELECT DISTINCT snum FROM orders;

-- 4 
SELECT * FROM customers WHERE cname LIKE 'G%';

-- 5 
SELECT * FROM orders WHERE amt > 1000;

-- 6 
SELECT MIN(amt) FROM orders;
SELECT * FROM orders 
ORDER BY amt 
LIMIT 1;

-- 7 
SELECT * FROM customers 
WHERE rating > 100 AND city != 'Rome';


CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100), -- должность
	seniority INT, -- опыт
	salary INT, 
	age INT
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age) 
VALUES
	('Вася', 'Петров', 'Начальник', '40', 100000, 60),
	('Петр', 'Власов', 'Начальник', '8', 70000, 30),
	('Катя', 'Катина', 'Инженер', '2', 70000, 25),
	('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
	('Иван', 'Иванов', 'Рабочий', '40', 30000, 59),
	('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
	('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
	('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
	('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
	('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
	('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
	('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49);

/*
1. Отсортируйте поле "зарплата" в порядке убывания и возрастания
2. **Отсортируйте по возрастанию поле "Зарплата" и выведите 5 строк 
с наибольшей заработной платой (возможен подзапрос)
3. Выполните группировку всех сотрудников по специальности, 
суммарная зарплата которых превышает 100000
*/

-- 1
SELECT * FROM staff 
ORDER BY salary; -- по возрастанию

SELECT * FROM staff 
ORDER BY salary DESC; -- по убыванию

-- 2 
SELECT * FROM staff 
ORDER BY salary, id DESC 
LIMIT 7, 5;

-- 3 
SELECT post AS Post
FROM staff 
GROUP BY post
HAVING SUM(salary) > 100000;

SELECT 
	post AS 'Специальность', 
    COUNT(*) AS 'Кол-во', 
    GROUP_CONCAT(firstname, ' ', lastname ORDER BY firstname SEPARATOR ', ') AS 'Сотрудники', 
    SUM(salary) AS 'З/п'
FROM staff 
GROUP BY post
HAVING SUM(salary) > 100000 
ORDER BY SUM(salary);

SELECT 
	post AS Post, 
    COUNT(*) AS Count, 
    GROUP_CONCAT(firstname, ' ', lastname ORDER BY firstname SEPARATOR ', ') AS Workers, 
    SUM(salary) AS Salary
FROM staff 
GROUP BY post
HAVING Salary > 100000 
ORDER BY Salary;
