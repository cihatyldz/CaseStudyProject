-- 1) Create Table
DROP TABLE IF EXISTS ProjectActivity;
CREATE TABLE ProjectActivity (
  ProjectID INT NOT NULL,
  "Date"    DATE NOT NULL
);

-- 2) 50 row sample
INSERT INTO ProjectActivity (ProjectID, "Date")
SELECT * FROM (
  SELECT 1 AS ProjectID, d::date AS "Date"
  FROM generate_series(DATE '2025-08-01', DATE '2025-08-03', INTERVAL '1 day') AS g(d)
  UNION ALL SELECT 2,  DATE '2025-08-01'
  UNION ALL SELECT 3,  DATE '2025-08-01'
  UNION ALL SELECT 3,  DATE '2025-08-08'
  UNION ALL SELECT 4,  DATE '2025-08-01'
  UNION ALL SELECT 4,  DATE '2025-08-10'
  UNION ALL SELECT 5,  DATE '2025-08-01'
  UNION ALL SELECT 5,  DATE '2025-08-02'
  UNION ALL SELECT 6,  DATE '2025-08-01'
  UNION ALL SELECT 6,  DATE '2025-08-02'
  UNION ALL SELECT 6,  DATE '2025-08-08'
  UNION ALL SELECT 7,  DATE '2025-08-01'
  UNION ALL SELECT 8,  DATE '2025-08-01'
  UNION ALL SELECT 8,  DATE '2025-08-08'
  UNION ALL SELECT 9,  DATE '2025-08-01'
  UNION ALL SELECT 9,  DATE '2025-08-06'
  UNION ALL SELECT 10, DATE '2025-08-01'
  UNION ALL SELECT 10, DATE '2025-08-12'
  UNION ALL SELECT 11, DATE '2025-08-02'
  UNION ALL SELECT 12, DATE '2025-08-02'
  UNION ALL SELECT 12, DATE '2025-08-09'
  UNION ALL SELECT 13, DATE '2025-08-02'
  UNION ALL SELECT 13, DATE '2025-08-03'
  UNION ALL SELECT 13, DATE '2025-08-04'
  UNION ALL SELECT 14, DATE '2025-08-02'
  UNION ALL SELECT 14, DATE '2025-08-03'
  UNION ALL SELECT 15, DATE '2025-08-02'
  UNION ALL SELECT 15, DATE '2025-08-20'
  UNION ALL
  SELECT 16, d::date
  FROM generate_series(DATE '2025-08-03', DATE '2025-08-05', INTERVAL '1 day') AS g(d)
  UNION ALL SELECT 17, DATE '2025-08-03'
  UNION ALL SELECT 18, DATE '2025-08-03'
  UNION ALL SELECT 18, DATE '2025-08-10'
  UNION ALL SELECT 19, DATE '2025-08-03'
  UNION ALL SELECT 19, DATE '2025-08-04'
  UNION ALL SELECT 20, DATE '2025-08-03'
  UNION ALL SELECT 20, DATE '2025-08-06'
  UNION ALL SELECT 20, DATE '2025-08-11'
  UNION ALL SELECT 21, DATE '2025-08-04'
  UNION ALL
  SELECT 22, d::date
  FROM generate_series(DATE '2025-08-04', DATE '2025-08-06', INTERVAL '1 day') AS g(d)
  UNION ALL SELECT 23, DATE '2025-08-04'
  UNION ALL SELECT 23, DATE '2025-08-12'
  UNION ALL SELECT 24, DATE '2025-08-05'
  UNION ALL SELECT 25, DATE '2025-08-05'
  UNION ALL SELECT 25, DATE '2025-08-06'
) s;

-- 3) Check Control
SELECT COUNT(*) AS rows_loaded FROM ProjectActivity;    
SELECT * FROM ProjectActivity ORDER BY "Date", ProjectID; 





/*1.Create SQL-query that calculates for each row how many consecutive days by this time each project was updated. 
First update we assume as 1 day in row.*/


