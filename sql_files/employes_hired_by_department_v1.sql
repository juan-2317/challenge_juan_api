WITH count_q1 AS (
    SELECT b.department, c.job, COUNT(DISTINCT a.id) AS Q1
    FROM `hired_employees` a
    INNER JOIN `departments` b
    ON a.department_id = b.id
    INNER JOIN `jobs` c
    ON a.job_id = c.id
    WHERE QUARTER(a.datetime) = 1
    GROUP BY b.department, c.job
), count_q2 AS (
	SELECT b.department, c.job, COUNT(DISTINCT a.id) AS Q2
    FROM `hired_employees` a
    INNER JOIN `departments` b
    ON a.department_id = b.id
    INNER JOIN `jobs` c
    ON a.job_id = c.id
    WHERE QUARTER(a.datetime) = 2
    GROUP BY b.department, c.job
), count_q3 AS (
	SELECT b.department, c.job, COUNT(DISTINCT a.id) AS Q3
    FROM `hired_employees` a
    INNER JOIN `departments` b
    ON a.department_id = b.id
    INNER JOIN `jobs` c
    ON a.job_id = c.id
    WHERE QUARTER(a.datetime) = 3
    GROUP BY b.department, c.job
), count_q4 AS (
	SELECT b.department, c.job, COUNT(DISTINCT a.id) AS Q4
    FROM `hired_employees` a
    INNER JOIN `departments` b
    ON a.department_id = b.id
    INNER JOIN `jobs` c
    ON a.job_id = c.id
    WHERE QUARTER(a.datetime) = 4
    GROUP BY b.department, c.job
), base AS (
	SELECT DISTINCT b.department, c.job
    FROM `hired_employees` a
    INNER JOIN `departments` b
    ON a.department_id = b.id
    INNER JOIN `jobs` c
    ON a.job_id = c.id
)
SELECT a.department, a.job,
	COALESCE(b.Q1, 0) AS Q1,
    COALESCE(c.Q2, 0) AS Q2,
    COALESCE(d.Q3, 0) AS Q3,
    COALESCE(e.Q4, 0) AS Q4
FROM base a
LEFT JOIN count_q1 b
ON a.department = b.department AND a.job = b.job
LEFT JOIN count_q2 c
ON a.department = c.department AND a.job = c.job
LEFT JOIN count_q3 d
ON a.department = d.department AND a.job = d.job
LEFT JOIN count_q4 e
ON a.department = e.department AND a.job = e.job
ORDER BY a.department, a.job;
