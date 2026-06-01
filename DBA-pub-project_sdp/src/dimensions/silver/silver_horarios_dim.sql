CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_horarios_dim
  CLUSTER BY (dia_semana)
  COMMENT 'Silver SCD1 — opening hours per weekday dimension. Current state only, deduplicated by día_semana.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'master_data'
  );

CREATE FLOW silver_horarios_dim_cdc AS AUTO CDC INTO
  silver.silver_horarios_dim
FROM
  STREAM(${bronze_catalog}.${bronze_schema}.bronze_horarios)
KEYS
  (dia_semana)
SEQUENCE BY
  update_date
STORED AS
  SCD TYPE 1;
