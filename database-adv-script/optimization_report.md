After running the query in performance.sql, here is the result:
```
                                                                         QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=96.19..98.49 rows=920 width=1120) (actual time=4.753..4.757 rows=4.00 loops=1)
   Sort Key: b.created_at DESC
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=4
   ->  Hash Right Join  (cost=23.47..50.90 rows=920 width=1120) (actual time=3.332..3.349 rows=4.00 loops=1)
         Hash Cond: (pay.booking_id = b.booking_id)
         Buffers: shared hit=4
         ->  Seq Scan on payments pay  (cost=0.00..19.20 rows=920 width=60) (actual time=0.054..0.056 rows=2.00 loops=1)
               Buffers: shared hit=1
         ->  Hash  (cost=23.42..23.42 rows=4 width=1280) (actual time=2.171..2.174 rows=4.00 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               Buffers: shared hit=3
               ->  Hash Join  (cost=12.14..23.42 rows=4 width=1280) (actual time=2.161..2.165 rows=4.00 loops=1)
                     Hash Cond: (p.property_id = b.property_id)
                     Buffers: shared hit=3
                     ->  Seq Scan on properties p  (cost=0.00..10.90 rows=90 width=766) (actual time=0.644..0.645 rows=2.00 loops=1)
                           Buffers: shared hit=1
                     ->  Hash  (cost=12.09..12.09 rows=4 width=530) (actual time=1.467..1.469 rows=4.00 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           Buffers: shared hit=2
                           ->  Hash Join  (cost=1.09..12.09 rows=4 width=530) (actual time=1.440..1.446 rows=4.00 loops=1)
                                 Hash Cond: (u.user_id = b.user_id)
                                 Buffers: shared hit=2
                                 ->  Seq Scan on users u  (cost=0.00..10.70 rows=70 width=478) (actual time=0.109..0.111 rows=3.00 loops=1)
                                       Buffers: shared hit=1
                                 ->  Hash  (cost=1.04..1.04 rows=4 width=68) (actual time=0.616..0.616 rows=4.00 loops=1)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       Buffers: shared hit=1
                                       ->  Seq Scan on bookings b  (cost=0.00..1.04 rows=4 width=68) (actual time=0.100..0.107 rows=4.00 loops=1)
                                             Buffers: shared hit=1
 Planning Time: 31.270 ms
 Execution Time: 13.659 ms
(32 rows)
```

The query retrieved 4 rows in 13.659ms. It joined 4 tables: bookings, users, properties, and payments. PostgreSQL used Hash Joins and Sequential Scans for all tables. The final result was sorted by b.created_at DESC using quicksort.

Hash Right Join: payments -> bookings using booking_id.
payments was scanned sequentially (only 2 rows). Bookings was hashed and matched.

Inefficiencies:
- Seq scans on all tables is OK for small data, bad for large. Indexes should be added.
- Multiple Hash Joins is memory-intensive for large joins. Indexed joins is required.
- No index on created_at. Sort could be faster. This index should be added.

--- Analyze the query’s performance using EXPLAIN and identify any inefficiencies.
--- Refactor the query to reduce execution time, such as reducing unnecessary joins or using indexing.
```
CREATE INDEX idx_bookings_created_at ON airbnb_schema.bookings(created_at);
CREATE INDEX idx_bookings_user_id ON airbnb_schema.bookings(user_id);
CREATE INDEX idx_bookings_property_id ON airbnb_schema.bookings(property_id);
CREATE INDEX idx_payments_booking_id ON airbnb_schema.payments(booking_id);
CREATE INDEX idx_properties_property_id ON airbnb_schema.properties(property_id);
CREATE INDEX idx_users_user_id ON airbnb_schema.users(user_id);

```

After creating these indexes, here are the performance results on same query:
```
QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Nested Loop Left Join  (cost=2.32..56.61 rows=920 width=1120) (actual time=4.293..4.968 rows=4.00 loops=1)
   Buffers: shared hit=9 read=1
   ->  Nested Loop  (cost=0.13..14.52 rows=4 width=1280) (actual time=1.684..1.708 rows=4.00 loops=1)
         Join Filter: (b.property_id = p.property_id)
         Rows Removed by Join Filter: 1
         Buffers: shared hit=3 read=1
         ->  Nested Loop  (cost=0.13..13.38 rows=4 width=530) (actual time=1.609..1.630 rows=4.00 loops=1)
               Join Filter: (b.user_id = u.user_id)
               Rows Removed by Join Filter: 4
               Buffers: shared hit=2 read=1
               ->  Index Scan Backward using idx_bookings_created_at on bookings b  (cost=0.13..12.19 rows=4 width=68) (actual time=1.449..1.459 rows=4.00 loops=1)
                     Index Searches: 1
                     Buffers: shared hit=1 read=1
               ->  Materialize  (cost=0.00..1.04 rows=3 width=478) (actual time=0.037..0.038 rows=2.00 loops=4)
                     Storage: Memory  Maximum Storage: 17kB
                     Buffers: shared hit=1
                     ->  Seq Scan on users u  (cost=0.00..1.03 rows=3 width=478) (actual time=0.102..0.104 rows=3.00 loops=1)
                           Buffers: shared hit=1
         ->  Materialize  (cost=0.00..1.03 rows=2 width=766) (actual time=0.018..0.018 rows=1.25 loops=4)
               Storage: Memory  Maximum Storage: 17kB
               Buffers: shared hit=1
               ->  Seq Scan on properties p  (cost=0.00..1.02 rows=2 width=766) (actual time=0.062..0.062 rows=2.00 loops=1)
                     Buffers: shared hit=1
   ->  Bitmap Heap Scan on payments pay  (cost=2.19..9.32 rows=5 width=60) (actual time=0.631..0.631 rows=0.50 loops=4)
         Recheck Cond: (b.booking_id = booking_id)
         Heap Blocks: exact=2
         Buffers: shared hit=6
         ->  Bitmap Index Scan on idx_payments_booking_id  (cost=0.00..2.19 rows=5 width=0) (actual time=0.379..0.379 rows=0.50 loops=4)
               Index Cond: (booking_id = b.booking_id)
               Index Searches: 4
               Buffers: shared hit=4
 Planning:
   Buffers: shared hit=59 read=3
 Planning Time: 36.206 ms
 Execution Time: 10.740 ms
(35 rows)
```

## Key Improvements:

#### Index scan on bookings.created_at
- PostgreSQL is now using your index to sort bookings by created_at DESC
- This replaces the previous Sort node and avoids scanning the whole table
- Result: faster sorting, lower memory usage

#### Bitmap Index Scan on payments.booking_id
- Efficient lookup of payments for each booking
- Result: avoids full scan of payments, improves join speed


