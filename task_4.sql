-------------------------------------------------------
--a. Find user by name (exact match)
EXPLAIN ANALYZE
SELECT * FROM students WHERE name = 'Student500';

--- BEFORE index
                                               Table "public.students"
      Column      |            Type             | Collation | Nullable |                   Default
------------------+-----------------------------+-----------+----------+----------------------------------------------
 student_id       | integer                     |           | not null | nextval('students_student_id_seq'::regclass)
 name             | character varying(50)       |           | not null |
 surname          | character varying(50)       |           | not null |
 birth_date       | date                        |           | not null |
 phone_numbers    | character varying(50)[]     |           |          |
 prinary_skills   | character varying(50)[]     |           |          |
 created_datetime | timestamp without time zone |           | not null | now()
 updated_datetime | timestamp without time zone |           | not null | now()
Indexes:
    "students_pkey" PRIMARY KEY, btree (student_id)
Referenced by:
    TABLE "exam_results" CONSTRAINT "exam_results_student_id_fkey" FOREIGN KEY (student_id) REFERENCES students(student_id)
Triggers:
    update_date_on_update AFTER UPDATE ON students FOR EACH ROW EXECUTE FUNCTION refreshupdateddate()
	
	
	
                                               QUERY PLAN
---------------------------------------------------------------------------------------------------------
 Seq Scan on students  (cost=0.00..2779.74 rows=99 width=112) (actual time=0.027..7.350 rows=92 loops=1)
   Filter: ((name)::text = 'Student500'::text)
   Rows Removed by Filter: 100047
 Planning Time: 0.163 ms
 Execution Time: 7.370 ms
(5 rows)



-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
--b. Find user by surname (partial match)
EXPLAIN ANALYZE
SELECT * FROM students WHERE name ~ '50';

--- BEFORE index
                                                  QUERY PLAN
--------------------------------------------------------------------------------------------------------------
 Seq Scan on students  (cost=0.00..2779.74 rows=2089 width=112) (actual time=0.025..25.871 rows=1961 loops=1)
   Filter: ((name)::text ~ '50'::text)
   Rows Removed by Filter: 98184
 Planning Time: 0.131 ms
 Execution Time: 25.922 ms
(5 rows)


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
--c. Find user by phone number (partial match)
EXPLAIN ANALYZE
SELECT * FROM students
JOIN LATERAL unnest(students.phone_numbers) as un(phone_number) on TRUE
 WHERE phone_number LIKE '%3317%';
 
--- BEFORE index
                                                      QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..16048.16 rows=100139 width=144) (actual time=3.859..109.521 rows=20 loops=1)
   ->  Seq Scan on students  (cost=0.00..2529.39 rows=100139 width=112) (actual time=0.013..7.363 rows=100145 loops=1)
   ->  Function Scan on unnest un  (cost=0.00..0.13 rows=1 width=32) (actual time=0.001..0.001 rows=0 loops=100145)
         Filter: ((phone_number)::text ~~ '%3317%'::text)
         Rows Removed by Filter: 1
 Planning Time: 0.135 ms
 Execution Time: 109.552 ms
(7 rows)


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
--d. Find user with marks by user surname (partial match)
EXPLAIN ANALYZE
SELECT count(*) FROM students
INNER JOIN exam_results ON students.student_id = exam_results.student_id
WHERE students.surname LIKE '%123%';

--- BEFORE index
                                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=14075.47..14075.48 rows=1 width=8) (actual time=116.421..119.277 rows=1 loops=1)
   ->  Gather  (cost=14075.26..14075.47 rows=2 width=8) (actual time=111.357..119.268 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=13075.26..13075.27 rows=1 width=8) (actual time=47.970..47.972 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=2264.39..13075.15 rows=42 width=0) (actual time=3.287..47.939 rows=319 loops=3)
                     Hash Cond: (exam_results.student_id = students.student_id)
                     ->  Parallel Seq Scan on exam_results  (cost=0.00..9702.14 rows=422314 width=4) (actual time=0.007..27.088 rows=506500 loops=2)
                     ->  Parallel Hash  (cost=2264.32..2264.32 rows=6 width=4) (actual time=3.124..3.124 rows=33 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 40kB
                           ->  Parallel Seq Scan on students  (cost=0.00..2264.32 rows=6 width=4) (actual time=0.047..9.321 rows=98 loops=1)
                                 Filter: ((surname)::text ~~ '%123%'::text)
                                 Rows Removed by Filter: 100047
 Planning Time: 0.271 ms
 Execution Time: 119.314 ms
(15 rows)









