CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_bar_dim
  CLUSTER BY (Nombre_bar)
  COMMENT 'Silver SCD1 — bar/venue dimension. Current state only, deduplicated by Nombre_bar.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_bar_dim_cdc AS AUTO CDC INTO
  silver.silver_bar_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_bar)
KEYS
  (Nombre_bar)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
