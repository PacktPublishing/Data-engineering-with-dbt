USE ROLE DBT_EXECUTOR_ROLE;

-- ** 1 ** Create the schema for the source data
CREATE SCHEMA PORTFOLIO_TRACKING.SOURCE_DATA;

-- ** 2 ** Create the landing table for ABC_BANK data
CREATE OR REPLACE TABLE PORTFOLIO_TRACKING.SOURCE_DATA.ABC_BANK_POSITION (
     accountID	    TEXT,
     symbol	        TEXT,
     description	TEXT,
     exchange	    TEXT,
     report_date	DATE,
     quantity	    NUMBER(38,0),
     cost_base	    NUMBER(38,5),
     position_value	NUMBER(38,5),
     currency	    TEXT
);

-- ** 3 ** Create the file format to load the data for ABC_BANK
CREATE FILE FORMAT "PORTFOLIO_TRACKING"."SOURCE_DATA".ABC_BANK_CSV_FILE_FORMAT
    TYPE = 'CSV'
        COMPRESSION = 'AUTO'
        FIELD_DELIMITER = ','
        RECORD_DELIMITER = '\n'
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
        TRIM_SPACE = FALSE
        ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
        ESCAPE = 'NONE'
        ESCAPE_UNENCLOSED_FIELD = '\134'
        DATE_FORMAT = 'AUTO'
        TIMESTAMP_FORMAT = 'AUTO'
        NULL_IF = ('\\N')
;

/* ** how to load a file in a stage and from the stage in the landing table
   ** if you have SnowSql installed

USE ROLE DBT_EXECUTOR_ROLE;

CREATE STAGE "PORTFOLIO_TRACKING"."PUBLIC".ABC_BANK COMMENT = 'ABC Bank files';

PUT file:/<path>/ABC_Bank_PORTFOLIO.csv
    @ABC_BANK
;

COPY INTO "PORTFOLIO_TRACKING"."SOURCE_DATA"."ABC_BANK_POSITION"
FROM @ABC_BANK
FILE_FORMAT = '"PORTFOLIO_TRACKING"."SOURCE_DATA"."ABC_BANK_CSV_FILE_FORMAT"'
ON_ERROR = 'ABORT_STATEMENT'
PURGE = TRUE;
*/
