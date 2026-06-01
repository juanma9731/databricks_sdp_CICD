CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_ventas_fact(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL)    ON VIOLATION DROP ROW,
  CONSTRAINT valid_fecha EXPECT (Fecha IS NOT NULL) ON VIOLATION DROP ROW
)
  CLUSTER BY (Fecha)
  COMMENT 'Silver — validated sales transactions fact table. Append-only, 821K+ rows.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'revenue'
  )
AS
SELECT
  ID,
  ID_consumicion,
  Fecha,
  Hora,
  _source_file_path,
  current_timestamp() AS update_date
FROM STREAM(${bronze_catalog}.${bronze_schema}.bronze_ventas);
