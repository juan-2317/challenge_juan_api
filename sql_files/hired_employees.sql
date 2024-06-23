CREATE TABLE `challengeglobant`.`hired_employees` (
	`id` INT(11) NOT NULL COMMENT 'Id of the employee' ,
	`name` VARCHAR(250) NOT NULL COMMENT 'Name and surname of the employee' ,
	`datetime` VARCHAR(20) NOT NULL COMMENT 'Hire datetime in ISO format' ,
	`department_id` INT(11) NOT NULL COMMENT 'Id of the department which the employee was hired for' ,
	`job_id` INT(11) NOT NULL COMMENT 'Id of the job which the employee was hired for' ,
	PRIMARY KEY (`id`)
) ENGINE = InnoDB;

ALTER TABLE hired_employees ADD CONSTRAINT Fk_department_employee FOREIGN KEY(department_id) REFERENCES departments(id); 
ALTER TABLE hired_employees ADD CONSTRAINT Fk_job_employee FOREIGN KEY(job_id) REFERENCES jobs(id); 
