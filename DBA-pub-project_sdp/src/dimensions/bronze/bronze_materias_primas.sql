CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_materias_primas(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (ID)
  COMMENT 'Bronze — raw raw-materials catalogue from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  ID,
  Descripcion,
  Tipo,
  Medida,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_materias_primas*.csv',
  schemaHints    => 'ID INT, Descripcion STRING, Tipo STRING, Medida STRING'
);
