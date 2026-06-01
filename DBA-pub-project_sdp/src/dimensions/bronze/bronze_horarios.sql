CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_horarios(
  CONSTRAINT valid_dia_semana EXPECT (dia_semana IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (dia_semana)
  COMMENT 'Bronze — raw opening hours per weekday from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  `día_semana`             AS dia_semana,
  horario_apertura,
  horario_cierre,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_horarios*.csv',
  schemaHints    => '`día_semana` STRING, horario_apertura STRING, horario_cierre STRING'
);
