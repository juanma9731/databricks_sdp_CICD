CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_ventas(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (Fecha)
  COMMENT 'Bronze — raw sales transactions from source volume. Append-only, 821K+ rows.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'revenue'
  )
AS
SELECT
  ID,
  ID_consumicion,
  Fecha,
  Hora,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_ods_ventas*.csv',
  schemaHints    => 'ID INT, ID_consumicion INT, Fecha DATE, Hora STRING'
);