WITH act AS (
  SELECT 
        ProjectID, 
		"Date" AS dt
  FROM ProjectActivity
  GROUP BY projectid, "Date"
),
behind AS (
  SELECT
    projectid, dt,
    LAG(dt) OVER (PARTITION BY projectid ORDER BY dt) AS prev_dt
  FROM act
),
signs AS (
  SELECT
    projectid, dt,
    CASE 
	    WHEN prev_dt = dt - INTERVAL '1 day' THEN 0 
	    ELSE 1 
    END AS new_island
  FROM behind
),
islands AS (
  SELECT
    projectid, dt,
    SUM(new_island) OVER (PARTITION BY projectid ORDER BY dt) AS island_id
  FROM signs
)
SELECT
  dt        AS "Date",
  projectid AS "ProjectID",
  ROW_NUMBER() OVER (PARTITION BY projectid, island_id ORDER BY dt) AS "DaysInRow"
FROM islands
ORDER BY "Date", "ProjectID";



/*
2.Using data in table ProjectActivity create SQL-query that calculates metric “Abandoned 7” for each Date in table.
Metric “Abandoned 7” defines percentage of projects (of overall modifications by day) which were updated this day but were not updated after 7 
and more days.
Example:
At 2016-10-01 were updated Project 1 and Project 2. Project 1 has been updated next day and so on, Project 2 has not been modified anymore.
“Abandoned 7” for date 2016-10-01 will be: count of abandoned projects / count of projects modified at 2016-10-01 * 100 % = 1 / 2 * 100 % = 50 %
*/

WITH act AS (
  SELECT 
        ProjectID, 
		"Date" AS dt
  FROM ProjectActivity
  GROUP BY ProjectID, "Date"
),
next_update AS (
  SELECT
    ProjectID,
    dt,
    LEAD(dt) OVER (PARTITION BY ProjectID ORDER BY dt) AS next_dt
  FROM act
)
SELECT
  dt AS "Date",
  ROUND(
    100.0 * AVG(
      CASE WHEN next_dt IS NULL OR next_dt >= dt + INTERVAL '7 days' THEN 1.0 ELSE 0.0 END
    )::numeric
  , 2) AS "Abandoned 7 (%)"
FROM next_update
GROUP BY dt
ORDER BY dt;



/*
3.Using data in table ProjectActivity create SQL-query that calculates metric “Retention 7” for each Date in table.
Metric “Retention 7” defines percentage of projects which were created 7 days ago and were updated this day 
(of total count of projects that created 7 days ago). Creation date is minimal modification Date for each project.
Example:
At 2016-10-01 were created 10 projects. 3 of them were updated at 2016-10-08, other 7 were unchanged. “Retention 7” for 2016-10-01 will be:
3 / 10 * 100 % = 30 %.
If at 2016-10-08 were updated other projects that created earlier of later than 2016-10-01 
they shall not be used in calculation “Retention 7” for 2016-10-01. They should be used in calculation “Retention 7” for their creation date.
*/


WITH act AS (
  SELECT 
        ProjectID, 
		"Date" AS dt
  FROM ProjectActivity
  GROUP BY ProjectID, "Date"
),
first_dt AS (
  SELECT 
        ProjectID, 
		MIN(dt) AS created_dt
  FROM act
  GROUP BY ProjectID
),
base AS (
  SELECT 
        a.ProjectID, 
		a.dt, 
		f.created_dt
  FROM act a
  JOIN first_dt f USING (ProjectID)
),
cohort AS (
  SELECT
    b.dt AS today,
    COUNT(*) FILTER (WHERE b.created_dt = b.dt - INTERVAL '7 days') AS updated_from_that_cohort,
    (SELECT COUNT(*) FROM first_dt f WHERE f.created_dt = b.dt - INTERVAL '7 days') AS cohort_size
  FROM base b
  GROUP BY b.dt
)
SELECT
  today AS "Date",
  CASE
    WHEN cohort_size > 0
    THEN ROUND(100.0 * updated_from_that_cohort::numeric / cohort_size, 2)
    ELSE NULL
  END AS "Retention 7 (%)"
FROM cohort
ORDER BY "Date";





