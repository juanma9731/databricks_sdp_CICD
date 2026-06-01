CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_inventario(
  CONSTRAINT valid_id_material EXPECT (ID_MATERIAL IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA)
  COMMENT 'Bronze — raw stock inventory movements from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'revenue'
  )
AS
SELECT
  ID_MATERIAL,
  FECHA,
  Cantidad,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_ods_inventario*.csv',
  schemaHints    => 'ID_MATERIAL INT, FECHA DATE, Cantidad INT'
);
