CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_turnos_fact(
  CONSTRAINT valid_id_persona EXPECT (ID_PERSONA IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_fecha EXPECT (FECHA IS NOT NULL)      ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA, ID_PERSONA)
  COMMENT 'Silver — validated staff shift records fact table. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'workforce'
  )
AS
SELECT
  ID_PERSONA,
  HORA_INICIO,
  HORA_FIN,
  FECHA,
  _source_file_path,
  current_timestamp() AS update_date
FROM STREAM(${bronze_catalog}.${bronze_schema}.bronze_turnos);
