/*
 * ** List the files in a stage **
 */
list '@<db>.<schema>.<stage_name>/path/folder/.../'
    PATTERN = '.*[.]parquet';

/*
INFER_SCHEMA(
    LOCATION => '@mystage/path/folder/'
    , FILE_FORMAT => 'my_parquet_format'
    , FILES => '<file_name.parquet>' [, '<another_file>']
)
 */

select *
--select expression as sql_select
--select column_name || ' ' || type || ' ,' as sql_create_table
--SELECT COLUMN_NAME || ' ' || TYPE  || ' as (' || EXPRESSION|| ') ,'   as sql_ext_table
--SELECT GENERATE_COLUMN_DESCRIPTION(ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'table') AS COLUMNS
from table(
  INFER_SCHEMA(
      LOCATION => '@<db>.<schema>.<stage_name>/path/folder/.../'
    , FILE_FORMAT => '<db>.<schema>.<my_parquet_format>'
    , FILES => '<file_name.parquet>'    -- , '<another_file.parquet>'
--  , IGNORE_CASE => TRUE
  )
);
