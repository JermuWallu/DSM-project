-- (6 %) Create access rights:
-- Create three roles - admin, employee, trainee.

-- Give admin all administrative rights (same rights as postgres superuser would have)
CREATE ROLE
	admin
WITH 
	SUPERUSER
	LOGIN
	PASSWORD 'admin';

-- Give employee rights to read all information but no rights to write
CREATE ROLE
	employee
WITH
	LOGIN
	PASSWORD 'employee';

GRANT
	SELECT
ON
	ALL TABLES IN SCHEMA public
TO
	employee;
	
-- Give trainee rights to read ONLY project, customer, geo_location, and project_role tables as well as limited access to employee table (only allow reading employee id, name, email)
CREATE ROLE
	trainee
WITH
	LOGIN
	PASSWORD 'trainee';

GRANT
	SELECT
ON
	project,
	customer,
	geo_location,
	project_role
TO
	employee;

GRANT
	SELECT (e_id, emp_name, email)
ON 
	employee
TO
	trainee;