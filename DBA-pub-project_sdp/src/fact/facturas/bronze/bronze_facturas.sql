CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_facturas(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA)
  COMMENT 'Bronze — raw expense invoices from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'expenses'
  )
AS
SELECT
  ID,
  ID_MATERIA_PRIMA,
  importe,
  FECHA,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_ods_facturas*.csv',
  schemaHints    => 'ID INT, ID_MATERIA_PRIMA INT, importe DOUBLE, FECHA DATE'
);
