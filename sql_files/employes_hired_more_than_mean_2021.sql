CREATE OR REPLACE VIEW employees_hired_more_than_mean_2021 AS 
	WITH employees_hired_2021 AS (
		SELECT
			b.id AS department_id,
			b.department,
			COUNT(DISTINCT a.id) AS hired
		FROM `hired_employees` a
		INNER JOIN `departments` b
		ON a.department_id = b.id
		WHERE EXTRACT(YEAR FROM a.datetime) = 2021
		GROUP BY department_id, department
	), hired_after_2021 AS (
		SELECT
			b.id AS department_id,
			b.department,
			COUNT(DISTINCT a.id) AS hired
		FROM `hired_employees` a
		INNER JOIN `departments` b
		ON a.department_id = b.id
		WHERE EXTRACT(YEAR FROM a.datetime) > 2021 OR a.datetime IS NULL
		GROUP BY department_id, department
	)
	SELECT a.*
	FROM hired_after_2021 a
	LEFT JOIN employees_hired_2021 b
	ON a.department_id = b.department_id AND a.department = b.department
	WHERE a.hired > b.hired
	ORDER BY a.hired DESC;
