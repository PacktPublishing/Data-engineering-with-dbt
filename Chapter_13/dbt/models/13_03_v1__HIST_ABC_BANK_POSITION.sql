
{{ save_history(
    input_rel = ref('STG_ABC_BANK_POSITION'), 
    key_column = 'POSITION_HKEY',
    diff_column = 'POSITION_HDIFF',
) }}
    -- load_ts_column = 'LOAD_TS_UTC',
    -- input_filter_expr = 'true',
    -- history_filter_expr = 'true',
    -- high_watermark_column = none,
    -- high_watermark_test = '>=',
    -- order_by_expr = 'POSITION_HKEY'

 