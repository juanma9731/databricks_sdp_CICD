CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_datos_empresa(
  CONSTRAINT valid_cif EXPECT (CIF IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (CIF)
  COMMENT 'Bronze — raw company data from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  CIF,
  Nombre_Sociedad,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_datos_empresa*.csv',
  schemaHints    => 'CIF STRING, Nombre_Sociedad STRING'
);
