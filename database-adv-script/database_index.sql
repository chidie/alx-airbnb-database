--- Write SQL CREATE INDEX commands to create appropriate indexes for those columns and save them on database_index.sql
--- Users Table Indexes ---
CREATE INDEX idx_users_user_id ON airbnb_schema.users(user_id);
CREATE INDEX idx_users_email ON airbnb_schema.users(email);
CREATE INDEX idx_users_created_at ON airbnb_schema.users(created_at);
CREATE INDEX idx_bookings_user_status ON airbnb_schema.bookings(user_id, status);

--- Bookings Table Indexes ---
CREATE INDEX idx_bookings_user_id ON airbnb_schema.bookings(user_id);
CREATE INDEX idx_bookings_property_id ON airbnb_schema.bookings(property_id);
CREATE INDEX idx_bookings_status ON airbnb_schema.bookings(status);
CREATE INDEX idx_bookings_created_at ON airbnb_schema.bookings(created_at);
CREATE INDEX idx_bookings_start_date ON airbnb_schema.bookings(start_date);

--- Properties Table Indexes ---
CREATE INDEX idx_properties_property_id ON airbnb_schema.properties(property_id);
CREATE INDEX idx_properties_location ON airbnb_schema.properties
CREATE INDEX idx_properties_price ON airbnb_schema.properties(price_per_night);
CREATE INDEX idx_properties_name ON airbnb_schema.properties(name);

--- Measure the query performance before and after adding indexes using EXPLAIN or ANALYZE. Best way to understand this is to 
--- DROP and RE-CREATE one of the indexes above, then run the EXPLAIN ANALYZE on a query that would benefit from that index.
--- To DROP an index, use the following command:
--- DROP INDEX IF EXISTS airbnb_schema.idx_bookings_user_status;
--- To RE-CREATE the index, use the following command:
--- CREATE INDEX idx_bookings_user_status ON airbnb_schema.bookings(user_id, status);
EXPLAIN ANALYZE SELECT * FROM airbnb_schema.bookings WHERE user_id='00000000-0000-0000-0000-000000000002' AND status = 'confirmed';
