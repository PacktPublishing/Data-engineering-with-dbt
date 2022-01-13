/**
 * Chapter 1 - Section 2: SQL basics: core concepts and commands
 */

-- Setup a test DB and schema to create the example table storing information about orders
CREATE DATABASE TEST;
USE DATABASE TEST;

USE SCHEMA TEST.PUBLIC;

-- Example table storing information about orders
CREATE TABLE ORDERS (
    ORDER_ID NUMBER,
    CUSTOMER_CODE TEXT,
    TOTAL_AMOUNT FLOAT,
    ORDER_DATE DATE,
    CURRENCY TEXT DEFAULT 'EUR'
);

-- Insert sample data into the table
insert into ORDERS (ORDER_ID, CUSTOMER_CODE, TOTAL_AMOUNT, ORDER_DATE, CURRENCY)
values (1, 'c123', 123.45, '2022-01-01', 'USD'),
       (2, 'C222', 222.22, '2021-12-20', 'EUR'),
       (3, 'C321', 321.99, '2022-01-03', 'EUR');

-- Delete all if you want to restart with new data
-- DELETE FROM PUBLIC.ORDERS WHERE true;

-- Example of a simple SQL query
-- To create the empty table you can run the commands above
SELECT ORDER_ID, CUSTOMER_CODE, TOTAL_AMOUNT
FROM ORDERS
WHERE YEAR(ORDER_DATE) = 2022;

-- Example view built on top of the order table
CREATE VIEW BIG_ORDERS AS
SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT > 1000;

-- *****

-- Creating sample db and schema
CREATE DATABASE TEST;   -- if not done before
CREATE SCHEMA TEST.SOME_DATA;

-- Sample user and role setup commands
CREATE ROLE DBT_SAMPLE_ROLE;
CREATE USER MY_NAME;		-- Personal user
CREATE USER SAMPLE_SERVICE;	-- Service user
GRANT ROLE DBT_SAMPLE_ROLE TO USER MY_NAME;
GRANT ROLE DBT_SAMPLE_ROLE TO USER SAMPLE_SERVICE;

-- Look what you have after creating the sample db, user and roles
SHOW databases;
SHOW warehouses;
SHOW ROLES;
SHOW GRANTS TO ROLE DBT_SAMPLE_ROLE;
SHOW USERS;

-- Cleanup the sample db, user and roles so the you can create them properly later
DROP DATABASE TEST;
DROP USER MY_NAME;	-- or the name you used previously
DROP USER SAMPLE_SERVICE;
DROP ROLE DBT_SAMPLE_ROLE;


