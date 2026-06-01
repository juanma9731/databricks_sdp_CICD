CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_inmobiliario(
  CONSTRAINT valid_id_mat EXPECT (ID_MAT IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (ID_MAT)
  COMMENT 'Bronze — raw fixed assets and furniture inventory from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  ID_MAT,
  `Descripción`            AS Descripcion,
  Cantidad,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_inmobiliario*.csv',
  schemaHints    => 'ID_MAT INT, `Descripción` STRING, Cantidad INT'
);
