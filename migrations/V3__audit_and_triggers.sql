CREATE TABLE audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    operation VARCHAR(20) NOT NULL,
    record_id BIGINT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100) DEFAULT CURRENT_USER,
    old_data JSONB,
    new_data JSONB
);

CREATE OR REPLACE FUNCTION audit_users_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (
            table_name, operation, record_id, old_data
        )
        VALUES (
            TG_TABLE_NAME, TG_OP, OLD.user_id, to_jsonb(OLD)
        );
        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (
            table_name, operation, record_id, old_data, new_data
        )
        VALUES (
            TG_TABLE_NAME, TG_OP, NEW.user_id, to_jsonb(OLD), to_jsonb(NEW)
        );
        RETURN NEW;

    ELSE
        INSERT INTO audit_log (
            table_name, operation, record_id, new_data
        )
        VALUES (
            TG_TABLE_NAME, TG_OP, NEW.user_id, to_jsonb(NEW)
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION audit_users_changes();
