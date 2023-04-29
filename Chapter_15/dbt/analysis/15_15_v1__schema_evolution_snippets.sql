/*
 * Single model joining the multiple sources from schema evolution.
 * As each source could provide more than one version for each key
 * we use a second time the current_from_history macro to keep only the latest.
 */

WITH
current_from_old_histories as (
    SELECT * FROM {{ ref('REF_XXX_old_curr') }}
),
current_from_history as (
  {{ current_from_history(
    history_rel = ref(' HIST_XXX_Vn'),
    key_column = 'XXX_HKEY'
  ) }}
),
all_current as (
    SELECT * FROM current_from_history
    UNION ALL
    SELECT * FROM current_from_old_histories
)

{{ current_from_history(
    history_rel ='all_current',
    key_column = 'XXX_HKEY'
) }}
