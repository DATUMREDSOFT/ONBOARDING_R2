create or replace TRIGGER ONBOARDING_R2_ACTUALIZA
AFTER INSERT ON WEB.WEB_DOCS_OCR_DATA FOR EACH ROW 
DECLARE 
   v_num_id_ok 				VARCHAR2(20 CHAR)		:=NULL;
   v_num_id 				VARCHAR2(15 CHAR)		:=NULL;
   v_estado_afiliado 		VARCHAR2(3 CHAR)		:=NULL;
   v_correo_electronico 	VARCHAR2(100 CHAR)		:=NULL;
   v_correo_electronico2 	VARCHAR2(100 CHAR)		:=NULL;
   v_estado_email1 			VARCHAR2(1 CHAR)		:=NULL;
   v_estado_email2 			VARCHAR2(1 CHAR)		:=NULL;
   v_fecha_expedicion_id	DATE					:=NULL;
   v_fecha_expiracion		DATE					:=NULL;
   v_etapa_info_elect 		NUMBER(2, 0)			:=NULL;
   v_num_telefono			VARCHAR2(10 BYTE)	    :=NULL;
   f_modifica_correo        NUMBER(2, 0)			:=0;
   f_fecha_expedicion_id	NUMBER(2, 0)			:=0;
   f_fecha_expiracion		NUMBER(2, 0)			:=0;
   f_telefono_find			NUMBER(2, 0)			:=0;
   f_telefono_exist			NUMBER(2, 0)			:=0;
   v_telefono_exist 	    VARCHAR2(20 CHAR)		:=NULL;

