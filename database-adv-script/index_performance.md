- Identify high-usage columns in your User, Booking, and Property tables (e.g., columns used in WHERE, JOIN, ORDER BY clauses).
    SELECT 
        relname,
        seq_scan,
        idx_scan,
        n_tup_ins,
        n_tup_upd
    FROM pg_stat_all_tables
    WHERE schemaname = 'airbnb_schema';
