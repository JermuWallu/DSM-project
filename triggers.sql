-- (15 % ) Create three triggers for the database:
	
	
-- One for before inserting a new skill, make sure that the same skill does not already exist
CREATE OR REPLACE FUNCTION same_skill()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS
$$

DECLARE

BEGIN

	IF
		(SELECT COUNT(*) FROM skills s WHERE s.skill = NEW.skill) > 0
	THEN
		RAISE EXCEPTION 'Skill already exists.';
	ELSE
		RETURN NEW;
	END IF;

END;
$$;

CREATE OR REPLACE TRIGGER check_same_skill BEFORE INSERT ON skills
FOR EACH ROW EXECUTE PROCEDURE same_skill();


-- One for after inserting a new project,  check the customer country and select three employees from that country to start working with the project (i.e. create new project roles)
CREATE OR REPLACE FUNCTION assign_employees()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS
$$

DECLARE
customer_country VARCHAR;

BEGIN

-- check the customer country and select three employees from that country to start working with the project (i.e. create new project roles)
	customer_country := (SELECT
							g.country
						FROM 
						 	customer c
						JOIN 
						 	geo_location g ON g.l_id = c.l_id
						WHERE 
						 	c.c_id = NEW.c_id
						);
	
	INSERT INTO 
		project_role (e_id, p_id)
	SELECT 
		e_id, NEW.p_id
	FROM 
		employee e
	JOIN
		department d ON d.d_id = e.d_id
	JOIN
		headquarters h ON h.h_id = d.hid
	JOIN
		geo_location g ON g.l_id = h.l_id
	WHERE
		g.country = customer_country
	ORDER BY 
		RANDOM()
	LIMIT 3;
	
	
	RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER assign_employees_trigger AFTER INSERT ON project
FOR EACH ROW EXECUTE PROCEDURE assign_employees();


-- One for before updating the employee contract type, make sure that the contract start date is also set to the current date and end date is either 2 years after the start date if contract is of Temporary type, NULL otherwise. (Temporary contract in Finnish is "määräaikainen". It's a contract that has an end date specified).
-- This currently interferes with the "add 3 months to contract" procedure. Currently doesn't work on pgAdmin 4, prob due to its own ordering?
	-- ^^^ this was fixed with 'UPDATE of contract_type'
CREATE OR REPLACE FUNCTION set_contract()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS
$$

DECLARE

BEGIN

-- 	the contract start date is also set to the current date
	NEW.contract_start = NOW()::DATE;

--	end date is either 2 years after the start date if contract is of Temporary type, NULL otherwise. 
	IF
		(NEW.contract_type = 'Temporary')
	THEN
		NEW.contract_end = (NOW() + interval '2 years')::DATE;
	ELSE
		NEW.contract_end = NULL;
	END IF;

	RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER check_contract BEFORE UPDATE of contract_type ON employee
FOR EACH ROW EXECUTE PROCEDURE set_contract();
