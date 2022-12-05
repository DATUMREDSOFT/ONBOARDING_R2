ALTER TABLE PA.TEL_PERSONAS DROP COLUMN ORIGEN_CEL;
ALTER TABLE CPSAD.CS_ACTUALIZA_DATOS DROP COLUMN registro_AAD;
ALTER TABLE CPSAD.CS_ACTUALIZA_DATOS DROP COLUMN usuario_AAD;

DROP TRIGGER WEB.ONBOARDING_R2_ACTUALIZA;
DROP TRIGGER CPSAD.CS_ACTUALIZA_ONBOARDING_R2;

REVOKE select, insert, update, delete ON PA.TEL_PERSONAS TO WEB;
REVOKE select, insert, update, delete ON RE.BFP_PERSONA TO WEB;
REVOKE select, insert, update, delete ON WEB.WEB_DOCS_OCR_DATA TO RE;
REVOKE select, insert, update, delete ON WEB.WEB_DOCS_OCR_DATA TO CPSAD;
REVOKE select, insert, update, delete ON PA.TEL_PERSONAS TO RE;

REVOKE EXECUTE  ON GE.ge_util01 TO WEB;
REVOKE EXECUTE  ON GE.ge_inserta_cat_proc TO WEB;