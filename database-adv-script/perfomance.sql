--- Write an initial query that retrieves all bookings along with the user details, property details, and payment details

EXPLAIN ANALYZE
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  b.status,
  b.created_at AS booking_created_at,

  u.user_id,
  u.first_name || ' ' || u.last_name AS user_name,
  u.email,
  u.created_at AS user_created_at,

  p.property_id,
  p.name AS property_name,
  p.location,
  p.price_per_night,

  pay.payment_id,
  pay.amount,
  pay.payment_method,
  pay.payment_date AS payment_created_at

FROM airbnb_schema.bookings b
JOIN airbnb_schema.users u ON b.user_id = u.user_id
JOIN airbnb_schema.properties p ON b.property_id = p.property_id
LEFT JOIN airbnb_schema.payments pay ON b.booking_id = pay.booking_id

WHERE b.status = 'confirmed'
AND b.created_at >= '2025-01-01'

ORDER BY b.created_at DESC;

