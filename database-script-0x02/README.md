# AirBNB Database — Seed (Others) Script

This `seed.sql` file populates the `airbnb` PostgreSQL database with realistic sample data across all major tables. It is designed to simulate real-world usage scenarios for testing, development, and demonstration purposes.

---

## What It Does

The script inserts sample records into the following tables:

- **`users`** — Adds multiple users with different roles (`guest`, `host`, `admin`)
- **`properties`** — Adds properties listed by hosts, including location and pricing
- **`bookings`** — Simulates guest bookings with start/end dates and total price
- **`payments`** — Records payments linked to bookings with payment methods
- **`reviews`** — Adds user reviews for properties with ratings and comments
- **`messages`** — Inserts direct messages between users (e.g., guest ↔ host)

---

## Usage

To run the seed script:

```bash
psql -U postgres -d airbnb -f "database-script-0x02\seed.sql"
