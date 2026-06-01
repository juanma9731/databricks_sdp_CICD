CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_personal_bar(
  CONSTRAINT valid_nif EXPECT (NIF IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (NIF)
  COMMENT 'Bronze — raw bar staff records from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  NIF,
  Nombre,
  Apellidos,
  Fecha_Nacimiento,
  Numero_sec_social,
  IBAN,
  Puesto,
  Fecha_Inicio,
  Fecha_Fin,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_personal_bar*.csv',
  schemaHints    => 'NIF STRING, Nombre STRING, Apellidos STRING,
                     Fecha_Nacimiento DATE, Numero_sec_social STRING,
                     IBAN STRING, Puesto STRING, Fecha_Inicio DATE, Fecha_Fin DATE'
);
