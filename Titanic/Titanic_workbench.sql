create database titanic_project;
use titanic_project;
create table titanic_raw (
    PassengerId int,
    Survived int,
    Pclass int,
    Name Text,
    Sex Text,
    Age Text,
    Sibsp int,
    Parch int,
    Ticket Text,
    Fare Text,
    Cabin Text,
    Embarked Text
);
CREATE TABLE titanic AS
SELECT *
FROM titanic_raw;

show tables;
select * 
from titanic;

# Data Cleaning

select count(*) 
from titanic;

describe titanic;

# missing check 

SELECT 
COUNT(*) AS total_rows,
COUNT(CASE WHEN PassengerId IS NULL OR TRIM(PassengerId) = '' THEN 1 END) AS missing_PassengerId,
COUNT(CASE WHEN Survived IS NULL OR TRIM(Survived) = '' THEN 1 END) AS missing_Survived, 
COUNT(CASE WHEN Pclass IS NULL OR TRIM(Pclass) = '' THEN 1 END) AS missing_Pclass, 
COUNT(CASE WHEN Name IS NULL OR TRIM(Name) = '' THEN 1 END) AS missing_Name, 
COUNT(CASE WHEN Sex IS NULL OR TRIM(Sex) = '' THEN 1 END) AS missing_Sex, 
COUNT(CASE WHEN Age IS NULL OR TRIM(Age) = '' THEN 1 END) AS missing_age, 
COUNT(CASE WHEN Sibsp IS NULL OR TRIM(Sibsp) = '' THEN 1 END) AS missing_Sibsp, 
COUNT(CASE WHEN Parch IS NULL OR TRIM(Parch) = '' THEN 1 END) AS missing_Parch, 
COUNT(CASE WHEN Ticket IS NULL OR TRIM(Ticket) = '' THEN 1 END) AS missing_Ticket, 
COUNT(CASE WHEN Fare IS NULL OR TRIM(Fare) = '' THEN 1 END) AS missing_Fare, 
COUNT(CASE WHEN Cabin IS NULL OR TRIM(Cabin) = '' THEN 1 END) AS missing_cabin, 
COUNT(CASE WHEN Embarked IS NULL OR TRIM(Embarked) = '' THEN 1 END) AS missing_embarked
FROM titanic;

# clean text column
UPDATE titanic
SET 
Name = TRIM(Name),
Sex = TRIM(Sex),
Cabin = TRIM(Cabin),
Embarked = TRIM(Embarked),
Ticket = TRIM(Ticket);

# empty value --> null
update titanic
set Age = null
where trim(Age) = '';

update titanic
set Fare = null
where trim(Fare) = '';

update titanic
set Cabin = null
where trim(Cabin) = '';

update titanic
set Embarked = null
where trim(Embarked) = '';

# validation using regexp

select * 
from titanic
where Age is not null
and Age not regexp '^[0-9]+(\.[0-9]+)?$';

select * 
from titanic
where Fare is not null
and Fare not regexp '^[0-9]+(\.[0-9]+)?$';

# categorical values

SELECT DISTINCT Sex FROM titanic;
SELECT DISTINCT Embarked FROM titanic;
SELECT DISTINCT Pclass FROM titanic;
SELECT DISTINCT Survived FROM titanic;

# fixing datatype

alter table titanic
modify Name Varchar(255),
modify sex varchar(15),
modify Age float,
modify Ticket varchar(50),
modify Fare float,
modify Cabin varchar(50),
modify Embarked varchar(15);

# missing values imputation
# age

 SELECT AVG(Age) AS avg_age
FROM titanic;

UPDATE titanic
SET Age = (
    SELECT avg_age FROM (
        SELECT AVG(Age) AS avg_age FROM titanic
    ) AS temp
)
WHERE Age IS NULL;

# embarked

SELECT Embarked, COUNT(*) AS frequency
FROM titanic
WHERE Embarked IS NOT NULL
GROUP BY Embarked
ORDER BY frequency DESC;

