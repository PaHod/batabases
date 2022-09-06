-------------------------------------------------------
--5. Add trigger that will update column 
CREATE OR REPLACE FUNCTION setNewUpdatedDate() 
RETURNS TRIGGER AS $up$
BEGIN
    IF NEW.updated_datetime = OLD.updated_datetime THEN
		UPDATE students SET updated_datetime = now();
	END IF;
    RETURN NEW;
END;
$up$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_date_on_update
AFTER UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION setNewUpdatedDate();

--verify
UPDATE students SET name = 'New name' where student_id = 1;

SELECT * from students; 

-------------------------------------------------------
-- 6. Add validation on DB level that will check username
ALTER TABLE students ADD CHECK (name !~ '(@#$)');

-------------------------------------------------------
--8. Create function that will return average mark for input user. (0.3 point)
CREATE OR REPLACE FUNCTION studetnAvdMark(studentId INTEGER) 
RETURNS INTEGER AS $avg$
DECLARE
 avgMark INTEGER;
BEGIN
	SELECT AVG(mark) into avgMark FROM exam_results WHERE student_id = studentId;
	RETURN avgMark;
END;

$avg$ LANGUAGE plpgsql;

--verify
select studetnAvdMark(2);


-------------------------------------------------------
--9. Create function that will return avarage mark for input subject name. (0.3 point).
CREATE OR REPLACE FUNCTION subjectAvdMark(subjectName TEXT) 
RETURNS INTEGER AS $avg$
DECLARE
 avgMark INTEGER;
BEGIN
	SELECT AVG(mark) into avgMark 
	FROM exam_results
	INNER JOIN subjects
		ON subjects.subject_id = exam_results.subject_id
	WHERE subject_name = subjectName;
	RETURN avgMark;
END;

$avg$ LANGUAGE plpgsql;

--verify
select subjectAvdMark('Math');

-------------------------------------------------------
--10. Create function that will return student at "red zone" (red zone means at least 2 marks <=3). (0.3 point)

CREATE OR REPLACE FUNCTION countRedZone() 
RETURNS TABLE(studentID int, studentName TEXT, redZoneCount INT) AS $avg$

BEGIN
	SELECT students.student_id, students.name, count(exam_results.mark) as "red zone marks count"
	FROM students
	INNER JOIN exam_results
		ON students.student_id = exam_results.student_id
	WHERE exam_results.mark <=3
	GROUP BY students.student_id;
END;

$avg$ LANGUAGE plpgsql;

--verify
select countRedZone();