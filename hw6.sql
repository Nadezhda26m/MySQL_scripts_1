DROP DATABASE IF EXISTS hw6;
CREATE DATABASE hw6;
USE hw6;

/*
1. Создайте функцию, которая принимает кол-во сек и форматирует их 
в кол-во дней, часов, минут и секунд.
Пример: 123456 -> '1 days 10 hours 17 minutes 36 seconds'
*/

-- DROP FUNCTION time_sec;
DELIMITER $$
CREATE FUNCTION time_sec(n INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE res VARCHAR(50) DEFAULT '0 seconds'; 
    DECLARE part_time INT;
    DECLARE step INT DEFAULT 1;
    WHILE n > 0 DO 
		CASE
			WHEN step = 1 THEN
                SET part_time = MOD(n, 60);
                SET res = CONCAT(part_time, ' seconds');
                SET n = CEILING((n - part_time) / 60);
			WHEN step = 2 THEN
                SET part_time = MOD(n, 60);
                SET res = CONCAT(part_time, ' minutes', ' ', res);
                SET n = CEILING((n - part_time) / 60);
			WHEN step = 3 THEN
                SET part_time = MOD(n, 24);
                SET res = CONCAT(part_time, ' hours', ' ', res);
                SET n = CEILING((n - part_time) / 24);
			ELSE
                IF MOD(n, 0) != 0 THEN RETURN 'Ошибка';
                END IF;
                RETURN CONCAT(ROUND(n, 0), ' days', ' ', res);
		END CASE;
		SET step = step + 1;
    END WHILE;
    IF n < 0 THEN RETURN 'Неверные данные';
    ELSE RETURN res;
    END IF;
END $$
DELIMITER ; 

SELECT time_sec(215446) AS 'Result';

/*
2. Выведите только четные числа от 1 до 10 включительно.
Пример: 2,4,6,8,10 (можно сделать через шаг + 2: х = 2, х+=2)
*/

-- DROP FUNCTION even_nums;
DELIMITER //
CREATE FUNCTION even_nums(maxN INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
	DECLARE n INT DEFAULT 2;
    DECLARE res VARCHAR(50) DEFAULT '2'; 
    IF maxN < 2 THEN RETURN 'Введите число больше 1';
    END IF;
    SET n = n + 2;
    WHILE n <= maxN DO
		SET res = CONCAT(res, ', ', n);
		SET n = n + 2;
	END WHILE;
RETURN res;
END //
DELIMITER ;

SELECT even_nums(10);
SELECT even_nums(1);


-- DROP PROCEDURE even_nums_proc;
DELIMITER $$
CREATE PROCEDURE even_nums_proc(maxN INT)
BEGIN
    DECLARE n INT DEFAULT 2;
    DECLARE res VARCHAR(50) DEFAULT '2'; 
    IF maxN < 2 THEN SELECT 'Введите число больше 1' AS 'No Result';
    ELSE
		SET n = n + 2;
		WHILE n <= maxN DO
			SET res = CONCAT(res, ', ', n);
			SET n = n + 2;
		END WHILE;
		SELECT res AS 'Result';
    END IF;
END $$
DELIMITER ; 
CALL even_nums_proc(10);
CALL even_nums_proc(-3);
