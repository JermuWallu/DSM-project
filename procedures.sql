-- (9 %) Create three procedures for the database:

-- Procedure that sets all employees salary to the base level based on their job title
CREATE OR REPLACE PROCEDURE set_all_salary_to_base()
LANGUAGE plpgsql AS
$$
DECLARE
	
BEGIN

	UPDATE 
		employee 
	SET
		salary = (SELECT base_salary FROM job_title WHERE employee.j_id = job_title.j_id);
	
END;
$$;


-- Procedure that adds 3 months to all temporary contracts
CREATE OR REPLACE PROCEDURE add_3_month_to_all_temporary_contracts()
LANGUAGE plpgsql AS
$$
DECLARE
	
BEGIN

	UPDATE
		employee
	SET
		contract_end = contract_end + interval '1 months' * 3 -- this way its 3 months, and can be turned into param
	WHERE
		contract_type = 'Temporary';

END;
$$;

-- Procedure that increases salaries by a percentage based on the given percentage. You can also specify the highest salary to be increased (give limit X and salaries that are below X are increased). 
-- The user can specify the salary limit when calling the procedure. If user doesn't specify one (or gives 0 or null), then the limit is not considered. The percentage can be given in decimals or numbers or what ever you specify, as long as the procedure works.
CREATE OR REPLACE PROCEDURE increase_salaries_by_percentage(percentage FLOAT, salary_limit NUMERIC)
LANGUAGE plpgsql AS
$$
DECLARE

BEGIN
	IF 
		(salary_limit = 0)
	THEN
		UPDATE
			employee
		SET
			salary = salary * (1+percentage);
	ELSE
		UPDATE
			employee
		SET
			salary = LEAST((salary * (1+percentage))::NUMERIC, salary_limit);
	END IF;
END;
$$;


