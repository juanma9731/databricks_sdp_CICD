CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_personal_bar_dim
  CLUSTER BY (NIF)
  COMMENT 'Silver SCD1 — bar staff dimension. Current state only, deduplicated by NIF.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_personal_bar_dim_cdc AS AUTO CDC INTO
  silver.silver_personal_bar_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_personal_bar)
KEYS
  (NIF)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
