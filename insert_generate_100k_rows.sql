--fill 100 000  students
insert into students (name, surname, birth_date, phone_numbers, created_datetime, updated_datetime)
values ('Student' || (random()*1000)::int,
		'Surname' || (random()*1000)::int,
		now() - ('1 weeks'::interval * random() * 250 - '16 years'::interval),
		ARRAY[generate_series(100001, 200000)],
		now() - ('1 weeks'::interval * random() * 250),
		now() - ('1 weeks'::interval * random() * 250));
		

--fill 1 000  subjects
insert into subjects (subject_name, tutor, duration_hours) 
values ('Subject' || generate_series(1, 1000),
		'Tutor' || (random()*500)::int,
		(random()*200)::int) 
		;


--fill 1 000 000 exam results
do $$
begin
    for i in 1..1000000 loop
		insert into exam_results (student_id, subject_id, mark) 
		values ((random()*100000)::int+1,
				(random()*1000)::int+1,
				(random()*5)::int);
	end loop;
end; 
$$;