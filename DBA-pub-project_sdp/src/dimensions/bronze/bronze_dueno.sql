CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_dueno(
  CONSTRAINT valid_dni EXPECT (DNI IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (DNI)
  COMMENT 'Bronze — raw owner data from source volume (source file: t_dueño.csv). Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  DNI,
  Nombre,
  Apellidos,
  Telefono,
  Correo,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_dueño*.csv',
  schemaHints    => 'DNI STRING, Nombre STRING, Apellidos STRING, Telefono LONG, Correo STRING'
);
