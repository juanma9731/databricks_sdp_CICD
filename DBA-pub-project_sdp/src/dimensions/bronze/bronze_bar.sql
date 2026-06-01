CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_bar(
  CONSTRAINT valid_nombre_bar EXPECT (Nombre_bar IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (Nombre_bar)
  COMMENT 'Bronze — raw bar/venue master data from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  Nombre_bar,
  Ciudad,
  Calle,
  Numero,
  Longitud,
  Latitud,
  Aforo,
  Telefono,
  URL,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_bar*.csv',
  schemaHints    => 'Nombre_bar STRING, Ciudad STRING, Calle STRING, Numero INT,
                     Longitud DOUBLE, Latitud DOUBLE, Aforo INT, Telefono LONG, URL STRING'
);
