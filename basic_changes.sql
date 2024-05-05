-- (4 %) Do the following changes to the database:

-- Add zip_code column to Geo_location (you don't have to populate it with data)
ALTER TABLE
	Geo_location
ADD 
	zip_code VARCHAR(10);

-- Add a NOT NULL constraint to customer email and project start date
ALTER TABLE 
	customer
ALTER COLUMN
	email SET NOT NULL;
	
ALTER TABLE 
	project
ALTER COLUMN
	p_start_date SET NOT NULL;

-- Add a check constraint to employee salary and make sure it is more than 1000. You may have to update the salary information to be able to add the constraint (unless you have already done so)
UPDATE 
	employee
SET 
	salary = GREATEST(1000, salary); -- returns higher of the two

ALTER TABLE 
	employee
ADD CONSTRAINT 
	check_salary CHECK (salary >= 1000);
