-- Users
INSERT INTO AirBNB_Schema.users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Alice', 'Ngugi', 'alice@example.com', 'hashed_pw_1', '1234567890', 'host'),
  ('00000000-0000-0000-0000-000000000002', 'Bob', 'Okoro', 'bob@example.com', 'hashed_pw_2', '0987654321', 'guest'),
  ('00000000-0000-0000-0000-000000000003', 'Clara', 'Müller', 'clara@example.com', 'hashed_pw_3', NULL, 'admin');

-- INSERT INTO airbnb_schema.properties (property_id, host_id, name, description, location, price_per_night)
-- VALUES
--     (gen_random_uuid(), (SELECT user_id FROM airbnb_schema.users WHERE email = 'alice@example.com'), 
--     'Cozy Cottage', 'A cozy cottage in the countryside.', '123 Country Lane, Countryside', 94.00),
--     (gen_random_uuid(), (SELECT user_id FROM airbnb_schema.users WHERE email = 'alice@example.com'),
--     'Mountain Cabin', 'Rustic cabin with fireplace', 'Bavaria, Germany', 120.00);


-- INSERT INTO AirBNB_Schema.bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
-- VALUES
--   (gen_random_uuid(), 
--    (SELECT property_id FROM AirBNB_Schema.properties WHERE name = 'Sunny Apartment'),
--    (SELECT user_id FROM AirBNB_Schema.users WHERE email = 'bob@example.com'),
--    '2025-12-20', '2025-12-25', 425.00, 'confirmed');


-- INSERT INTO AirBNB_Schema.payments (payment_id, booking_id, amount, payment_method)
-- VALUES
--   (gen_random_uuid(), 
--    (SELECT booking_id FROM AirBNB_Schema.bookings WHERE total_price = 425.00),
--    425.00, 'credit_card');


-- INSERT INTO AirBNB_Schema.reviews (review_id, property_id, user_id, rating, comment)
-- VALUES
--   (gen_random_uuid(), 
--    (SELECT property_id FROM AirBNB_Schema.properties WHERE name = 'Sunny Apartment'),
--    (SELECT user_id FROM AirBNB_Schema.users WHERE email = 'bob@example.com'),
--    5, 'Amazing stay! Clean and well-located.');


-- INSERT INTO AirBNB_Schema.messages (message_id, sender_id, receiver_id, message_body)
-- VALUES
--   (gen_random_uuid(),
--    (SELECT user_id FROM AirBNB_Schema.users WHERE email = 'bob@example.com'),
--    (SELECT user_id FROM AirBNB_Schema.users WHERE email = 'alice@example.com'),
--    'Hi Alice, is the apartment available for New Year?');



