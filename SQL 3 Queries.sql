--Query1
SELECT sum(spend) as total_spend
FROM owner_spend_date


--Query2 -- this is correct the answer key was incorrect, covered in lab
SELECT card_no,
max(spend) as spend
FROM owner_spend_date
WHERE strftime('%Y', date) = '2017'
AND card_no != 3
GROUP BY card_no
HAVING sum(spend) > 10000
ORDER BY spend DESC


--Query 3
SELECT *
FROM department_date
WHERE 5000 < spend 
AND 7500 > spend
AND department != 1
AND department != 2
AND(strftime('%m', date) = '05'
	OR strftime('%m', date) = '06'
	OR strftime('%m', date) = '07'
	OR strftime('%m', date) = '08')
ORDER BY spend DESC


--Query 4
--Find the 4 months with the highest spend

WITH cte_month AS(
SELECT strftime('%m', date) as month,
strftime('%Y', date) as year,
sum(spend) as total_store_spend
FROM date_hour
GROUP BY month,year
ORDER BY total_store_spend DESC
Limit 4),

dept_spend AS(
SELECT strftime('%m', date) as month,
strftime('%Y', date) as year,
department,
sum(spend) as department_spend
FROM department_date
GROUP BY department, month, year
)

SELECT 
cte_month.*,
ds.department,
ds.department_spend
FROM dept_spend as ds
INNER JOIN  cte_month on cte_month.month = ds.month
AND cte_month.year = ds.year
WHERE department_spend >200000
ORDER by year,month ASC, department_spend DESC


--Query 5 --Worked on in lab slighlty different than John's but he said it was good!
SELECT
owners.zip,
count(owners.card_no) as number_of_owners,
sum(osp.spend) / count(distinct owners.card_no) AS avg_spend_per_owner,
sum(osp.spend) / sum(osp.trans) AS avg_trans_spend
FROM owners
INNER JOIN owner_spend_date as osp on osp.card_no = owners.card_no
GROUP by owners.zip
HAVING count( DISTINCT owners.card_no) >100
ORDER BY avg_trans_spend DESC
LIMIT 5


--Query 6 results will be slightly different due to 5's variability
-- but 5 was approved and 6 is only changing the order of 5. So should
-- be all correct as well.

SELECT
owners.zip,
count(owners.card_no) as number_of_owners,
sum(osp.spend) / count(distinct owners.card_no) AS avg_spend_per_owner,
sum(osp.spend) / sum(osp.trans) AS avg_trans_spend
FROM owners
INNER JOIN owner_spend_date as osp on osp.card_no = owners.card_no
GROUP by owners.zip
HAVING count( DISTINCT owners.card_no) >100
ORDER BY avg_trans_spend ASC
LIMIT 5



--Query 7 make the sum case cte's
WITH cte_sum_case as(
SELECT zip, 
sum(CASE WHEN status = 'INACTIVE' or 'Inactive' THEN 1 ELSE 0 END) AS inactive_users,
sum(CASE WHEN status = 'ACTIVE' or 'Active' THEN 1 ELSE 0 END) AS active_users
FROM owners
GROUP BY zip
HAVING count(card_no) >= 50)

SELECT 
owners.zip,
csc.active_users,
csc.inactive_users,
sum(CAST(csc.active_users as REAL))/count(distinct owners.card_no) as fraction_active
from owners
JOIN cte_sum_case as csc on csc.zip = owners.zip
GROUP BY owners.zip



--Query 10

SELECT description,
dept_name,
sum(spend) as total_spend
FROM owner_products
WHERE dept_name = "REF GROCERY"
OR dept_name = "PACKAGED GROCERY"
GROUP BY description
ORDER BY total_spend DESC
LIMIT 10

















