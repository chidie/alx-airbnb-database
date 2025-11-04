# AirBnB Database Schema

This project defines a relational database schema for an AirBnB-style platform using PostgreSQL. It models the core entities and relationships needed to support users, property listings, bookings, payments, reviews, and messaging with robust constraints, indexing, and ENUM types for scalable and secure data management.

---
## Schema Overview

### Users
Stores guest, host, and admin profiles.
- `user_id` (UUID, PK)
- `email` (UNIQUE)
- `role` (ENUM: guest, host, admin)
- `created_at` (timestamp)

### Properties
Listings hosted by users.
- `property_id` (UUID, PK)
- `host_id` (FK → users)
- `price_per_night`, `location`, `description`

### Bookings
Reservations made by users.
- `booking_id` (UUID, PK)
- `property_id`, `user_id` (FKs)
- `status` (ENUM: pending, confirmed, cancelled)
- `start_date`, `end_date`, `total_price`

### Payments
Linked to bookings.
- `payment_id` (UUID, PK)
- `booking_id` (FK)
- `payment_method` (ENUM: credit_card, paypal, bank_transfer)

### Reviews
Ratings and comments on properties.
- `review_id` (UUID, PK)
- `property_id`, `user_id` (FKs)
- `rating` (CHECK: 1–5)

### Messages
User-to-user communication.
- `message_id` (UUID, PK)
- `sender_id`, `receiver_id` (FKs)
- `message_body`, `sent_at`

---

## Constraints

- **Primary Keys**: UUID-based for global uniqueness
- **Foreign Keys**: Enforce relationships with `ON DELETE CASCADE`
- **NOT NULL**: Required fields across all tables
- **UNIQUE**: Email uniqueness in `users`
- **CHECK**: Rating range (1–5)
- **DEFAULTS**: Auto-generated UUIDs and timestamps
- **ENUM Types**:
  - `role_enum`: guest, host, admin
  - `booking_status_enum`: pending, confirmed, cancelled
  - `payment_method_enum`: credit_card, paypal, bank_transfer

---

## Indexing Strategy

| Table       | Indexed Columns                          |
|-------------|-------------------------------------------|
| `users`     | `email`                                   |
| `properties`| `host_id`                                 |
| `bookings`  | `property_id`, `user_id`, `status`, `(user_id, status)` |
| `payments`  | `booking_id`                              |
| `reviews`   | `property_id`, `user_id`                  |
| `messages`  | `sender_id`, `receiver_id`                |

Indexes are designed to optimize JOINs, filters, and frequent queries.

---

## Setup Instructions

1. **Enable UUID generation**
   ```sql
   CREATE EXTENSION IF NOT EXISTS "pgcrypto";


