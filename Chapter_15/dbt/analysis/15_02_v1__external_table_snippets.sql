
/* ** Create from "manual" COLUMN definition  ** */
CREATE EXTERNAL TABLE my_ext_table
(
  file_part as (<expression_on_metadata$filename>)
  col1 varchar AS (value:col1::varchar)
)
 PARTITION BY (file_part)
 LOCATION=@mystage/daily/		-- @stage/path
 FILE_FORMAT = my_file_format
 AUTO_REFRESH = FALSE;

/* ** Create from "automated" COLUMN definition  ** */
CREATE EXTERNAL TABLE my_ext_table
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@mystage',
          FILE_FORMAT=>'my_ file _format'
        )
      )
  )
 PARTITION BY (file_part)
 LOCATION=@mystage/daily/		-- @stage/path
 FILE_FORMAT = my_file_format
 AUTO_REFRESH = FALSE;

/* ** Create Ext Table from Delta Lake file format  ** */
CREATE EXTERNAL TABLE my_ext_table (
    -- table definition as above
)
TABLE_FORMAT = DELTA;


