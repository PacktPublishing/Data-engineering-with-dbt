/**
 * Chapter 1 - Section 1: A brief introduction to SQL
 */

-- Example of a simple SQL query
-- See 01_02_SQL_Basics.sql for commands to create the table and load sample rows
SELECT ORDER_ID, CUSTOMER_CODE, TOTAL_AMOUNT
FROM ORDERS
WHERE YEAR(ORDER_DATE) = 2022;

