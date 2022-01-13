/**
 * Chapter 1 - Section 3: Set up initial users, roles and database in Snowflake
 */

-- Explore the default setup of your new account
SHOW ROLES;
SHOW GRANTS TO ROLE <role_name>;

-- **Create and grant your first role
USE ROLE USERADMIN;

CREATE ROLE DBT_EXECUTOR_ROLE
    COMMENT = 'Role for the users running DBT models';

--DROP ROLE DBT_EXECUTOR_ROLE;  -- if you want to drop and redo ;)

GRANT ROLE DBT_EXECUTOR_ROLE TO USER <your_user>;
SHOW GRANTS TO USER <your_user>;

-- ** Grant the privileges to create a database
USE ROLE SYSADMIN;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE DBT_EXECUTOR_ROLE;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DBT_EXECUTOR_ROLE;

SHOW GRANTS TO ROLE DBT_EXECUTOR_ROLE;
--SHOW GRANTS TO ROLE SYSADMIN;

-- ** Create your first database
USE ROLE DBT_EXECUTOR_ROLE;

CREATE DATABASE DATA_ENG_DBT;
SHOW Databases;

-- configuring the default warehouse
USE ROLE SYSADMIN;
ALTER WAREHOUSE "COMPUTE_WH" SET
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    COMMENT = 'Default Warehouse';

-- ** Create a user for the dbt application
CREATE USER IF NOT EXISTS DBT_EXECUTOR
    COMMENT = 'User running DBT commands'
    PASSWORD = 'pick_a_password'
    DEFAULT_WAREHOUSE = 'COMPUTE_WH'
    DEFAULT_ROLE = 'DBT_EXECUTOR_ROLE';

-- assign the executor role to the dbt user
GRANT ROLE DBT_EXECUTOR_ROLE TO USER DBT_EXECUTOR;

-- Switch back to operational role we should be always working with
USE ROLE DBT_EXECUTOR_ROLE;



