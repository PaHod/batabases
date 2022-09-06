--------------------------------------------------------------------------------------------------------------
--a. Find user by name (exact match)
EXPLAIN ANALYZE
SELECT * FROM students WHERE name = 'Student500';

--BEFORE index

                                               QUERY PLAN
---------------------------------------------------------------------------------------------------------
 Seq Scan on students  (cost=0.00..2779.74 rows=99 width=112) (actual time=0.027..7.350 rows=92 loops=1)
   Filter: ((name)::text = 'Student500'::text)
   Rows Removed by Filter: 100047
 Planning Time: 0.163 ms
 Execution Time: 7.370 ms
(5 rows)


--B-Tree index
--create index on students (name);

                                                         QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on students  (cost=5.06..318.11 rows=99 width=112) (actual time=0.061..0.149 rows=92 loops=1)
   Recheck Cond: ((name)::text = 'Student500'::text)
   Heap Blocks: exact=91
   ->  Bitmap Index Scan on students_name_idx  (cost=0.00..5.04 rows=99 width=0) (actual time=0.050..0.050 rows=92 loops=1)
         Index Cond: ((name)::text = 'Student500'::text)
 Planning Time: 0.362 ms
 Execution Time: 0.182 ms
(7 rows)

-- Hash index
--create index on students using hash (name);
 Bitmap Heap Scan on students  (cost=4.77..317.82 rows=99 width=112) (actual time=0.054..0.159 rows=92 loops=1)
   Recheck Cond: ((name)::text = 'Student500'::text)
   Heap Blocks: exact=91
   ->  Bitmap Index Scan on students_name_idx  (cost=0.00..4.74 rows=99 width=0) (actual time=0.039..0.039 rows=92 loops=1)
         Index Cond: ((name)::text = 'Student500'::text)
 Planning Time: 0.379 ms
 Execution Time: 0.185 ms
(7 rows)