BEGIN
   -- DELETE FROM WEB.LOGS_ONBRD_TEMP;
    
	BEGIN
		SELECT NUP INTO v_num_id FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_num_id := NULL;
      WHEN OTHERS THEN
       	v_num_id := NULL;
    END;
    
    BEGIN
		SELECT NUM_ID INTO v_num_id_ok FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_num_id_ok := NULL;
      WHEN OTHERS THEN
       	v_num_id_ok := NULL;
    END;

   	IF v_num_id IS NOT NULL THEN
   		BEGIN
			SELECT  ESTADO_AFILIADO INTO v_estado_afiliado  FROM  DUAL LEFT JOIN  RE.BFP_PERSONA ON NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
		EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        v_estado_afiliado := NULL;
	      WHEN OTHERS THEN
	       	v_estado_afiliado := NULL;
	    END;

	   IF v_estado_afiliado IS NOT NULL AND v_estado_afiliado = 'ACT'  THEN
       
       
	   		--CORREO ELECTRONICO
	   		BEGIN 
		   		SELECT CORREO_ELECTRONICO INTO v_correo_electronico FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_correo_electronico := NULL;
		      WHEN OTHERS THEN
		       	v_correo_electronico := NULL;
		   	END;
            
		    --CORREO ELECTRONICO 2
		    BEGIN 
		   		SELECT CORREO_ELECTRONICO2 INTO v_correo_electronico2 FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_correo_electronico2 := NULL;
		      WHEN OTHERS THEN
		       	v_correo_electronico2 := NULL;
		   	END;

		    --ESTADO_EMAIL1
		    BEGIN 
		   		SELECT ESTADO_EMAIL1 INTO v_estado_email1 FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_estado_email1 := NULL;
		      WHEN OTHERS THEN
		       	v_estado_email1 := NULL;
		   	END;

		   --ESTADO_EMAIL2
		    BEGIN 
		   		SELECT ESTADO_EMAIL2 INTO v_estado_email2 FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_estado_email2 := NULL;
		      WHEN OTHERS THEN
		       	v_estado_email2 := NULL;
		   	END;

            --INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.CORREO_ELECTRONICO', :NEW.CORREO_ELECTRONICO);  

            IF :NEW.CORREO_ELECTRONICO IS NOT NULL THEN
                IF NVL( v_correo_electronico , ' ')  != :NEW.CORREO_ELECTRONICO AND NVL( v_correo_electronico2 , ' ')  != :NEW.CORREO_ELECTRONICO THEN 
                 IF v_estado_email1 = 'A' OR v_estado_email2 = 'A' THEN 
                    f_modifica_correo := 1;
                 END IF;
                END IF;
            END IF;
            
		    

		  --FECHA_EXPEDICION_ID
		    BEGIN 
		   		SELECT FECHA_EXPEDICION_ID INTO v_fecha_expedicion_id FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_fecha_expedicion_id := NULL;
		      WHEN OTHERS THEN
		       	v_fecha_expedicion_id := NULL;
		   	END;
            
            
            

		    IF :NEW.DOC_DATEOFISSUE IS NOT NULL AND TO_CHAR(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YY'), 'DD-MON-YY') != TO_CHAR(TO_DATE(v_fecha_expedicion_id,'DD-MON-YY'), 'DD-MON-YY') THEN
		   		f_fecha_expedicion_id :=1;
		    END IF;
            

            
		   --FECHA_EXPIRACION
		    BEGIN 
		   		SELECT FECHA_EXPIRACION INTO v_fecha_expiracion FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_fecha_expiracion := NULL;
		      WHEN OTHERS THEN
		       	v_fecha_expiracion := NULL;
		   	END;
            
            

		    IF TO_CHAR(TO_DATE(:NEW.DOC_DATEOFEXPIRY ,'DD-MM-YYYY'), 'DD-MON-YY') != NVL(TO_CHAR(TO_DATE(v_fecha_expiracion,'DD-MON-YY'), 'DD-MON-YY'), ' ')  THEN
		   		f_fecha_expiracion :=1;
		    END IF;
            
            
            BEGIN		 
            select
                 num_telefono AS TELEFONO INTO v_num_telefono
            from
                PA.tel_personas
            where
                cod_persona = :NEW.COD_CLIENTE
                and est_telefono = 'A'
                and tip_telefono = 'M'
                AND ROWNUM<=1;
                
           EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_num_telefono := NULL;
		      WHEN OTHERS THEN
		       	v_num_telefono := NULL;
		   END;
           
           BEGIN
                SELECT NUM_TELEFONO INTO v_telefono_exist FROM PA.tel_personas WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO = TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_telefono_exist := NULL;
              WHEN OTHERS THEN
                v_telefono_exist := NULL;
            END;
           
           
           IF NVL(v_num_telefono, ' ') = ' ' THEN                          
                IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN
                     UPDATE PA.tel_personas SET   EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
                ELSE
                    INSERT INTO PA.tel_personas
                    (COD_PERSONA, COD_AREA, NUM_TELEFONO, TIP_TELEFONO, TEL_UBICACION, EXTENSION, NOTA, ES_DEFAULT, POSICION, COD_DIRECCION, CONTACTO_DIA, CONTACTO_HORA, FECHA_ADICION, ADICIONADO_POR, FECHA_MODIFICACION, MODIFICADO_POR, EST_TELEFONO, ORIGEN_CEL)
                    VALUES
                    (:NEW.COD_CLIENTE, '503', REPLACE(:NEW.TELEFONO , '503 ', ''), 'M', 'M', NULL, NULL, 'N', 1, NULL, 'CUA', 'HAB', SYSDATE, USER, NULL, NULL, 'A', 'O');
                END IF;
           
           ELSE
            
             IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN
                 UPDATE PA.tel_personas SET   EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
             
             ELSE
             
              UPDATE PA.tel_personas SET  NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')),  EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE  AND  EST_TELEFONO = 'A' AND tip_telefono='M';
              
           
             END IF;
           END IF; 
          
            
            
            
            UPDATE RE.BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO, FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'),  FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE; 
            
        

	   END IF;

   	END IF;

   EXCEPTION
   WHEN OTHERS THEN
     raise_application_error(-20091, ' Error al crear registro en BFP_PERSONA.' || sqlerrm);
     RAISE;
   NULL;

END;
