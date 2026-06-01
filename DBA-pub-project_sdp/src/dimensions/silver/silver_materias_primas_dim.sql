CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_materias_primas_dim
  CLUSTER BY (ID)
  COMMENT 'Silver SCD1 — raw-materials catalogue dimension. Current state only, deduplicated by ID.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_materias_primas_dim_cdc AS AUTO CDC INTO
  silver.silver_materias_primas_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_materias_primas)
KEYS
  (ID)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