UPDATE titanic
SET Embarked = (
    SELECT mode_value FROM (
        SELECT Embarked AS mode_value
        FROM titanic
        WHERE Embarked IS NOT NULL
        GROUP BY Embarked
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS temp
)
WHERE Embarked IS NULL;


#outlier

SELECT *
FROM titanic
WHERE Age > (SELECT AVG(Age) + 3 * STDDEV(Age) FROM titanic)
   OR Age < (SELECT AVG(Age) - 3 * STDDEV(Age) FROM titanic);
   
SELECT *
FROM titanic
WHERE Fare > (SELECT AVG(Fare) + 3 * STDDEV(Fare) FROM titanic)
   OR Fare < (SELECT AVG(Fare) - 3 * STDDEV(Fare) FROM titanic);
   
# feature engineering

SELECT *,
CASE
    WHEN Age < 18 THEN 'Child'
    WHEN Age BETWEEN 18 AND 60 THEN 'Adult'
    ELSE 'Senior'
END AS Age_Group
FROM titanic;

SELECT *,
(SibSp + Parch + 1) AS Family_Size
FROM titanic;

SELECT *,
CASE
    WHEN Fare < 50 THEN 'Low'
    WHEN Fare BETWEEN 50 AND 150 THEN 'Medium'
    ELSE 'High'
END AS Fare_Category
FROM titanic;

ALTER TABLE titanic
ADD Age_Group VARCHAR(20);
select * from titanic;

UPDATE titanic
SET Age_Group =
CASE
    WHEN Age < 12 THEN 'Child'
    WHEN Age BETWEEN 12 AND 17 THEN 'Teenager'
    WHEN Age BETWEEN 18 AND 50 THEN 'Adult'
    ELSE 'Senior'
END;

ALTER TABLE titanic
ADD Family_Size INT;

UPDATE titanic
SET Family_Size = SibSp + Parch + 1;

ALTER TABLE titanic
ADD COLUMN Family_Group VARCHAR(20);

UPDATE titanic
SET Family_Group =
CASE
    WHEN Family_Size = 1 THEN 'Alone'
    WHEN Family_Size BETWEEN 2 AND 4 THEN 'Small Family'
    WHEN Family_Size BETWEEN 5 AND 7 THEN 'Medium Family'
    ELSE 'Large Family'
END;

ALTER TABLE titanic
ADD Fare_Category VARCHAR(20);

UPDATE titanic
SET Fare_Category =
CASE
    WHEN Fare < 50 THEN 'Low'
    WHEN Fare BETWEEN 50 AND 150 THEN 'Medium'
    ELSE 'High'
END;

# deleting unwanted columns

ALTER TABLE titanic
DROP COLUMN Name,
DROP COLUMN Sibsp,
DROP COLUMN Parch,
DROP COLUMN Ticket,
DROP COLUMN Fare,
DROP COLUMN Cabin;

select * from titanic;

# Exploratory Data Analysis (EDA)

# How many passengers were on the Titanic?

select count(*) as Total_Passegers
from titanic;

# What was the overall survival rate?

select round(avg(Survived)*100,2) as survival_rate
from titanic;

# Who had a better chance of survival: men or women?

select Sex, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Sex
order by survival_rate desc;

# Did passenger class influence survival?

select Pclass, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Pclass
order by survival_rate desc;

# Which age group was most likely to survive?

select Age_Group, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Age_Group
order by survival_rate desc;

# Were wealthy passengers more likely to survive?

select Fare_Category, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Fare_Category
order by survival_rate desc;

# Did traveling alone affect survival chances?

select Family_Group, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Family_Group
order by survival_rate desc;

# Did embarkation port influence survival outcomes?

select Embarked, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Embarked
order by survival_rate desc;

# How did survival differ between males and females within each class

select Sex,Pclass, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Sex,Pclass
order by survival_rate desc;

# How did survival differ between age groups within each class?

select Age_Group,Pclass, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Age_Group,Pclass
order by survival_rate desc;

# Was gender or passenger class the stronger factor in survival?

select Sex,Pclass, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Sex,Pclass
order by survival_rate desc;

# Which combination of Gender, Class, and Age Group was the riskiest?

select Sex,Pclass,Age_Group, round(avg(Survived)*100,2) as survival_rate
from titanic
group by Sex,Pclass,Age_Group
order by survival_rate asc
limit 1;
