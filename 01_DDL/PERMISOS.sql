
--PA
GRANT select, insert, update, delete ON PA.TEL_PERSONAS TO WEB;
GRANT select, insert, update, delete ON PA.TEL_PERSONAS TO RE;

--RE
GRANT select, insert, update, delete ON RE.BFP_PERSONA TO WEB;

--WEB
GRANT select, insert, update, delete ON WEB.WEB_DOCS_OCR_DATA TO RE;

