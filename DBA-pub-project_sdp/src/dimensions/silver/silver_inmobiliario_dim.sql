CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_inmobiliario_dim
  CLUSTER BY (ID_MAT)
  COMMENT 'Silver SCD1 — fixed assets and furniture dimension. Current state only, deduplicated by ID_MAT.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_inmobiliario_dim_cdc AS AUTO CDC INTO
  silver.silver_inmobiliario_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_inmobiliario)
KEYS
  (ID_MAT)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
