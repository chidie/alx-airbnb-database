After running the query:
```
EXPLAIN ANALYZE SELECT * FROM airbnb_schema.bookings_partitioned WHERE start_date <= '2025-11-21' AND status='confirmed';
```
### The bottleneck Analysis 
- If you see Seq Scan, PostgreSQL is scanning the whole partition.
- If Filter: appears after the scan, it means the index wasn’t used for that condition.
- If Bitmap Heap Scan + Bitmap Index Scan appears, PostgreSQL is using an index but still fetching rows from disk.

An optimization is to create a composite index.
```
CREATE INDEX idx_bookings_status_start_date ON airbnb_schema.bookings_2025(status, start_date);
```

When query invoives join bookings with users and properties as in :
```
EXPLAIN ANALYZE
SELECT b.booking_id, u.first_name, p.name
FROM airbnb_schema.bookings_partitioned b
JOIN airbnb_schema.users u ON b.user_id = u.user_id
JOIN airbnb_schema.properties p ON b.property_id = p.property_id
WHERE b.status = 'confirmed';
```
In this case:
- Look for Hash Join or Nested Loop — if the inner side is large and not indexed, it’s a red flag.
- If Seq Scan appears on users or properties, check for missing indexes.

To optimize this means to ensure these indexes exist:
```
CREATE INDEX idx_bookings_user_id ON airbnb_schema.bookings_2025(user_id);
CREATE INDEX idx_bookings_property_id ON airbnb_schema.bookings_2025(property_id);
CREATE INDEX idx_users_user_id ON airbnb_schema.users(user_id);
CREATE INDEX idx_properties_property_id ON airbnb_schema.properties(property_id);
```

Case 3: For a filter by payment method query like:
```
EXPLAIN ANALYZE
SELECT *
FROM airbnb_schema.payments
WHERE payment_method = 'credit_card';
```
If Seq Scan appears, and the table is large, this will be slow.

Optimization would be to add an index:
```
CREATE INDEX idx_payments_method ON airbnb_schema.payments(payment_method);
```

Additionally, in postgresql.conf, this can be enabled.
```
shared_preload_libraries = 'pg_stat_statements'
```
Then run this query:
```
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
SELECT * FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;
```