CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_dueno_dim
  CLUSTER BY (DNI)
  COMMENT 'Silver SCD1 — owner dimension (source: t_dueño.csv). Current state only, deduplicated by DNI.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_dueno_dim_cdc AS AUTO CDC INTO
  silver.silver_dueno_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_dueno)
KEYS
  (DNI)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
