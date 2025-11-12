--- This query retrieves a list of confirmed bookings, showing: The booking ID, The guest’s full name, The start and end dates of the booking, The total price
--- It pulls data from two tables: bookings and users.
SELECT b.booking_id, u.first_name || ' ' || u.last_name AS guest_name, b.start_date, b.end_date, b.total_price FROM airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id WHERE b.status = 'confirmed';

--- This query retrieves all confirmed bookings along with the guest's full name and the property description.
SELECT b.booking_id, u.first_name || ' ' || u.last_name AS guest_user, p.description, b.total_price, b.status FROM airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id JOIN airbnb_schema.properties p ON b.property_id=p.property_id WHERE b.status = 'confirmed';

--- This query lists all properties along with their host's full name.
SELECT p.name AS property_name, p.location, p.price_per_night, u.first_name || ' ' || u.last_name AS host_name FROM airbnb_schema.properties p JOIN airbnb_schema.users u ON p.host_id = u.user_id;

--- This query calculates the total amount spent by each guest on confirmed bookings.
SELECT u.first_name || ' ' || u.last_name AS guest_name, SUM(b.total_price) AS total_spent FROM airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id WHERE b.status = 'confirmed' GROUP BY u.user_id;

--- This query retrieves upcoming bookings, showing the booking ID, start and end dates, and the guest's email.
SELECT b.booking_id, b.start_date, b.end_date, u.email AS guest_email FROM airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id WHERE b.start_date >= CURRENT_DATE ORDER BY b.start_date ASC;

--- This query finds bookings with missing property references.
SELECT * FROM airbnb_schema.bookings WHERE property_id is NULL;

--- This query updates the property_id for specific bookings identified by their booking_id.
UPDATE airbnb_schema.bookings SET property_id = '701fb27b-5b56-4b4a-b156-a6bb24d417f1' WHERE booking_id IN ('a5530180-cfda-447d-8544-b6394bb89a18', '5d1f6126-172e-4ef4-a54f-fef5a4b03bc0');

--- This query alters the bookings table to set the property_id column as NOT NULL, ensuring all future records must have a valid property reference.
ALTER TABLE airbnb_schema.bookings ALTER COLUMN property_id SET NOT NULL;

--- To enter into the airbnb database, use the following command:
psql -U postgres -d airbnb

--- To list all tables in the airbnb_schema schema, use the following command:
\dt airbnb_schema.*

--- To view the structure of the bookings table and get to know what indexes were created, use the following command:
select * from pg_indexes where schemaname='airbnb_schema' and tablename='bookings';

--- To view the structure of the bookings table, use the following command:
\d airbnb_schema.bookings

--- This query shows the execution plan and actual performance statistics for retrieving all bookings made by the user with user_id '00000000-0000-0000-0000-000000000003'.
EXPLAIN ANALYZE SELECT * FROM airbnb_schema.bookings WHERE user_id = '00000000-0000-0000-0000-000000000003';

---  This command creates an index on the bookings table for the combination of user_id and property_id columns to optimize query performance for lookups involving these fields.
CREATE INDEX idx_bookings_user_property ON airbnb_schema.bookings(user_id, property_id);

--- This query checks the usage statistics of indexes on the bookings table to see how often they have been utilized.
SELECT relname AS table_name, indexrelname AS index_name, idx_scan AS times_used FROM pg_stat_user_indexes WHERE schemaname = 'airbnb_schema' AND relname = 'bookings';

--- This query shows the execution plan and actual performance statistics for retrieving confirmed bookings along with guest names and booking details.
EXPLAIN ANALYZE SELECT b.booking_id, u.first_name || ' ' || u.last_name AS guest_name, b.start_date, b.end_date, b.total_price FROM airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id WHERE b.status = 'confirmed';

--- This query checks the usage statistics of indexes on the bookings table to see how often they have been utilized.
SELECT indexrelname AS index_name, idx_scan AS times_used FROM pg_stat_user_indexes WHERE schemaname = 'airbnb_schema' AND relname = 'bookings';

--- This command drops the index created on the bookings table for the start_date column.
DROP INDEX IF EXISTS airbnb_schema.idx_bookings_start_date;

--- This command creates a partitioned table for bookings based on the start_date column to improve query performance for date-range queries.
create table airbnb_schema.bookings_partitioned (property_id UUID, user_id UUID, start_date DATE NOT NULL, end_date DATE, total_price NUMERIC, status booking_status_enum, created_at TIMESTAMP, PRIMARY KEY (start_date)) PARTITION BY RANGE (start_date);

--- This command creates a partition for the year 2025 in the bookings_partitioned table.
create table airbnb_schema.bookings_2025 PARTITION OF airbnb_schema.bookings_partitioned FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

--- This command migrates existing bookings from the main bookings table to the new partitioned bookings_partitioned table for the year 2025.
INSERT INTO airbnb_schema.bookings_partitioned (
  booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at
)
SELECT 
  booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at
FROM airbnb_schema.bookings
WHERE start_date >= '2025-01-01' AND start_date < '2026-01-01';

--- This query retrieves all possible values from the payment_method_enum enumeration type.
SELECT unnest(enum_range(NULL::payment_method_enum));



--- This command removes the existing primary key constraint from the bookings_partitioned table.
ALTER TABLE airbnb_schema.bookings_partitioned DROP CONSTRAINT bookings_partitioned_pkey;
 
--- This command adds a primary key constraint to the bookings_partitioned table on the booking_id column.
ALTER TABLE airbnb_schema.bookings_partitioned ADD PRIMARY KEY (booking_id);

--- This query lists all constraints on the bookings_partitioned table to verify the primary key change.
select conname FROM pg_constraint WHERE conrelid = 'airbnb_schema.bookings_partitioned'::regclass;