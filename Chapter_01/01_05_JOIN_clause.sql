/**
 * Chapter 1 - Section 5: SQL JOIN – how to put different data together
 */

-- ** SET UP the Orders and Customers tables
USE SCHEMA PUBLIC;

-- Example table storing information about orders
CREATE TABLE WEB_ORDER (
    ORDER_ID NUMBER,
    ORDER_PLACED_BY TEXT,
    ORDER_VALUE FLOAT
);

-- Insert sample data into the table
insert into WEB_ORDER (ORDER_ID, ORDER_PLACED_BY, ORDER_VALUE)
values (1, '123', 123.45),
       (2, 'C222', 222.22),
       (3, '321', 321.99);

-- Create the customer table
CREATE TABLE CUSTOMER (
    CUSTOMER_ID TEXT,
    CUSTOMER_NAME TEXT,
    ADDRESS TEXT
);

-- Insert sample data in the customer table
insert into CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, ADDRESS)
values
       ('123', 'Big Buyer LLP',	'Nice place road, 00100 SOMEWHERE'),
       ('C222', 'Some customer', 'A place')
;

-- Insert "duplicated" customers with the same 123 code
insert into CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, ADDRESS)
values
    ('123', 'Another Customer',	'Some road, 10250 SOME PLACE'),
    ('123', 'A third customer',	'No way road, 20100 NOWHERE')
;

--DELETE FROM CUSTOMER where true;

-- ** Try out the join between the two tables with different data in them
SELECT *
FROM web_order
JOIN customer ON ORDER_PLACED_BY = CUSTOMER_ID;

-- ** Visual representation of JOIN results using sets
SELECT *
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
LEFT OUTER JOIN "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
     ON C_CUSTKEY = O_CUSTKEY
WHERE C_CUSTKEY is NULL;
