--- Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
select u.user_id, u.first_name || ' ' || u.last_name AS guest_name, COUNT(b.booking_id) AS booking_count FROM airbnb_schema.users u JOIN airbnb_schema.bookings b ON u.user_id = b.user_id GROUP BY u.user_id ORDER BY booking_count DESC;

select user_id, COUNT(*) AS total_bookings FROM airbnb_schema.bookings GROUP BY user_id ORDER BY total_bookings DESC;

--- Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.
SELECT property_id, total_bookings, RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank FROM (SELECT property_id, COUNT(*) AS total_bookings FROM airbnb_schema.bookings GROUP BY property_id) AS booking_counts;
SELECT p.name AS property_name, total_bookings, ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM (
    SELECT property_id, COUNT(*) AS total_bookings
    FROM airbnb_schema.bookings
    GROUP BY property_id
) AS booking_counts
JOIN airbnb_schema.properties p
    ON p.property_id = booking_counts.property_id;