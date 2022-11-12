SELECT
      ACCOUNTID         as ACCOUNT_CODE     -- TEXT
    , SYMBOL            as SECURITY_CODE    -- TEXT
    , DESCRIPTION       as SECURITY_NAME    -- TEXT
    , EXCHANGE          as EXCHANGE_CODE    -- TEXT
    , REPORT_DATE       as REPORT_DATE      -- DATE
    , QUANTITY          as QUANTITY         -- NUMBER
    , COST_BASE         as COST_BASE        -- NUMBER
    , POSITION_VALUE    as POSITION_VALUE   -- NUMBER
    , CURRENCY          as CURRENCY_CODE    -- TEXT

FROM {{ source('abc_bank', 'ABC_BANK_POSITION') }}