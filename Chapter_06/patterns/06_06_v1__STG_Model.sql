WITH
src_data as ( … ),
default_record as ( … ),
with_default_record as(
    SELECT * FROM src_data
    UNION ALL
    SELECT * FROM default_record
),
hashed as ( … )
SELECT * FROM hashed
