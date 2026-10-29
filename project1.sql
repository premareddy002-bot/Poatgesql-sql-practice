---EMPLOYEE MANAGEMENT SYSTEM
---Database name:employee_db
---Create the database separetely before running this script.

--1. CREATE TABLES

CREATE TABLE departments(
department_id SERIAL PRIMARY KEY,
department_name VARCHAR(60) UNIQUE NOT NULL,
location_name VARCHAR(30),
manager_name VARCHAR(50),
budget NUMERIC(12,2),
employee_count INT DEFAULT 0,
contact_no VARCHAR(30),
create_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE employees(
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(60) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(80) UNIQUE,
phone VARCHAR(20),
job_role VARCHAR(100),
salary NUMERIC(10,2) CHECK (salary>0),
hire_date DATE DEFAULT CURRENT_DATE,
department_id INT REFERENCES departments(department_id)
);

CREATE TABLE attendence(
attendence_id SERIAL PRIMARY KEY,
employee_id INT REFERENCES employees(employee_id),
attendence_date DATE NOT NULL,
check_in TIME,
check_out TIME,
status VARCHAR(50) DEFAULT 'present',
working_hrs NUMERIC(4,2),
overtime_hrs NUMERIC(4,2),
remarks VARCHAR(100)
);

----2.INSERT DEPARTMENTS


INSERT INTO departments(department_name,location_name,manager_name,budget,employee_count,contact_no) VALUES
('IT','Hyderabad','Prema',50000,2,'50000000'),
('HR','Benguluru','Anjali',30000,1,'872983630'),
('Finance','Chennai','Karthik',70000,2,'90838740938');

---3.INSERT EMPLOYESS


INSERT INTO employees(first_name,last_name,email,phone,job_role,salary,hire_date,department_id) VALUES
('Arjun','Reddy','arjun@2782','9387428732','Developer',87483,'26-3-2007',1),
('prema','Reddy','prema@78392','748740924','Tester',937487,'10-8-2027',1),
('Anushka','Sharma','anushka@548','67984874','HR',849488,'12-6-2029',2),
('Virat','Kohli','virat@654','7867675875','Accountant',50000,'30-7-2050',3),
('Vamika','Kohli','vamika@5868','38749387','HR',80000,'20-12-2060',3);

---4.INSERT ATTENDENCE

INSERT INTO attendence(employee_id,attendence_date,check_in,check_out,status,working_hrs,overtime_hrs,remarks) VALUES
(1,'2028-6-28','09:00','19:00','Present',8,0,'Regular day'),
(2,'29-8-8','09:00','18:00','Present',9,6,'Overtime'),
(3,'30-7-2837','10:00','20:00','Absent',6,8.9,'Leave not approved'),
(4,'4-4-3874','11:00','21:00','Late Comer',9,0,'Rgular day'),
(5,'3-06-3738','12:00','20:00','Absent',2,8,'Overtime');

----5.BASIC SELECT QUERIES

SELECT*FROM employees;

SELECT first_name,last_name,salary 
FROM employees;

SELECT*FROM employees
WHERE salary>45000;

SELECT*FROM employees
ORDER BY salary DESC;

SELECT*FROM employees
WHERE first_name LIKE 'A%';

SELECT*FROM employees
WHERE hire_date 
BETWEEN '22-01-01' AND '2024-12-31';

SELECT DISTINCT job_role
FROM employees;

SELECT*FROM employees 
WHERE salary
BETWEEN 40000 AND 60000;

SELECT*FROM employees 
WHERE job_role
IN ('Developer','Tester'); 

SELECT*FROM employees 
ORDER BY salary
DESC LIMIT 3; 

SELECT COUNT(*)
As total_employees
FROM employees;

SELECT AVG(salary) 
AS average_salary
FROM employees;

SELECT MAX(salary)
AS highest_salary,MIN(salary) 
AS lowest_salary
FROM employees;

SELECT department_id,SUM(salary)
AS total_salary
FROM employees
GROUP BY department_id;

SELECT e.department_id,AVG(e.salary)
AS average_salary
FROM employees e 
INNER JOIN departments d
ON d.department_id = e.department_id
GROUP BY e.department_id;

SELECT d.department_name,e.first_name,e.salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id;

SELECT e.first_name,a.attendence_date,a.status,
a.working_hrs
FROM employees e
JOIN attendence a
ON e.employee_id = a.employee_id;

SELECT e.first_name,a.attendence_date,a.status
FROM employees e
JOIN attendence a
ON e.employee_id = a.employee_id
WHERE a.status = 'Present';

---6.SUBQUERIES


SELECT first_name,last_name,salary
FROM employees
WHERE salary =(SELECT MAX(salary)FROM employees);

---7.CASE AND COALESCE

SELECT first_name,salary,
CASE
  WHEN salary >= 55000 THEN 'High Salary'
  WHEN salary >= 45000 THEN 'Medium Salary'
  ELSE 'Entry Level'
  END AS salary_catogory
FROM employees;

SELECT attendence_id,
   COALESCE(remarks,'No remarks') AS remarks
FROM attendence;

---8.STRING AND DATE FUNCTIONS

SELECT UPPER(first_name) AS uppercase_name
FROM employees;

SELECT first_name,LENGTH(first_name) 
AS name_length
FROM employees;
SELECT CURRENT_DATE AS today;

SELECT first_name,hire_date,
    EXTRACT(YEAR FROM hire_date) AS
joining_year
FROM employees;

--9.UPDATE QUERIES

UPDATE employees
SET salary = salary+50000
WHERE employee_id =1;

UPDATE employees 
SET job_role = 'Senior Developer'
WHERE employee_id = 1;

UPDATE attendence
SET status = 'Present'
WHERE attendence_id = 3;

---10.DELETE QUERIES

DELETE FROM attendence
WHERE attendence_id = 5;


---11.CREATE A VIEW

CREATE VIEW employee_details AS 
SELECT e.employee_id,e.first_name,e.last_name,
       e.email,e.job_role,e.salary,
	   d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

SELECT*FROM employee_details;

---12.CREATE AN INDEX

CREATE INDEX idx_employee_salary
ON employees(salary);

----13.WINDOW FUNCTION: RANK EMPLOYEES

SELECT first_name,last_name,salary,
RANK()OVER(ORDER BY salary DESC)AS 
salary_rank
FROM employees;

---14.FINAL VERIFICATION

SELECT*FROM departments;
SELECT*FROM employees;
SELECT*FROM attendence;
SELECT*FROM  employee_details;

--END OD PROJECT