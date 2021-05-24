SELECT * FROM bank.application;
-- Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE length(firstName) < 6; 
-- Вибрати львівські відділення банку
SELECT * FROM department WHERE DepartmentCity = 'Lviv';
-- Вибрати клієнтів з вищою освітою та  посортувати по прізвищу.
SELECT * FROM client WHERE Education = 'high' ORDER BY LastName;
-- Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC limit 5;
-- Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA
SELECT * FROM client WHERE LastName LIKE '%ova';
-- Вивести клієнтів банку, які обслуговуються київськими відділеннями
SELECT 
CONCAT(c.FirstName, ' ', c.LastName) AS Client,
d.DepartmentCity  
FROM department d LEFT 
JOIN client c ON c.Department_idDepartment = d.idDepartment 
WHERE d.DepartmentCity = 'Kyiv';

-- Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами (телефонів нема, вивожу паспорта )
SELECT
c.FirstName AS Name,
c.Passport
FROM client c
GROUP BY FirstName;

-- Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень
SELECT 
c.FirstName,
c.LastName,
c.Education,
c.Passport,
c.City,
c.Age,
a.sum,
a.Currency 
FROM application a LEFT 
JOIN client c ON c.idClient = a.Client_idClient 
WHERE a.Currency = 'Gryvnia' AND a.Sum > 5000;

-- Порахувати кількість клієнтів усіх відділень та лише львівських відділень
SELECT 
COUNT(*) AS ClientCount,
d.DepartmentCity  
FROM department d LEFT 
JOIN client c ON c.Department_idDepartment = d.idDepartment 
WHERE d.DepartmentCity = 'Kyiv';

-- Знайти кредити, які мають найбільшу суму для кожного клієнта окремо
SELECT 
MAX(SUM),
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM application a LEFT
JOIN client c ON c.idClient = a.Client_idClient
GROUP BY c.LastName;

-- Визначити кількість заявок на крдеит для кожного клієнта
SELECT
COUNT(*) AS ApplicationCount,
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM application a LEFT
JOIN client c ON c.idClient = a.Client_idClient
GROUP BY c.LastName;

-- Визначити найбільший та найменший кредити
SELECT
MAX(Sum) AS Max_Credit_Sum 
FROM application;

SELECT
MIN(Sum) AS Min_Credit_Sum 
FROM application;

-- Порахувати кількість кредитів для клієнтів,які мають вищу освіту
SELECT
COUNT(*) AS CreditCount,
c.Education
FROM client a LEFT
JOIN client c ON c.idClient = a.Client_idClient
WHERE Education = 'high';

-- Вивести дані про клієнта, в якого середня сума кредитів найвища
SELECT
AVG(a.sum),
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM application a LEFT
JOIN client c ON c.idClient = a.Client_idClient
GROUP BY c.FirstName
ORDER BY AVG(a.sum)
DESC limit 1;

-- Вивести відділення, яке видало в кредити найбільше грошей
SELECT
SUM(a.sum),
d.DepartmentCity
FROM department d LEFT
JOIN client c ON c.Department_idDepartment = d.idDepartment
JOIN application a ON a.Client_idClient = c.idClient  
GROUP BY d.DepartmentCity
ORDER BY SUM(a.sum)
DESC limit 1;

-- Вивести відділення, яке видало найбільший кредит
 SELECT
MAX(a.sum),
d.DepartmentCity
FROM department d LEFT
JOIN client c ON c.Department_idDepartment = d.idDepartment
JOIN application a ON a.Client_idClient = c.idClient  
GROUP BY d.DepartmentCity
ORDER BY SUM(a.sum)
DESC limit 1;


-- Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE 
client c
JOIN application a ON c.idClient = a.Client_idClient
 SET Sum = 6000 
 WHERE Education = 'high';
 
-- Усіх клієнтів київських відділень пересилити до Києва
UPDATE 
department d
JOIN client c ON c.Department_idDepartment = d.idDepartment
 SET City = 'Kyiv' 
 WHERE DepartmentCity = 'Kyiv';
 
 -- Видалити усі кредити, які є повернені  ?? Не працює!!
 DELETE 
 FROM application 
 WHERE CreditState = 'Returned';
 
 -- Видалити кредити клієнтів, в яких друга літера прізвища є голосною
 
 DELETE 
 FROM application 
 WHERE Client_idClient 
 IN (SELECT idClient FROM client WHERE LastName LIKE '_a%'
       OR LastName LIKE '_e%'
       OR LastName LIKE '_o%'
       OR LastName LIKE '_y%'
       OR LastName LIKE '_i%'
       OR LastName LIKE '_u%');
 
 -- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
 
SELECT
a.sum,
d.idDepartment AS Dep
FROM department d LEFT
JOIN client c ON c.Department_idDepartment = d.idDepartment
JOIN application a ON a.Client_idClient = c.idClient 
WHERE DepartmentCity = 'Lviv' AND a.sum > 5000; 

-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT
a.sum,
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM client c LEFT
JOIN department d ON c.Department_idDepartment = d.idDepartment
JOIN application a ON a.Client_idClient = c.idClient 
WHERE CreditState = 'Returned' AND a.sum > 5000; 

-- /* Знайти максимальний неповернений кредит.*/

SELECT
a.sum,
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM application a LEFT
JOIN client c ON c.idClient = a.Client_idClient
WHERE CreditState = 'Not returned'
ORDER BY a.sum
DESC limit 1;

-- /*Знайти клієнта, сума кредиту якого найменша*/
SELECT
a.sum,
CONCAT(c.FirstName, ' ', c.LastName) AS Client
FROM application a LEFT
JOIN client c ON c.idClient = a.Client_idClient
ORDER BY a.sum
limit 1;

-- /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/  

SELECT idApplication, CreditState, Sum, Currency
FROM application
WHERE Sum > (SELECT AVG(Sum) FROM application);


-- /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/ ?? Хз, не виходить
SELECT DISTINCT idClient, LastName, FirstName, Passport
FROM client c
         JOIN application a ON a.Client_idClient = c.idClient
WHERE c.City = (SELECT City
                FROM client c2
                         JOIN application a2 ON a2.Client_idClient = c2.idClient
                GROUP BY idClient
                ORDER BY COUNT(a2.Client_idClient) DESC
                LIMIT 1);


-- #місто чувака який набрав найбільше кредитів
SELECT
SUM(a.sum) AS Most_loans ,
c.City AS City,
CONCAT(c.FirstName, ' ', c.LastName) AS ChuvakName
FROM client c LEFT
JOIN application a ON c.idClient = a.Client_idClient
GROUP BY CONCAT(c.FirstName, ' ', c.LastName)
ORDER BY SUM(a.sum)
DESC limit 1;
