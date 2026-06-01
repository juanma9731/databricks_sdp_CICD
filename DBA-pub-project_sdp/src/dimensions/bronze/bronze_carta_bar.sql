CREATE OR REFRESH STREAMING TABLE ${bronze_catalog}.${bronze_schema}.bronze_carta_bar(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (ID)
  COMMENT 'Bronze — raw menu/products catalogue from source volume. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'bronze',
    'domain' = 'master_data'
  )
AS
SELECT
  ID,
  `Descripción`      AS Descripcion,
  `Categoría`        AS Categoria,
  `Tipo de producto` AS Tipo_de_producto,
  Precio,
  Materia_Prima_1,
  Unidades_mat_1,
  Materia_Prima_2,
  Unidades_mat_2,
  Materia_Prima_3,
  Unidades_mat_3,
  current_timestamp()      AS update_date,
  _metadata.file_path      AS _source_file_path
FROM STREAM read_files(
  '${volume_path}/',
  format         => 'csv',
  header         => true,
  pathGlobFilter => '*t_carta_bar*.csv',
  schemaHints    => 'ID INT, `Descripción` STRING, `Categoría` STRING,
                     `Tipo de producto` STRING, Precio DOUBLE,
                     Materia_Prima_1 INT, Unidades_mat_1 INT,
                     Materia_Prima_2 DOUBLE, Unidades_mat_2 DOUBLE,
                     Materia_Prima_3 DOUBLE, Unidades_mat_3 DOUBLE'
);
