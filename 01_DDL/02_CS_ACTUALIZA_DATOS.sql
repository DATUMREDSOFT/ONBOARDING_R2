ALTER TABLE 
    CS_ACTUALIZA_DATOS
ADD (
    registro_AAD VARCHAR2(1 CHAR),
    usuario_AAD VARCHAR2(10 CHAR)
);

COMMENT ON COLUMN 
    CS_ACTUALIZA_DATOS.registro_AAD 
IS 
    'campo para identificar que es un registro para crear en el AAD';

COMMENT ON COLUMN 
    CS_ACTUALIZA_DATOS.usuario_AAD 
IS 
    'campo servirá para almacenar el código del usuario del afiliado que se creará en el AAD para ingresar a CV';