--- Write a query to find all properties where the average rating is greater than 4.0 using a subquery.
select p.name AS property_name, p.location, p.price_per_night FROM airbnb_schema.properties p WHERE p.property_id IN (SELECT r.property_id FROM airbnb_schema.reviews r GROUP BY r.property_id HAVING AVG(r.rating) > 4.0);
--- Write a correlated subquery to find users who have made more than 3 bookings.
select user_id, COUNT(*) AS booking_count FROM airbnb_schema.bookings GROUP BY user_id HAVING COUNT(*) >= 2;
select u.user_id, u.first_name || ' ' || u.last_name AS guest_name, COUNT(b.booking_id) AS booking_count FROM airbnb_schema.users u JOIN airbnb_schema.bookings b ON u.user_id = b.user_id GROUP BY u.user_id, u.first_name, u.last_name HAVING COUNT(b.booking_id) >=2;



