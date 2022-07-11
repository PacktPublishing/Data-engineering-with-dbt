/**
 * Steps to setup the PRoject tracking project in Snowflake
 */

-- ** 1 - Create the DB (as the DBT_EXECUTOR_ROLE) **
USE ROLE DBT_EXECUTOR_ROLE;

CREATE DATABASE PORTFOLIO_TRACKING
    COMMENT = 'DB for the portfolio tracking project managed with dbt';

-- From initial setup
-- GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DBT_EXECUTOR_ROLE;

-- ** 2 - Drop dbt default project after initial test
DROP SCHEMA "PORTFOLIO_TRACKING"."RZ";

-- ** 3 - Create a user for the PROD environment,
--        if you want it different from the one we already set-up before
USE ROLE USERADMIN;
CREATE USER IF NOT EXISTS DBT_PROD_USER
    COMMENT = 'User running DBT commands in PROD env'
    PASSWORD = 'pick_a_password'
    DEFAULT_WAREHOUSE = 'COMPUTE_WH'
    DEFAULT_ROLE = 'DBT_EXECUTOR_ROLE'
;

GRANT ROLE DBT_EXECUTOR_ROLE TO USER DBT_PROD_USER;

USE ROLE DBT_EXECUTOR_ROLE;