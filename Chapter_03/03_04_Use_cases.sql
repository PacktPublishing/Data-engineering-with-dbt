/**
 * Chapter 3 - Section 4: MODELING USE CASES AND PATTERNS
 */

-- Use the correct role
USE ROLE DBT_EXECUTOR_ROLE;

-- Creating a sample Entity table with a recursive relationship
CREATE OR REPLACE TABLE DATA_ENG_DBT.PUBLIC.Entity as
SELECT * FROM ( VALUES
                    (1, null::Number, 'President'),
                    (2,1,'VP Sales'),
                    (3,1,'VP Tech'),
                    (4,2,'Sales Dir'),
                    (5,3,'Lead Architect'),
                    (6,3,'Software Dev Manager'),
                    (7,6,'Proj Mgr'),
                    (8,6,'Software Eng')
                  ) as v (Entity_KEY, Parent_KEY, Entity_Name);

-- Using a recursive CTE to query the recursive relationship in the Entity table
WITH recursive
    ENTITY_HIERARCHY as (
        SELECT
            Entity_KEY
             , Parent_KEY
             , Entity_Name
             , 1 as level
             , '-' as parent_name
             , Entity_KEY::string as key_path
             , Entity_Name::string as name_path
        FROM DATA_ENG_DBT.PUBLIC.Entity
        WHERE Parent_KEY is null

        UNION ALL

        SELECT
            ENT.Entity_KEY
             , ENT.Parent_KEY
             , ENT.Entity_Name
             , HIER.level + 1 as level
             , HIER.Entity_Name as parent_name
             , HIER.key_path || '-' || ENT.Entity_KEY::string as key_path
             , HIER.name_path  || '-' || ENT.Entity_Name::string as name_path
        FROM DATA_ENG_DBT.PUBLIC.Entity as ENT
                 JOIN ENTITY_HIERARCHY as HIER ON HIER.Entity_KEY = ENT.Parent_KEY
    )
SELECT * FROM ENTITY_HIERARCHY;