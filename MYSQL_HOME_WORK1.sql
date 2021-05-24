SELECT * FROM `dec-2020`.students;
-- 1) найти всех студентов
SELECT * FROM `dec-2020`.students;
-- 2)найти всех женщин
SELECT * FROM students WHERE gender = 'FEMALE';
-- 3)найти всех мужчин в возрасте от 25 до 40
SELECT * FROM students WHERE age BETWEEN 25 AND 40;
-- 4)найти всех женщин старше 30 и у которых в имени вторая и последняя буква "а"
SELECT * FROM students WHERE age > 30 AND gender = 'FEMALE' AND name LIKE '_a%a';
-- 5) найти среднее арифметическое возрастов всех мужчин
SELECT AVG(age) AS AvgAge FROM students WHERE gender = 'MALE';
-- 6)найти самую старую студентку
SELECT MAX(age), name FROM students WHERE gender = 'FEMALE';
-- 7)выбрать 3 последние записки в БД
SELECT * FROM students LIMIT 3 OFFSET 8; 
-- 8)посчитать количество мужчин и женщин
SELECT COUNT(gender) AS count, gender FROM students GROUP BY gender;
SELECT * FROM students;
-- 9)всем мужчинам у которых имя начинается на "а" поменять пол на женский  (чомусь поміняло всім мужика стать..??)
  SET SQL_SAFE_UPDATES = 0;
  UPDATE students SET gender = 'female' WHERE name LIKE 'a%' OR gender LIKE 'm%'; 
  SELECT * FROM students;
-- 10)Антона переименовать в Антонину (не працює)
SET SQL_SAFE_UPDATES = 0;
UPDATE students SET name = 'Антонина' WHERE name = 'Антон'; 
-- 11) установить возраст девушек в 10 лет у кого имя не заканчивается на "А"  
SET SQL_SAFE_UPDATES = 0;
UPDATE students SET age = 10 WHERE name NOT LIKE '%a';
select * FROM students;
-- 12) удалить всех кто не входит в возрастную группу 25-40
DELETE FROM students where age BETWEEN 25 AND 40;