-- QAP 1 - Databases: Problem 1
-- Author: Noah Whiffen - SD12
-- Date: February 5th, 2025

-- This file contains all of my correct queries, I didn't include my mistakes but there were a few 

-- Created student table
CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	email TEXT,
	school_enrollment_date DATE
);

-- Created professors table
CREATE TABLE professors (
	professor_id SERIAL PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	department TEXT
);

-- Dropped student table to change id name
DROP TABLE students;

-- Created students table again
CREATE TABLE students (
	student_id SERIAL PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	email TEXT,
	school_enrollment_date DATE
);

-- Created courses table
CREATE TABLE courses (
	course_id SERIAL PRIMARY KEY,
	course_name TEXT,
	course_description TEXT,
	professor_id INT REFERENCES professors(professor_id)
);

-- Created enrollments table
CREATE TABLE enrollments (
	student_id INT REFERENCES students(student_id),
	course_id INT REFERENCES courses(course_id),
	enrollment_date DATE,
	PRIMARY KEY (student_id, course_id)
);

-- Inserted data into students table
INSERT INTO students (first_name, last_name, email, school_enrollment_date) VALUES
('John', 'Winchester', 'john.winchester@keyin.com', '2022-06-15'),
('Bobby', 'Singer', 'bob.singer@example.com', '2020-09-08'),
('Eric', 'Foreman', 'eric.foreman@outlook.com', '2021-09-06'),
('Gregory', 'House', 'gregHouse@keyin.com', '2022-05-14'),
('Frank', 'Gallagher', 'frankieG@example.com', '2021-09-06'),
('Allison', 'Cameron', 'allisonC@email.com', '2024-06-06');

-- Inserted data into professors table
INSERT INTO professors (first_name, last_name, department) VALUES
('Hubert', 'Farnsworth', 'Physics'),
('Walter', 'White', 'Chemistry'),
('Valarie', 'Frizzle', 'Biology'),
('Minerva', 'McGonagall', 'Magic'),
('Dewey', 'Finn', 'Music');

-- Inserted data into courses table
INSERT INTO courses (course_name, course_description, professor_id) VALUES
('Physics 101', 'First level physics course', (SELECT professor_id FROM professors WHERE first_name = 'Hubert')),
('Chemistry 101', 'First level chemistry course', (SELECT professor_id FROM professors WHERE last_name = 'White')),
('Potion Making 101', 'First level potion making course', (SELECT professor_id FROM professors WHERE department = 'Magic')),
('Biology 101', 'First level biology course', (SELECT professor_id FROM professors WHERE last_name = 'Frizzle'));

-- Inserted data into enrollments table
INSERT INTO enrollments(student_id, course_id, enrollment_date) VALUES
(
(SELECT student_id FROM students WHERE first_name = 'John'),
(SELECT course_id FROM courses WHERE course_name = 'Physics 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'Bobby'),
(SELECT course_id FROM courses WHERE course_name = 'Physics 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'Allison'),
(SELECT course_id FROM courses WHERE course_name = 'Physics 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'Eric'),
(SELECT course_id FROM courses WHERE course_name = 'Physics 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'John'),
(SELECT course_id FROM courses WHERE course_name = 'Potion Making 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'Allison'),
(SELECT course_id FROM courses WHERE course_name = 'Potion Making 101'),
'2024-02-05'
),
(
(SELECT student_id FROM students WHERE first_name = 'Gregory'),
(SELECT course_id FROM courses WHERE course_name = 'Potion Making 101'),
'2024-02-05'
);

-- Retrieved full names of students enrolled in Physics 101
SELECT first_name || ' ' || last_name AS full_name FROM students
	JOIN enrollments ON students.student_id = enrollments.student_id
	WHERE enrollments.course_id = 1;

-- Retrieved full names of each professor
SELECT courses.course_name, professors.first_name || ' ' || professors.last_name AS professor_full_name
    FROM courses
    JOIN professors ON courses.professor_id = professors.professor_id;

-- Retrieved all courses with students actively enrolled
SELECT courses.course_id, course_name FROM courses
    JOIN enrollments ON courses.course_id = enrollments.course_id
    JOIN students ON enrollments.student_id = students.student_id;

-- Updated email of a student
UPDATE students
	SET email = 'gregory.house123@example.com'
	WHERE first_name = 'Gregory';

-- Removed a student from a course
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 1;