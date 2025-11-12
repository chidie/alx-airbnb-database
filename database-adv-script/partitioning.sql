CREATE TABLE airbnb_schema.bookings_partitioned (
  booking_id UUID NOT NULL,
  user_id UUID NOT NULL,
  property_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id)
) PARTITION BY RANGE (start_date);

CREATE TABLE airbnb_schema.bookings_2024 PARTITION OF airbnb_schema.bookings_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE airbnb_schema.bookings_2025 PARTITION OF airbnb_schema.bookings_partitioned
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


--- Add indexes to the partitioned tables to optimize query performance.
CREATE INDEX idx_bookings_2024_user_id ON airbnb_schema.bookings_2026(user_id);
CREATE INDEX idx_bookings_2025_user_id ON airbnb_schema.bookings_2025(user_id);
CREATE INDEX idx_bookings_2024_created_at ON airbnb_schema.bookings_2026(created_at);
CREATE INDEX idx_bookings_2025_created_at ON airbnb_schema.bookings_2025(created_at);
CREATE INDEX idx_bookings_2024_status ON airbnb_schema.bookings_2026(status);
CREATE INDEX idx_bookings_2025_status ON airbnb_schema.bookings_2025(status);

--- Migrate existing data from the main bookings table to the partitioned bookings_partitioned table.
INSERT INTO airbnb_schema.bookings_partitioned (booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at) SELECT booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at FROM airbnb_schema.bookings WHERE start_date <= '2025-11-21';

--- Test the performance of queries on the partitioned table (e.g., fetching confirmed bookings from 2025).
EXPLAIN ANALYZE
SELECT * FROM airbnb_schema.bookings_partitioned
WHERE start_date >= '2025-01-01' AND status = 'confirmed';

--- Test the performance of queries on the partitioned table (e.g., fetching bookings by date range).
EXPLAIN ANALYZE SELECT * FROM airbnb_schema.bookings_partitioned WHERE start_date <= '2025-11-21' AND status='confirmed';
