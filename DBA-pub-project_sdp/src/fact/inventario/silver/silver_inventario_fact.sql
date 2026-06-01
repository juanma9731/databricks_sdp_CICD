CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_inventario_fact(
  CONSTRAINT valid_id_material EXPECT (ID_MATERIAL IS NOT NULL)  ON VIOLATION DROP ROW,
  CONSTRAINT valid_fecha EXPECT (FECHA IS NOT NULL)        ON VIOLATION DROP ROW,
  CONSTRAINT valid_cantidad EXPECT (Cantidad >= 0)            ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA)
  COMMENT 'Silver — validated stock inventory movements fact table. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'revenue'
  )
AS
SELECT
  ID_MATERIAL,
  FECHA,
  Cantidad,
  _source_file_path,
  current_timestamp() AS update_date
FROM STREAM(${bronze_catalog}.${bronze_schema}.bronze_inventario);
