CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_carta_bar_dim
  CLUSTER BY (ID)
  COMMENT 'Silver SCD1 — menu/products catalogue dimension. Current state only, deduplicated by ID.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_carta_bar_dim_cdc AS AUTO CDC INTO
  silver.silver_carta_bar_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_carta_bar)
KEYS
  (ID)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
