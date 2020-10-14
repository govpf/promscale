ALTER TABLE SCHEMA_CATALOG.series
    ADD COLUMN delete_epoch BIGINT;

CREATE INDEX series_deleted
    ON SCHEMA_CATALOG.series(delete_epoch, id)
    WHERE delete_epoch IS NOT NULL;
CREATE SEQUENCE SCHEMA_CATALOG.series_id;


-- epoch for deleting series and label_key ids
CREATE TABLE SCHEMA_CATALOG.ids_epoch(
    current_epoch BIGINT NOT NULL,
    last_update_time TIMESTAMPTZ NOT NULL,
    -- force there to only be a single row
    is_unique BOOLEAN NOT NULL DEFAULT true CHECK (is_unique = true),
    UNIQUE (is_unique)
);

INSERT INTO SCHEMA_CATALOG.ids_epoch VALUES (0, now(), true);


-- we're replacing with a procedure, so we need an explicit DROP
DROP FUNCTION SCHEMA_CATALOG.drop_metric_chunks(TEXT, TIMESTAMPTZ);
