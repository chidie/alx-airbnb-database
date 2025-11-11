# Database Advanced Scripts (database-adv-script)

This folder contains advanced PostgreSQL scripts and example queries used to analyze and optimize the Airbnb sample database.

Contents
- joins_queries.sql — example JOIN queries (INNER, LEFT, FULL) and a sample INSERT into reviews.
- queries.sql — assorted queries: analytics, maintenance (indexes, partitioning), and EXPLAIN ANALYZE examples.
- other scripts — index/partition creation and migration commands.

Usage
- Open a psql session to the airbnb database:
  psql -U postgres -d airbnb

- Run a script file:
  \i path/to/database-adv-script/queries.sql

Helpful commands
- List tables in schema:
  \dt airbnb_schema.*

- View table structure:
  \d airbnb_schema.bookings

- View index usage:
  SELECT indexrelname, idx_scan FROM pg_stat_user_indexes WHERE schemaname='airbnb_schema' AND relname='bookings';

- Show execution plan and real timings:
  EXPLAIN ANALYZE;

- Subqueries are also contained in the subqueries.sql script.