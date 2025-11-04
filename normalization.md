# Database Normalization to Third Normal Form (3NF)

## Objective
To apply normalization principles to the given database schema (User, Property, Booking, Payment, Review, Message) to ensure it meets the requirements of **Third Normal Form (3NF)** — removing redundancy, ensuring dependency correctness, and improving data integrity.

---

## Step 1: Understanding Normal Forms

### First Normal Form (1NF)
A table is in 1NF if:
- All attributes contain **atomic (indivisible)** values.
- Each record is **unique** (no duplicate rows).
- There are **no repeating groups** or arrays.

### Second Normal Form (2NF)
A table is in 2NF if:
- It is already in 1NF.
- All **non-key attributes** depend **entirely on the primary key** (no partial dependency).

### Third Normal Form (3NF)
A table is in 3NF if:
- It is already in 2NF.
- There are **no transitive dependencies**, i.e., no non-key attribute depends on another non-key attribute.

---

## Step 2: Review of the Original Schema

### Entities
1. **User**
2. **Property**
3. **Booking**
4. **Payment**
5. **Review**
6. **Message**

---

## Step 3: Normalization Analysis

### 1. User Table

| Attribute | Key | Notes |
|------------|-----|-------|
| user_id | PK | Unique identifier |
| first_name, last_name | Non-key | Atomic and depend solely on user_id |
| email | Unique | Depends on user_id |
| password_hash | Non-key | Depends on user_id |
| phone_number | Non-key | Optional, atomic |
| role | Non-key | Enum (guest, host, admin) |
| created_at | Non-key | Depends only on user_id |

✅ **Status:** In 3NF (no repeating groups, partial, or transitive dependencies).

---

### 2. Property Table

| Attribute | Key | Notes |
|------------|-----|-------|
| property_id | PK | Unique identifier |
| host_id | FK | References User(user_id) |
| name, description, location, pricepernight | Non-key | Depend only on property_id |
| created_at, updated_at | Non-key | Depend only on property_id |

✅ **Status:** In 3NF.  
All attributes depend only on property_id, and `host_id` correctly references the host user.

---

### 3. Booking Table

| Attribute | Key | Notes |
|------------|-----|-------|
| booking_id | PK | Unique identifier |
| property_id | FK | References Property(property_id) |
| user_id | FK | References User(user_id) |
| start_date, end_date, total_price, status | Non-key | Depend only on booking_id |
| created_at | Non-key | Depends on booking_id |

✅ **Status:** In 3NF.  
No redundancy, and all non-key attributes depend directly on booking_id.

---

### 4. Payment Table

| Attribute | Key | Notes |
|------------|-----|-------|
| payment_id | PK | Unique identifier |
| booking_id | FK | References Booking(booking_id) |
| amount, payment_date, payment_method | Non-key | Depend only on payment_id |

✅ **Status:** In 3NF.  
Each payment is tied to a single booking; no partial or transitive dependencies.

---

### 5. Review Table

| Attribute | Key | Notes |
|------------|-----|-------|
| review_id | PK | Unique identifier |
| property_id | FK | References Property(property_id) |
| user_id | FK | References User(user_id) |
| rating, comment, created_at | Non-key | Depend only on review_id |

✅ **Status:** In 3NF.  
No redundancy. Ratings and comments depend only on the review record.

---

### 6. Message Table

| Attribute | Key | Notes |
|------------|-----|-------|
| message_id | PK | Unique identifier |
| sender_id | FK | References User(user_id) |
| recipient_id | FK | References User(user_id) |
| message_body, sent_at | Non-key | Depend only on message_id |

✅ **Status:** In 3NF.  
No transitive dependency (sender and recipient are both user references).

---

## Step 4: Adjustments (if needed)

The original schema is already well normalized, but here are **minor refinements** that strengthen 3NF compliance and maintain data quality:

1. **Role Enumeration Normalization (Optional)**
   - You may store roles in a separate table if role management becomes complex.
   - Example:
     ```sql
     Table Role {
       role_id INT [pk]
       role_name VARCHAR [unique]
     }
     ```
     and then reference it in `User(role_id)` instead of using ENUM.

2. **Payment Method Enumeration (Optional)**
   - Similarly, `payment_method` can be stored in a `PaymentMethod` lookup table for flexibility.

---

## Step 5: Final Verification

| Table | 1NF | 2NF | 3NF | Notes |
|--------|-----|-----|-----|-------|
| User | ✅ | ✅ | ✅ | All atomic, no dependencies |
| Property | ✅ | ✅ | ✅ | Clean host relationship |
| Booking | ✅ | ✅ | ✅ | No transitive dependency |
| Payment | ✅ | ✅ | ✅ | Fully normalized |
| Review | ✅ | ✅ | ✅ | No redundancy |
| Message | ✅ | ✅ | ✅ | Clean sender-recipient relationship |

---

## ✅ Conclusion

The database design satisfies **Third Normal Form (3NF)**:
- All attributes are atomic and depend solely on their table’s primary key.
- There are no repeating groups, partial dependencies, or transitive dependencies.
- Referential integrity is maintained through proper foreign keys.

Optional improvements (Role and PaymentMethod tables) can be made for scalability, but the schema as designed is **fully normalized to 3NF**.
