Create EXTENSION IF NOT EXISTS "pgcrypto";

Create DATABASE AirBNB;

Create SCHEMA AirBNB_Schema;

CREATE TYPE role_enum AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status_enum AS ENUM ('pending', 'confirmed', 'cancelled');
CREATE TYPE payment_method_enum AS ENUM ('credit_card', 'paypal', 'bank_transfer');

Create TABLE AirBNB_Schema.users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15) NULL,
    role role_enum NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Create INDEX idx_users_email ON AirBNB_Schema.users(email);

Create TABLE AirBNB_Schema.properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID REFERENCES AirBNB_Schema.users(user_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_properties_host_id ON AirBNB_Schema.properties(host_id);

Create TABLE AirBNB_Schema.bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES AirBNB_Schema.properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES AirBNB_Schema.users(user_id), 
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status booking_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_bookings_property_id ON AirBNB_Schema.bookings(property_id);
CREATE INDEX idx_bookings_user_id ON AirBNB_Schema.bookings(user_id);
CREATE INDEX idx_bookings_status ON AirBNB_Schema.bookings(status);
CREATE INDEX idx_bookings_user_status ON AirBNB_Schema.bookings(user_id, status);

Create TABLE AirBNB_Schema.payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES AirBNB_Schema.bookings(booking_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method_enum NOT NULL
);

CREATE INDEX idx_payments_booking_id ON AirBNB_Schema.payments(booking_id);

Create TABLE AirBNB_Schema.reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES AirBNB_Schema.properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES AirBNB_Schema.users(user_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reviews_property_id ON AirBNB_Schema.reviews(property_id);
CREATE INDEX idx_reviews_user_id ON AirBNB_Schema.reviews(user_id);

CREATE TABLE AirBNB_Schema.messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES AirBNB_Schema.users(user_id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES AirBNB_Schema.users(user_id) ON DELETE CASCADE,
    message_body TEXT NOT NULL, 
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_messages_sender_id ON AirBNB_Schema.messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON AirBNB_Schema.messages(receiver_id);
