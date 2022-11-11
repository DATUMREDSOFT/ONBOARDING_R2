CREATE OR REPLACE  TRIGGER ONBOARDING_R2_VALID_DOC_FECHAS
AFTER INSERT OR UPDATE ON WEB_DOCS_OCR_DATA FOR EACH ROW 
DECLARE 
    V_NUM_ID VARCHAR2(15 CHAR);
    V_ESTADO_AFILIADO VARCHAR2(3 CHAR);
    V_FECHA_EXPEDICION_ID DATE;
    V_FECHA_EXPIRACION DATE;
BEGIN
    SELECT num_id INTO V_NUM_ID FROM DUAL LEFT JOIN BFP_PERSONA ON num_id = :NEW.COD_CLIENTE;
    IF V_NUM_ID IS NOT NULL THEN
        SELECT  ESTADO_AFILIADO INTO V_ESTADO_AFILIADO  FROM  DUAL LEFT JOIN  BFP_PERSONA ON num_id = :NEW.COD_CLIENTE; 
        IF V_ESTADO_AFILIADO = 'ACT' THEN          

            SELECT FECHA_EXPEDICION_ID INTO V_FECHA_EXPEDICION_ID FROM DUAL LEFT JOIN  BFP_PERSONA ON num_id = :NEW.COD_CLIENTE;       
            
            IF  V_FECHA_EXPEDICION_ID IS NOT NULL AND :NEW.DOC_DATEOFISSUE != V_FECHA_EXPEDICION_ID THEN    
                UPDATE BFP_PERSONA SET FECHA_EXPEDICION_ID = :NEW.DOC_DATEOFISSUE WHERE  num_id = :NEW.COD_CLIENTE;                        
            END IF;           
           
            SELECT FECHA_EXPIRACION INTO V_FECHA_EXPIRACION FROM DUAL LEFT JOIN  BFP_PERSONA ON num_id = :NEW.COD_CLIENTE;  
            
            IF  V_FECHA_EXPIRACION IS NOT NULL AND :NEW.DOC_DATEOFEXPIRY != V_FECHA_EXPIRACION THEN    
                UPDATE BFP_PERSONA SET FECHA_EXPIRACION = :NEW.DOC_DATEOFEXPIRY WHERE  num_id = :NEW.COD_CLIENTE;                        
            END IF;
            
 
        END IF;
    END IF;
END;