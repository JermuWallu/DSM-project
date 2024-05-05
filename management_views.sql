-- (8 % ) Create four views to provide for the company superiors and management.
	-- The views should contain information that is important for the management of the company
	-- Idea of views is to combine data from various tables to provide an easier access to the combined information. 
	-- The view does not have to be the final query result (i.e. View is used for easier access and then queried again for more detailed information)
	-- Each view should join at least two tables (not including linking tables)

-- View 1: see employee details
CREATE OR REPLACE VIEW 
	employee_details AS
SELECT
    e.e_id AS Employee_ID,
    e.emp_name AS Employee_Name,
    jt.title AS Job_Title,
    e.salary AS Salary,
    d.dep_name AS Department,
    e.email AS Email
FROM
    employee e
JOIN
	department d ON d.d_id = e.d_id
JOIN
	job_title jt ON e.j_id = jt.j_id;


-- View 2: Department details with count of employees
CREATE OR REPLACE VIEW 
	department_details AS
SELECT
    d.d_id AS Department_ID,
    d.dep_name AS Department_Name,
	hq.hq_name AS Headquarters,
	gl.country AS Country,
	COUNT(e.e_id) AS Employee_count
FROM
    department d
JOIN
	headquarters hq ON d.hid = hq.h_id
JOIN
	geo_location gl ON hq.l_id = gl.l_id
JOIN
	employee e ON e.d_id = d.d_id
GROUP BY 
	d.d_id, 
	d.dep_name, 
	hq.hq_name, 
	gl.country;
	

-- View 3: Employee stats
CREATE OR REPLACE VIEW 
	employee_statistics AS
SELECT
	COUNT(e.e_id) AS "Number of employees",
	ROUND(SUM(e.salary), 1) AS "Total Salary",
	ROUND(AVG(e.salary), 1) AS "Average Salary",
	COUNT(DISTINCT jt.j_id) AS "Number of different Job titles",
	ROUND(AVG(jt.base_salary), 1) AS "Average base salary"
FROM
	employee e
JOIN 
	job_title jt ON jt.j_id = e.j_id;
	

-- View 4: Contract details
CREATE OR REPLACE VIEW 
	contract_details AS
SELECT
    e.e_id AS Employee_ID,
    e.emp_name AS Employee_name,
    e.contract_type AS Contract_Type,
    e.contract_start AS Contract_Start,
    e.contract_end AS Contract_end,
	jt.title AS Job_title,
   	e.salary AS "Employee salary", -- uijuma toimii :D
	gl.country AS "Employees Home Country"

FROM
    employee e
JOIN 
	job_title jt ON e.j_id = jt.j_id
JOIN 
	department d ON d.d_id = e.d_id
JOIN
	headquarters hq ON d.hid = hq.h_id
JOIN
	geo_location gl ON hq.l_id = gl.l_id;

-- View 5: Project details
CREATE OR REPLACE VIEW
	project_details AS
SELECT
	p.p_id,
	p.project_name,
	p.budget,
	p.commission_percentage,
	c.c_name,
	c.c_type,
	c.email,
	COUNT(DISTINCT pr.e_id) AS "Employee Count"
FROM
	project p
JOIN
	customer c ON p.c_id = c.c_id
JOIN
	project_role pr ON pr.p_id = p.p_id 
GROUP BY
	p.p_id,
	p.project_name,
	p.budget,
	p.commission_percentage,
	c.c_name,
	c.c_type,
	c.email;