CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_costes_personal_dim
  CLUSTER BY (Puesto)
  COMMENT 'Silver SCD1 — staff hourly cost rates dimension. Current state only, deduplicated by Puesto.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_costes_personal_dim_cdc AS AUTO CDC INTO
  silver.silver_costes_personal_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_costes_personal)
KEYS
  (Puesto)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
