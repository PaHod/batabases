--------------------------------------------------------------------------------------------------------------
--b. Find user by surname (partial match)
EXPLAIN ANALYZE
SELECT * FROM students WHERE name ~ '50';

-- BEFORE index
                                                  QUERY PLAN
--------------------------------------------------------------------------------------------------------------
 Seq Scan on students  (cost=0.00..2779.81 rows=2089 width=112) (actual time=0.022..28.272 rows=1961 loops=1)
   Filter: ((name)::text ~ '50'::text)
   Rows Removed by Filter: 98184
 Planning Time: 0.216 ms
 Execution Time: 32.328 ms
(5 rows)

--B-Tree index


 Seq Scan on students  (cost=0.00..2779.81 rows=2089 width=112) (actual time=0.035..31.661 rows=1961 loops=1)
   Filter: ((name)::text ~ '50'::text)
   Rows Removed by Filter: 98184
 Planning Time: 0.563 ms
 Execution Time: 31.720 ms
(5 rows)



-- Hash index
--create index on students using hash (name);

                                                  QUERY PLAN
--------------------------------------------------------------------------------------------------------------
 Seq Scan on students  (cost=0.00..2779.81 rows=2089 width=112) (actual time=0.019..29.871 rows=1961 loops=1)
   Filter: ((name)::text ~ '50'::text)
   Rows Removed by Filter: 98184
 Planning Time: 0.369 ms
 Execution Time: 29.930 ms
(5 rows)


