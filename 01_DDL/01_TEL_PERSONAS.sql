ALTER TABLE 
    TEL_PERSONAS
ADD (
    ORIGEN_CEL VARCHAR2(1 CHAR)
);

COMMENT ON COLUMN 
    TEL_PERSONAS.ORIGEN_CEL 
IS 
    'campo para identificar los números de celulares registrados por onboarding';