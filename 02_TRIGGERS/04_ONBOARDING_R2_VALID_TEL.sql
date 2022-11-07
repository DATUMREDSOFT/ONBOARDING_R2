CREATE OR REPLACE  TRIGGER ONBOARDING_R2_VALID_INFO_ELECT4
AFTER INSERT OR UPDATE ON WEB_DOCS_OCR_DATA FOR EACH ROW 
DECLARE 
    V_NUM_ID VARCHAR2(15 CHAR);
    V_ESTADO_AFILIADO VARCHAR2(3 CHAR);
    V_ETAPA_INFO_ELECT NUMBER(2, 0);
    V_TELEFONO_FIND NUMBER(2, 0);
BEGIN

    SELECT num_id INTO V_NUM_ID FROM DUAL LEFT JOIN BFP_PERSONA ON num_id = :NEW.COD_CLIENTE;

    IF V_NUM_ID IS NOT NULL THEN
        SELECT  ESTADO_AFILIADO INTO V_ESTADO_AFILIADO  FROM  DUAL LEFT JOIN  BFP_PERSONA ON num_id = :NEW.COD_CLIENTE; 
        IF V_ESTADO_AFILIADO = 'ACT' THEN    

            SELECT TELEFONO INTO V_TELEFONO_FIND FROM (
                select
                    1 orden,
                    cod_area || ' ' || num_telefono as TELEFONO
                from
                    tel_personas
                where
                    cod_persona = :NEW.COD_CLIENTE
                    and est_telefono = 'A'
                    and tip_telefono = 'M'
                union
                select
                    2 orden,
                    cod_area || ' ' || num_telefono
                from
                    tel_personas
                where
                    cod_persona = :NEW.COD_CLIENTE
                    and est_telefono = 'A'
                    and tip_telefono <> 'M'
                    and substr(num_telefono, 1, 1) <> 2
                order by
                    orden
            );

            IF V_TELEFONO_FIND IS NULL OR V_TELEFONO_FIND = '' THEN

            INSERT INTO TEL_PERSONAS ()

            --INSERT
            
            ELSE IF V_TELEFONO_FIND LIKE %:NEW.TELEFONO% THEN
            --TODO BIEN
            ELSE 
            --UPDATE
            END IF;      
        END IF;
    END IF;
END;