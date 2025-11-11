--- Write a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.
select b.booking_id, u.first_name || ' ' || u.last_name AS user_name from airbnb_schema.bookings b JOIN airbnb_schema.users u ON b.user_id = u.user_id WHERE b.status = 'confirmed';

--- Write a query using aLEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
INSERT into airbnb_schema.reviews (review_id, property_id, user_id, rating, comment, created_at) VALUES (gen_random_uuid(), '701fb27b-5b56-4b4a-b156-a6bb24d417f1', '00000000-0000-0000-0000-000000000001', 5, ' Absolutely cool and indeed cozy! It was peaceful and well-furnished!', CURRENT_TIMESTAMP);
SELECT p.name AS property_name, p.location, p.price_per_night, r.rating, r.comment, r.created_at, u.first_name || ' ' || u.last_name as reviewer_name FROM airbnb_schema.properties p LEFT JOIN airbnb_schema.reviews r ON p.property_id = r.property_id LEFT JOIN airbnb_schema.users u ON r.user_id = u.user_id ORDER BY p.name;

--- Write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
select b.booking_id, b.total_price, b.status, b.created_at, u.first_name || ' ' || u.last_name AS guest FROM airbnb_schema.bookings b FULL JOIN airbnb_schema.users u ON b.user_id = u.user_id;