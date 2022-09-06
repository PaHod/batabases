--------------------------------------------------------------------------------------------------------------
--d. Find user with marks by user surname (partial match)
EXPLAIN ANALYZE
SELECT count(*) FROM students
INNER JOIN exam_results ON students.student_id = exam_results.student_id
WHERE students.surname LIKE '%123%';

--- BEFORE index
                                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=14075.52..14075.53 rows=1 width=8) (actual time=175.400..178.452 rows=1 loops=1)
   ->  Gather  (cost=14075.30..14075.51 rows=2 width=8) (actual time=173.062..178.441 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=13075.30..13075.31 rows=1 width=8) (actual time=72.196..72.198 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=2264.44..13075.20 rows=42 width=0) (actual time=3.054..72.139 rows=319 loops=3)
                     Hash Cond: (exam_results.student_id = students.student_id)
                     ->  Parallel Seq Scan on exam_results  (cost=0.00..9702.14 rows=422314 width=4) (actual time=0.010..45.776 rows=506500 loops=2)
                     ->  Parallel Hash  (cost=2264.36..2264.36 rows=6 width=4) (actual time=2.882..2.883 rows=33 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 40kB
                           ->  Parallel Seq Scan on students  (cost=0.00..2264.36 rows=6 width=4) (actual time=0.055..8.590 rows=98 loops=1)
                                 Filter: ((surname)::text ~~ '%123%'::text)
                                 Rows Removed by Filter: 100047
 Planning Time: 0.583 ms
 Execution Time: 178.495 ms
(15 rows)



--B-Tree index
                                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=14075.52..14075.53 rows=1 width=8) (actual time=172.058..176.736 rows=1 loops=1)
   ->  Gather  (cost=14075.30..14075.51 rows=2 width=8) (actual time=171.984..176.725 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=13075.30..13075.31 rows=1 width=8) (actual time=73.170..73.172 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=2264.44..13075.20 rows=42 width=0) (actual time=4.415..73.110 rows=319 loops=3)
                     Hash Cond: (exam_results.student_id = students.student_id)
                     ->  Parallel Seq Scan on exam_results  (cost=0.00..9702.14 rows=422314 width=4) (actual time=0.007..28.615 rows=337666 loops=3)
                     ->  Parallel Hash  (cost=2264.36..2264.36 rows=6 width=4) (actual time=4.210..4.211 rows=33 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 40kB
                           ->  Parallel Seq Scan on students  (cost=0.00..2264.36 rows=6 width=4) (actual time=0.063..12.577 rows=98 loops=1)
                                 Filter: ((surname)::text ~~ '%123%'::text)
                                 Rows Removed by Filter: 100047
 Planning Time: 0.478 ms
 Execution Time: 176.778 ms
(15 rows)


-- Hash index

students-# WHERE students.surname LIKE '%123%';
                                                                     QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=14075.52..14075.53 rows=1 width=8) (actual time=183.420..187.023 rows=1 loops=1)
   ->  Gather  (cost=14075.30..14075.51 rows=2 width=8) (actual time=174.407..186.979 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=13075.30..13075.31 rows=1 width=8) (actual time=72.757..72.759 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=2264.44..13075.20 rows=42 width=0) (actual time=3.840..72.705 rows=319 loops=3)
                     Hash Cond: (exam_results.student_id = students.student_id)
                     ->  Parallel Seq Scan on exam_results  (cost=0.00..9702.14 rows=422314 width=4) (actual time=0.005..43.292 rows=506500 loops=2)
                     ->  Parallel Hash  (cost=2264.36..2264.36 rows=6 width=4) (actual time=3.656..3.657 rows=33 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 40kB
                           ->  Parallel Seq Scan on students  (cost=0.00..2264.36 rows=6 width=4) (actual time=0.077..10.913 rows=98 loops=1)
                                 Filter: ((surname)::text ~~ '%123%'::text)
                                 Rows Removed by Filter: 100047
 Planning Time: 0.611 ms
 Execution Time: 187.071 ms
(15 rows)








