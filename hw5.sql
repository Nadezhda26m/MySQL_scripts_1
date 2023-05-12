DROP DATABASE IF EXISTS hw5;
CREATE DATABASE hw5;
USE hw5;

# Задание 1

CREATE TABLE Cars (
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Name VARCHAR(30) NOT NULL,
    Cost INT NOT NULL
);

INSERT INTO Cars(Name, Cost) VALUES
	('Audi', 52642),
    ('Mercedes', 57127),
    ('Skoda', 9000),
    ('Volvo', 29000),
    ('Bentley', 350000),
    ('Citroen', 21000),
    ('Hummer', 41400),
    ('Volkswagen', 21600);
    
-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
CREATE OR REPLACE VIEW lowcost AS
	SELECT * FROM Cars
	WHERE Cost < 25000;

SELECT * FROM lowcost;

-- 2. Изменить в существующем представлении порог для стоимости: 
-- пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW lowcost AS
	SELECT * FROM Cars
	WHERE Cost < 30000;

SELECT * FROM lowcost;

-- 3. Создайте представление, в котором будут только автомобили марки "Шкода" и "Ауди"
CREATE OR REPLACE VIEW Skoda_Audi AS
	SELECT * FROM Cars
	WHERE Name IN ('Audi', 'Skoda');

SELECT * FROM Skoda_Audi;

# Задание 2

CREATE TABLE `Groups` (
	gr_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    gr_name VARCHAR(50) NOT NULL,
    gr_temp VARCHAR(10) NOT NULL -- температурный режим хранения
);

CREATE TABLE Analysis (
	an_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    an_name VARCHAR(50) NOT NULL, 
    an_cost DECIMAL(8, 2) NOT NULL, -- себестоимость анализа
    an_price DECIMAL(8, 2) NOT NULL, -- розничная цена анализа
    an_group INT NOT NULL, -- группа анализов
    FOREIGN KEY (an_group) REFERENCES `Groups`(gr_id) ON DELETE CASCADE
);

CREATE TABLE Orders (
	ord_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    ord_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- дата и время заказа
    ord_an INT NOT NULL, -- ID анализа
    FOREIGN KEY (ord_an) REFERENCES Analysis(an_id)
);

INSERT INTO `Groups`(gr_name, gr_temp) VALUES
	('Group1', '0..+4'),
    ('Group2', '+6..+25'),
    ('Group3', '+4..+18'),
    ('Group4', '0..+25');

INSERT INTO Analysis(an_name, an_cost, an_price, an_group) VALUES
	('AnName1', 234.00, 500.00, 2),
    ('AnName2', 18.00, 150.00, 1),
    ('AnName3', 1200.00, 2800.00, 2),
    ('AnName4', 170.50, 800.00, 2),
    ('AnName5', 346.00, 900.00, 3),
    ('AnName6', 104.00, 420.00, 1),
    ('AnName7', 70.00, 290.00, 4);

INSERT INTO Orders(ord_datetime, ord_an) VALUES
	('2019-12-18 10:51', 6),
    ('2020-02-16 17:24', 7),
    ('2020-02-02 14:33', 4),
    ('2020-02-12 17:54', 3),
    ('2020-02-05 18:19', 4),
    ('2020-02-15 15:56', 2),
    ('2020-02-16 14:27', 1),
    ('2020-02-18 16:48', 7),
    ('2020-01-18 11:19', 2),
    ('2020-02-05 10:05', 3),
    ('2020-02-25 14:23', 5);

-- Вывести название и цену для всех анализов, которые продавались 
-- 5 февраля 2020 и всю следующую неделю.

WITH cte AS
(
	SELECT * FROM Analysis a
	INNER JOIN Orders o
	ON a.an_id = o.ord_an
	WHERE o.ord_datetime BETWEEN '2020-02-05' AND '2020-02-05 23:59:59' 
		OR o.ord_datetime BETWEEN '2020-02-10' AND '2020-02-16 23:59:59'
	ORDER BY o.ord_datetime
)
SELECT an_name, an_price FROM cte;

-- Добавьте новый столбец под названием «время до следующей станции». 

CREATE TABLE Trains (
	train_id INT NOT NULL,
    station VARCHAR(20) NOT NULL,
    station_time TIME NOT NULL
);

INSERT INTO Trains VALUES
    (120, 'San Francisco', '11:00'),
    (110, 'Redwood City', '10:54'),
    (110, 'San Jose', '12:35'),
    (110, 'Palo Alto', '11:02'),
    (120, 'Palo Alto', '12:49'),
	(110, 'San Francisco', '10:00'),
    (120, 'San Jose', '13:30');

SELECT *, 
	TIME_FORMAT(
		TIMEDIFF(
			LEAD(station_time) OVER(PARTITION BY train_id ORDER BY station_time), 
			station_time
		), '%H:%i:%s'
	) AS time_to_next_station
FROM Trains;
