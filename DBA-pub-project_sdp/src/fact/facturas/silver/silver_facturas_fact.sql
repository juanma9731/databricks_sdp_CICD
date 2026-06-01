CREATE OR REFRESH STREAMING TABLE ${silver_catalog}.${silver_schema}.silver_facturas_fact(
  CONSTRAINT valid_id EXPECT (ID IS NOT NULL)             ON VIOLATION DROP ROW,
  CONSTRAINT valid_fecha EXPECT (FECHA IS NOT NULL)          ON VIOLATION DROP ROW,
  CONSTRAINT valid_importe EXPECT (importe > 0)                ON VIOLATION DROP ROW
)
  CLUSTER BY (FECHA)
  COMMENT 'Silver — validated expense invoices fact table. Append-only.'
  TBLPROPERTIES (
    'layer'  = 'silver',
    'domain' = 'expenses'
  )
AS
SELECT
  ID,
  ID_MATERIA_PRIMA,
  importe,
  FECHA,
  _source_file_path,
  current_timestamp() AS update_date
FROM STREAM(${bronze_catalog}.${bronze_schema}.bronze_facturas);
