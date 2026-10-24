-- ============================================
-- SETUP: CREATE TABLES
-- ============================================

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 0),
    grade INT NOT NULL,
    city VARCHAR(50),
    marks INT
);

CREATE TABLE enrollments (
    student_id INT REFERENCES students(id),
    course_id INT,
    score INT,
    PRIMARY KEY (student_id, course_id)
);

-- ============================================
-- INSERT 8 INITIAL STUDENTS
-- ============================================

INSERT INTO students (name, age, grade, city, marks)
VALUES
('Prema',   11, 5, 'Pune',      70),
('Karthik', 12, 7, 'Hyderabad', 90),
('Keerthi',  9, 5, 'Chennai', NULL),
('Anjali',  13, 7, 'Hyderabad', 95),
('Shruthi', 10, 6, 'Pune',      78),
('Abhay',   14, 8, 'Mumbai',    88),
('Radha',    8, 5, 'Chennai',   72),
('Nikhil',  15, 6, 'Mumbai',    80);

-- ============================================
-- INSERT ENROLLMENT DATA
-- ============================================

INSERT INTO enrollments (student_id, course_id, score)
VALUES
(1, 1, 80),
(2, 1, 90),
(3, 2, 75),
(4, 2, 88),
(5, 3, 91),
(6, 3, 77),
(7, 5, 84),
(8, 5, 95);


-- ============================================
-- PART 1: CRUD & FILTERING
-- ============================================

-- 1.1 Show every column of every student (8 rows)

SELECT *
FROM students;


-- 1.2 Names and cities of students older than 10 (5 rows)

SELECT name, city
FROM students
WHERE age > 10;


-- 1.3 Grade 5 or grade 7, using OR (5 rows)

SELECT *
FROM students
WHERE grade = 5 OR grade = 7
ORDER BY name ASC;

-- Alternative using IN (5 rows)

SELECT *
FROM students
WHERE grade IN (5, 7)
ORDER BY name ASC;


-- 1.4 Names starting with A (2 rows)

SELECT *
FROM students
WHERE name LIKE 'A%';


-- 1.5 First try: this returns 0 rows

SELECT *
FROM students
WHERE marks = NULL;

-- Correct query: returns 1 row

SELECT *
FROM students
WHERE marks IS NULL;


-- 1.6 Top 3 students by marks (3 rows)

SELECT *
FROM students
ORDER BY marks DESC NULLS LAST
LIMIT 3;

-- Explanation:
-- PostgreSQL sorts NULL values first with DESC by default.
-- NULLS LAST puts missing marks at the end.


-- 1.7 Show distinct cities (4 rows)

SELECT DISTINCT city
FROM students
ORDER BY city;


-- 1.8(a) Insert Priya (8 rows become 9)

SELECT COUNT(*) AS total_students
FROM students;

INSERT INTO students (name, age, grade, city, marks)
VALUES ('Priya', 11, 6, 'Pune', 81);

SELECT COUNT(*) AS total_students
FROM students;

-- 1.8(b) Update Priya's marks to 85 (still 9 rows)

UPDATE students
SET marks = 85
WHERE name = 'Priya';

SELECT COUNT(*) AS total_students
FROM students;

-- 1.8(c) Delete Priya (9 rows become 8)

DELETE FROM students
WHERE name = 'Priya';

SELECT COUNT(*) AS total_students
FROM students;


-- ============================================
-- PART 2: ALTER TABLE & CONSTRAINTS
-- ============================================

-- 2.1 Add email column

ALTER TABLE students
ADD COLUMN email VARCHAR(100);

-- 2.2 Rename email to email_id

ALTER TABLE students
RENAME COLUMN email TO email_id;

-- 2.3 INTENTIONAL ERROR: run separately
-- The name column is NOT NULL.
-- Uncomment and execute to see the error.

-- INSERT INTO students (age, grade)
-- VALUES (10, 5);


-- 2.4 INTENTIONAL ERROR: run separately
-- The age CHECK constraint rejects negative ages.

-- INSERT INTO students (name, age, grade)
-- VALUES ('TestStudent', -3, 5);


-- 2.5 INTENTIONAL ERROR: run separately
-- Student 99 does not exist, so the foreign key rejects it.

-- INSERT INTO enrollments (student_id, course_id, score)
-- VALUES (99, 1, 50);


-- 2.6 Remove email_id column

ALTER TABLE students
DROP COLUMN email_id;


-- ============================================
-- PART 3: AGGREGATES, GROUP BY & HAVING
-- ============================================

-- 3.1 Number of students and average age (1 row)

SELECT COUNT(*) AS total_students,
       ROUND(AVG(age), 2) AS average_age
FROM students;


-- 3.2 Highest and lowest marks (1 row)

SELECT MAX(marks) AS highest_marks,
       MIN(marks) AS lowest_marks
FROM students;


-- 3.3 Count all students versus non-NULL marks (1 row)

SELECT COUNT(*) AS total_students,
       COUNT(marks) AS students_with_marks
FROM students;


-- 3.4 Number of students in each grade (4 rows)

SELECT grade, COUNT(*) AS student_count
FROM students
GROUP BY grade
ORDER BY grade;


-- 3.5 Average marks per city, highest first (4 rows)

SELECT city,
       ROUND(AVG(marks), 1) AS average_marks
FROM students
GROUP BY city
ORDER BY average_marks DESC;


-- 3.6 Cities with average marks above 75 (2 rows)

SELECT city,
       ROUND(AVG(marks), 1) AS average_marks
FROM students
GROUP BY city
HAVING AVG(marks) > 75
ORDER BY average_marks DESC;


-- 3.7 Grades with at least 2 students (3 rows)

SELECT grade, COUNT(*) AS student_count
FROM students
GROUP BY grade
HAVING COUNT(*) >= 2
ORDER BY grade;


-- 3.8 Count students in each course (4 rows)

SELECT course_id,
       COUNT(*) AS student_count
FROM enrollments
GROUP BY course_id
ORDER BY course_id;

-- Course ID 4 is missing because it has no enrollments.


-- 3.9 Highest score in each course (4 rows)

SELECT course_id,
       MAX(score) AS highest_score
FROM enrollments
GROUP BY course_id
ORDER BY course_id;


-- 3.10 Total students and students with marks per city (4 rows)

SELECT city,
       COUNT(*) AS total_students,
       COUNT(marks) AS students_with_marks
FROM students
GROUP BY city
ORDER BY city;