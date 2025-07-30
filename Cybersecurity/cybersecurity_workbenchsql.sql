create database Project;
use Project;
show tables;
select * from cyber_threats;

#1) List all unique countries impacted by cyber threats:
SELECT DISTINCT Country FROM cyber_threats;

#2) Total financial loss globally due to cyber threats:
SELECT SUM(`Financial Loss (in Million $)`) AS Total_Loss FROM cyber_threats;

#3) Number of cyber attacks recorded each year (ascending)
SELECT Year, COUNT(*) AS Attack_Count FROM cyber_threats GROUP BY Year ORDER BY Year;

#4) Number of unique attack types in 2023:
SELECT COUNT(DISTINCT `Attack Type`) AS Attack_Types_2023 FROM cyber_threats WHERE Year = 2023;

#5) List all records where number of affected users > 1 million:
SELECT * FROM cyber_threats WHERE 'Number of Affected Users' > 1000000;

#6) Show the first year a cyber incident was recorded:
SELECT MIN(Year) AS First_Incident_Year FROM cyber_threats;

#7) Country with the highest number of affected users in 2024:
SELECT Country, SUM(`Number of Affected Users`) AS Total_Affected 
FROM cyber_threats 
WHERE Year = 2024 
GROUP BY Country 
ORDER BY Total_Affected DESC 
LIMIT 1;

#8) Total financial loss by each attack type:
SELECT `Attack Type`, SUM(`Financial Loss (in Million $)`) AS Total_Loss 
FROM cyber_threats 
GROUP BY `Attack Type` 
ORDER BY Total_Loss DESC;

#9) Average financial loss per year for the India:
SELECT Year, AVG(`Financial Loss (in Million $)`) AS Avg_Loss 
FROM cyber_threats 
WHERE Country = 'India' 
GROUP BY Year;

#10) Year with the highest total financial loss:
SELECT Year, SUM(`Financial Loss (in Million $)`) AS Total_Loss 
FROM cyber_threats 
GROUP BY Year 
ORDER BY Total_Loss DESC 
LIMIT 1;

#11) Total affected users between “Phishing” and “Ransomware” attack types:
SELECT `Attack Type`, SUM(`Number of Affected Users`) AS Total_Affected 
FROM cyber_threats 
WHERE `Attack Type` IN ('Phishing', 'Ransomware') 
GROUP BY `Attack Type`;

#12) Target industries with more than 10 million affected users:
SELECT `Target Industry`, SUM(`Number of Affected Users`) AS Total_Users 
FROM cyber_threats 
GROUP BY `Target Industry` 
HAVING Total_Users > 10000000;

#13) Countries with total financial loss > $500 million:
SELECT Country, SUM(`Financial Loss (in Million $)`) AS Total_Loss 
FROM cyber_threats 
GROUP BY Country 
HAVING Total_Loss > 500;

#14) Show all records where attack type is ‘Ransomware’ and loss > $100 million:
SELECT * FROM cyber_threats 
WHERE `Attack Type` = 'Ransomware' AND `Financial Loss (in Million $)` > 100;

#15) All cyber incidents from India between 2020 and 2023:
SELECT * FROM cyber_threats 
WHERE Country = 'India' AND Year BETWEEN 2020 AND 2023;

#16) Top 5 countries by number of affected users in 2022:
SELECT Country, SUM(`Number of Affected Users`) AS Total_Affected 
FROM cyber_threats 
WHERE Year = 2022 
GROUP BY Country 
ORDER BY Total_Affected DESC 
LIMIT 5;

#17) Year-wise trend of incidents caused by ‘Social Engineering’:
SELECT Year, COUNT(*) AS Incident_Count 
FROM cyber_threats 
WHERE `Security Vulnerability Type` = 'Social Engineering' 
GROUP BY Year 
ORDER BY Year;

#18) Top 10 countries by total number of cyber incidents:
SELECT Country, COUNT(*) AS Total_Incidents 
FROM cyber_threats 
GROUP BY Country 
ORDER BY Total_Incidents DESC 
LIMIT 10;

#19) Most frequently used defense mechanism:
SELECT `Defense Mechanism Used`, COUNT(*) AS Usage_Count 
FROM cyber_threats 
GROUP BY `Defense Mechanism Used` 
ORDER BY Usage_Count DESC 
LIMIT 1;

#20) Average resolution time by attack type:
SELECT `Attack Type`, AVG(`Incident Resolution Time (in Hours)`) AS Avg_Resolution_Hours 
FROM cyber_threats 
GROUP BY `Attack Type`;

#21) Top 10 most common vulnerability type by industry:
SELECT `Target Industry`, `Security Vulnerability Type`, COUNT(*) AS Count 
FROM cyber_threats 
GROUP BY `Target Industry`, `Security Vulnerability Type` 
ORDER BY Count DESC
LIMIT 10;
