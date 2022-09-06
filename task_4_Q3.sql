
--------------------------------------------------------------------------------------------------------------
--c. Find user by phone number (partial match)
EXPLAIN ANALYZE
SELECT * FROM students
JOIN LATERAL unnest(students.phone_numbers) as un(phone_number) on TRUE
 WHERE phone_number LIKE '%3317%';
 
--- BEFORE index
                                                      QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..16049.03 rows=100145 width=144) (actual time=3.652..187.530 rows=20 loops=1)
   ->  Seq Scan on students  (cost=0.00..2529.45 rows=100145 width=112) (actual time=0.010..12.290 rows=100145 loops=1)
   ->  Function Scan on unnest un  (cost=0.00..0.13 rows=1 width=32) (actual time=0.001..0.001 rows=0 loops=100145)
         Filter: ((phone_number)::text ~~ '%3317%'::text)
         Rows Removed by Filter: 1
 Planning Time: 0.281 ms
 Execution Time: 187.566 ms
(7 rows)


--B-Tree index

                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..16049.03 rows=100145 width=144) (actual time=3.856..177.569 rows=20 loops=1)
   ->  Seq Scan on students  (cost=0.00..2529.45 rows=100145 width=112) (actual time=0.008..10.760 rows=100145 loops=1)
   ->  Function Scan on unnest un  (cost=0.00..0.13 rows=1 width=32) (actual time=0.001..0.001 rows=0 loops=100145)
         Filter: ((phone_number)::text ~~ '%3317%'::text)
         Rows Removed by Filter: 1
 Planning Time: 0.511 ms
 Execution Time: 177.601 ms
(7 rows)


-- Hash index

                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..16049.03 rows=100145 width=144) (actual time=2.745..191.016 rows=20 loops=1)
   ->  Seq Scan on students  (cost=0.00..2529.45 rows=100145 width=112) (actual time=0.007..11.774 rows=100145 loops=1)
   ->  Function Scan on unnest un  (cost=0.00..0.13 rows=1 width=32) (actual time=0.001..0.001 rows=0 loops=100145)
         Filter: ((phone_number)::text ~~ '%3317%'::text)
         Rows Removed by Filter: 1
 Planning Time: 0.381 ms
 Execution Time: 191.050 ms
(7 rows)


-- GIN index
-- create index on students using GIN (phone_numbers);

                                                       QUERY PLAN
------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..16049.03 rows=100145 width=144) (actual time=3.666..164.750 rows=20 loops=1)
   ->  Seq Scan on students  (cost=0.00..2529.45 rows=100145 width=112) (actual time=0.008..10.191 rows=100145 loops=1)
   ->  Function Scan on unnest un  (cost=0.00..0.13 rows=1 width=32) (actual time=0.001..0.001 rows=0 loops=100145)
         Filter: ((phone_number)::text ~~ '%3317%'::text)
         Rows Removed by Filter: 1
 Planning Time: 0.376 ms
 Execution Time: 164.777 ms
(7 rows)
