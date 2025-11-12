After testing the partition performance, we have:
                                                                QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on bookings_2025 bookings_partitioned  (cost=4.17..11.29 rows=1 width=100) (actual time=1.921..1.923 rows=2.00 loops=1)
   Recheck Cond: (status = 'confirmed'::booking_status_enum)
   Filter: (start_date <= '2025-11-21'::date)
   Heap Blocks: exact=1
   Buffers: shared hit=2
   ->  Bitmap Index Scan on idx_bookings_2025_status  (cost=0.00..4.17 rows=3 width=0) (actual time=0.033..0.033 rows=2.00 loops=1)
         Index Cond: (status = 'confirmed'::booking_status_enum)
         Index Searches: 1
         Buffers: shared hit=1
 Planning:
   Buffers: shared hit=6
 Planning Time: 8.416 ms
 Execution Time: 4.196 ms
(13 rows)


Result shows:
- Partition pruning is working
- Index on on status is used.
- Query is fast and efficient
- Filter on start_date Applied After Index. PostgreSQL applied this filter after retrieving rows via the index. This can be improved by creating a composite index.

```
CREATE INDEX idx_bookings_2025_status_date ON airbnb_schema.bookings_2025(status, start_date);
```
After creating this index, I noticed that the seq scan is activated again:
```
                                                           QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
 Seq Scan on bookings_2025 bookings_partitioned  (cost=0.00..1.03 rows=2 width=73) (actual time=0.071..0.072 rows=2.00 loops=1)
   Filter: ((start_date <= '2025-11-21'::date) AND (status = 'confirmed'::booking_status_enum))
   Buffers: shared hit=1
 Planning Time: 0.275 ms
 Execution Time: 0.097 ms
(5 rows)
```

To force index, use:
```
SET enable_seqscan = OFF;

EXPLAIN ANALYZE
SELECT * FROM airbnb_schema.bookings_partitioned
WHERE start_date <= '2025-11-21' AND status = 'confirmed';
```

The result shows:
```
airbnb=# SET enable_seqscan = OFF;  # This should be re-enabled because PostgreSQL should be able to choose the best plan dynamically in production.
SET
airbnb=# EXPLAIN ANALYZE SELECT * FROM airbnb_schema.bookings_partitioned WHERE start_date <= '2025-11-21' AND status='confirmed';
                                                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_bookings_2025_status_date on bookings_2025 bookings_partitioned  (cost=0.13..12.17 rows=2 width=73) (actual time=6.509..6.511 rows=2.00 loops=1)
   Index Cond: ((status = 'confirmed'::booking_status_enum) AND (start_date <= '2025-11-21'::date))
   Index Searches: 1
   Buffers: shared hit=1 read=1
 Planning Time: 14.930 ms
 Execution Time: 7.412 ms
(6 rows)
```
Result shows:
- PostgreSQL used the composite index on (status, start_date)
- This allowed it to filter both conditions during the index scan
- No need for post-filtering or bitmap heap access
- Only 2 buffer accesses, and this is extremely efficient. This suggests the index is well-structured and the data is localized.



