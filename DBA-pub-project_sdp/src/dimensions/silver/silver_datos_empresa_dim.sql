CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_datos_empresa_dim
  CLUSTER BY (CIF)
  COMMENT 'Silver SCD1 — company data dimension. Current state only, deduplicated by CIF.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_datos_empresa_dim_cdc AS AUTO CDC INTO
  silver.silver_datos_empresa_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_datos_empresa)
KEYS
  (CIF)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
