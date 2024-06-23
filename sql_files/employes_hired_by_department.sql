WITH select_cols AS (
	SELECT b.department, c.job, a.id AS employee_id,
		CASE WHEN QUARTER(a.datetime) = 1
			THEN 1 ELSE NULL
		END AS Q1,
		CASE WHEN QUARTER(a.datetime) = 2
			THEN 2 ELSE NULL
		END AS Q2,
		CASE WHEN QUARTER(a.datetime) = 3
			THEN 3 ELSE NULL
		END AS Q3,
		CASE WHEN QUARTER(a.datetime) = 4
			THEN 4 ELSE NULL
		END AS Q4
	FROM `hired_employees` a
	INNER JOIN `departments` b
	ON a.department_id = b.id
	INNER JOIN `jobs` c
	ON a.job_id = c.id
) SELECT department, job,
	COUNT(Q1) AS Q1,
	COUNT(Q2) AS Q2,
    COUNT(Q3) AS Q3,
    COUNT(Q4) AS Q4
FROM select_cols
GROUP BY department, job
ORDER BY department, job;
