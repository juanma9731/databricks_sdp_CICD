CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_costes_personal(
  CONSTRAINT valid_puesto EXPECT (Puesto IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (Puesto)
  COMMENT 'Bronze — raw staff hourly cost rates from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  Puesto,
  Sueldo_hora,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_costes_personal*.csv',
  schemaHints    => 'Puesto STRING, Sueldo_hora DOUBLE'
);
