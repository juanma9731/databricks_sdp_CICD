CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_turnos(
  CONSTRAINT valid_id_persona EXPECT (ID_PERSONA IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA, ID_PERSONA)
  COMMENT 'Bronze — raw staff shift records from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'workforce'
  )
AS
SELECT
  ID_PERSONA,
  HORA_INICIO,
  HORA_FIN,
  FECHA,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_ods_turnos*.csv',
  schemaHints    => 'ID_PERSONA STRING, HORA_INICIO STRING, HORA_FIN STRING, FECHA DATE'
);
