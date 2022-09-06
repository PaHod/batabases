--1. Design database for CDP program.
--2. Please add appropriate constraints (primary keys, foreign keys, indexes, etc.).

CREATE TABLE students (
	student_id serial PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL,
	birth_date DATE NOT NULL,
	phone_numbers  VARCHAR(50)[],
	prinary_skills  VARCHAR(50)[],
	created_datetime TIMESTAMP NOT NULL DEFAULT now(),
	updated_datetime TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE subjects (
	subject_id serial PRIMARY KEY,
	subject_name VARCHAR(50) NOT NULL,
	tutor VARCHAR(50) NOT NULL,
	duration_hours SMALLINT
);

CREATE TABLE exam_results (
	exam_id serial PRIMARY KEY,
	student_id INTEGER NOT NULL REFERENCES students (student_id),
	subject_id INTEGER NOT NULL REFERENCES subjects (subject_id),
	mark SMALLINT NOT NULL
);

