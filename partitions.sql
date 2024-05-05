-- (8 %) Partition two of the following tables to at least three partitions (excluding default partition):
	

-- Employee table
CREATE TABLE employee_partitioned (
    LIKE employee INCLUDING ALL
)
PARTITION BY RANGE (e_id);

-- Employee partitions
CREATE TABLE employee_partition1 PARTITION OF employee_partitioned
    FOR VALUES FROM (MINVALUE) TO (499);

CREATE TABLE employee_partition2 PARTITION OF employee_partitioned
    FOR VALUES FROM (500) TO (999);
	
CREATE TABLE employee_partition3 PARTITION OF employee_partitioned
    FOR VALUES FROM (1000) TO (MAXVALUE);

CREATE TABLE employee_default PARTITION OF employee_partitioned DEFAULT;


-- Project table 
CREATE TABLE customer_partitioned (
    LIKE customer INCLUDING ALL
)
PARTITION BY RANGE (c_id);

-- Projects partitions
CREATE TABLE customer_partition1 PARTITION OF customer_partitioned
	FOR VALUES FROM (MINVALUE) TO (499);

CREATE TABLE customer_partition2 PARTITION OF customer_partitioned
    FOR VALUES FROM (500) TO (999);

CREATE TABLE customer_partition3 PARTITION OF customer_partitioned
    FOR VALUES FROM (1000) TO (MAXVALUE);
	
	
CREATE TABLE customer_default PARTITION OF customer_partitioned DEFAULT;


-- Inserting data:
INSERT INTO employee_partition1
SELECT *
FROM employee
WHERE e_id >= (MINVALUE) AND e_id <= 499;

INSERT INTO employee_partition2
SELECT *
FROM employee
WHERE e_id >= 500 AND e_id <= 999;

INSERT INTO employee_partition3
SELECT *
FROM employee
WHERE e_id >= 1000 AND e_id <= (MAXVALUE);

INSERT INTO customer_partition1
SELECT *
FROM customer
WHERE c_id >= (MINVALUE) AND c_id <= 499;

INSERT INTO customer_partition2
SELECT *
FROM customer
WHERE c_id >= 500 AND c_id <= 999;

INSERT INTO customer_partition3
SELECT *
FROM customer
WHERE c_id >= 1000 AND c_id <= (MAXVALUE);