create or replace TRIGGER ONBOARDING_R2_ACTUALIZA
AFTER INSERT OR UPDATE ON WEB.WEB_DOCS_OCR_DATA FOR EACH ROW 
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

  --actualiza datos
    v_ID_ACTUALIZACION NUMBER :=0;
    v_FECHA_ACTUALIZACION DATE :=SYSDATE;
    v_TIPO_DOCUMENTO_AD VARCHAR2(5 BYTE) :=NULL;
    v_NIT VARCHAR2(14 BYTE) :=NULL;
    v_FECHA_NACIMIENTO_AD DATE :=NULL;
    v_NUP VARCHAR2(12 BYTE) :=NULL;
    v_COD_EMPRESA VARCHAR2(5 CHAR) :=NULL;
    v_NOMBRE_NEW VARCHAR2(150 BYTE) :=NULL;
    v_PRIMER_NOMBRE_NEW VARCHAR2(30 BYTE) :=NULL;
    v_SEGUNDO_NOMBRE_NEW VARCHAR2(30 BYTE) :=NULL;
    v_PRIMER_APELLIDO_NEW VARCHAR2(20 BYTE) :=NULL;
    v_SEGUNDO_APELLIDO_NEW VARCHAR2(20 BYTE) :=NULL;
    v_APELLIDO_CASADA_NEW VARCHAR2(20 BYTE) :=NULL;
    v_TELEFONO1_NEW VARCHAR2(12 BYTE) :=NULL;
    v_TIPO_DOCUMENTO_NEW NUMBER :=0;
    v_NUMERO_DOCUMENTO_NEW VARCHAR2(20 BYTE) :=NULL;
    v_FECHA_NACIMIENTO_NEW DATE :=NULL;
    v_CORREO1_NEW VARCHAR2(100 BYTE) :=NULL;
    v_CORREO2_NEW VARCHAR2(100 BYTE)            :=NULL;
    v_ESTADO NUMBER                             :=4;
    v_ADICIONADO_POR VARCHAR2(50 BYTE)          :=USER;
    v_FECHA_INGRESADO DATE                      :=SYSDATE;
    v_FUENTE VARCHAR2(20 BYTE)                  :='BFP_PERSONA';
   	v_registro_AAD VARCHAR2(1 CHAR)             :='S' ;
    v_usuario_AAD VARCHAR2(10 CHAR)             :=NULL;

BEGIN
    DELETE FROM WEB.LOGS_ONBRD_TEMP;
    
	BEGIN
		SELECT NUP INTO v_num_id FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_num_id := NULL;
      WHEN OTHERS THEN
       	v_num_id := NULL;
    END;
    
    BEGIN
		SELECT NUM_ID INTO v_num_id_ok FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_num_id_ok := NULL;
      WHEN OTHERS THEN
       	v_num_id_ok := NULL;
    END;

   	IF v_num_id IS NOT NULL THEN
   		BEGIN
			SELECT  ESTADO_AFILIADO INTO v_estado_afiliado  FROM  DUAL LEFT JOIN  BFP_PERSONA ON NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
		EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        v_estado_afiliado := NULL;
	      WHEN OTHERS THEN
	       	v_estado_afiliado := NULL;
	    END;

	   IF v_estado_afiliado IS NOT NULL AND v_estado_afiliado = 'ACT'  THEN
       
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.COD_CLIENTE', :NEW.COD_CLIENTE);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_estado_afiliado', v_estado_afiliado);
        
           
	   		--CORREO ELECTRONICO
	   		BEGIN 
		   		SELECT CORREO_ELECTRONICO INTO v_correo_electronico FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_correo_electronico := NULL;
		      WHEN OTHERS THEN
		       	v_correo_electronico := NULL;
		   	END;
            
		    --CORREO ELECTRONICO 2
		    BEGIN 
		   		SELECT CORREO_ELECTRONICO2 INTO v_correo_electronico2 FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_correo_electronico2 := NULL;
		      WHEN OTHERS THEN
		       	v_correo_electronico2 := NULL;
		   	END;

		    --ESTADO_EMAIL1
		    BEGIN 
		   		SELECT ESTADO_EMAIL1 INTO v_estado_email1 FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_estado_email1 := NULL;
		      WHEN OTHERS THEN
		       	v_estado_email1 := NULL;
		   	END;

		   --ESTADO_EMAIL2
		    BEGIN 
		   		SELECT ESTADO_EMAIL2 INTO v_estado_email2 FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_estado_email2 := NULL;
		      WHEN OTHERS THEN
		       	v_estado_email2 := NULL;
		   	END;

            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.CORREO_ELECTRONICO', :NEW.CORREO_ELECTRONICO);  
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_correo_electronico',v_correo_electronico);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_correo_electronico2',v_correo_electronico2);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_estado_email1',v_estado_email1);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_estado_email2',v_estado_email2);
            

            IF :NEW.CORREO_ELECTRONICO IS NOT NULL THEN
                IF NVL( v_correo_electronico , ' ')  != :NEW.CORREO_ELECTRONICO AND NVL( v_correo_electronico2 , ' ')  != :NEW.CORREO_ELECTRONICO THEN 
                 IF v_estado_email1 = 'A' OR v_estado_email2 = 'A' THEN 
                    f_modifica_correo := 1;
                 END IF;
                END IF;
            END IF;
            
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'f_modifica_correo',f_modifica_correo);
            
            

		    

		  --FECHA_EXPEDICION_ID
		    BEGIN 
		   		SELECT FECHA_EXPEDICION_ID INTO v_fecha_expedicion_id FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_fecha_expedicion_id := NULL;
		      WHEN OTHERS THEN
		       	v_fecha_expedicion_id := NULL;
		   	END;
            
            
            

		    IF :NEW.DOC_DATEOFISSUE IS NOT NULL AND TO_CHAR(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YY'), 'DD-MON-YY') != TO_CHAR(TO_DATE(v_fecha_expedicion_id,'DD-MON-YY'), 'DD-MON-YY') THEN
		   		f_fecha_expedicion_id :=1;
		    END IF;
            
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.DOC_DATEOFISSUE',:NEW.DOC_DATEOFISSUE);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.DOC_DATEOFISSUE PARSER',TO_CHAR(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'));
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'f_fecha_expedicion_id PARSER',TO_CHAR(TO_DATE(v_fecha_expedicion_id,'DD-MON-YY')));
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'f_fecha_expedicion_id',f_fecha_expedicion_id);
            
            
		   --FECHA_EXPIRACION
		    BEGIN 
		   		SELECT FECHA_EXPIRACION INTO v_fecha_expiracion FROM BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_fecha_expiracion := NULL;
		      WHEN OTHERS THEN
		       	v_fecha_expiracion := NULL;
		   	END;
            
            
            
          

		    IF TO_CHAR(TO_DATE(:NEW.DOC_DATEOFEXPIRY ,'DD-MM-YYYY'), 'DD-MON-YY') != NVL(TO_CHAR(TO_DATE(v_fecha_expiracion,'DD-MON-YY'), 'DD-MON-YY'), ' ')  THEN
		   		f_fecha_expiracion :=1;
		    END IF;
            
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.DOC_DATEOFEXPIRY',:NEW.DOC_DATEOFEXPIRY);
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':NEW.DOC_DATEOFEXPIRY PARSER',TO_CHAR(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'));
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'v_fecha_expiracion PARSER',TO_CHAR(TO_DATE(v_fecha_expiracion,'DD-MON-YY')));
            INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'f_fecha_expiracion',f_fecha_expiracion);
            
   
            IF f_modifica_correo = 1 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =0 THEN
		    	UPDATE BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO, ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    END IF;
            
            IF f_modifica_correo = 1 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =0 THEN
		    	UPDATE BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO,   FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    END IF;
            
            IF f_modifica_correo = 1 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO,  FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    END IF;
            
            IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =0 THEN
		    	UPDATE BFP_PERSONA SET  FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'),  ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    END IF;
            
            IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	
		    END IF;
        
           
		    IF f_modifica_correo = 1 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO, FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'),  FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE; 
		    END IF;

		    IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET   FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YYYY'), 'DD-MON-YY'),  FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4   WHERE  NUP = :NEW.COD_CLIENTE;
		    	
		    END IF;

		    IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET    FECHA_EXPIRACION = TO_DATE(TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YYYY'), 'DD-MON-YY'), ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	
		    END IF;

		   IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =0 THEN
		    	UPDATE BFP_PERSONA SET  ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	
		    END IF;


		   BEGIN
			 
            select
                 num_telefono AS TELEFONO INTO v_num_telefono
            from
                tel_personas
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
                SELECT NUM_TELEFONO INTO v_telefono_exist FROM TEL_PERSONAS WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO = TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_telefono_exist := NULL;
              WHEN OTHERS THEN
                v_telefono_exist := NULL;
            END;
           
           
           IF NVL(v_num_telefono, ' ') = ' ' THEN                          
                IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN
                     UPDATE TEL_PERSONAS SET   EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
                ELSE
                    INSERT INTO TEL_PERSONAS
                    (COD_PERSONA, COD_AREA, NUM_TELEFONO, TIP_TELEFONO, TEL_UBICACION, EXTENSION, NOTA, ES_DEFAULT, POSICION, COD_DIRECCION, CONTACTO_DIA, CONTACTO_HORA, FECHA_ADICION, ADICIONADO_POR, FECHA_MODIFICACION, MODIFICADO_POR, EST_TELEFONO, ORIGEN_CEL)
                    VALUES
                    (:NEW.COD_CLIENTE, '503', REPLACE(:NEW.TELEFONO , '503 ', ''), 'M', 'M', NULL, NULL, 'N', 1, NULL, 'CUA', 'HAB', SYSDATE, USER, NULL, NULL, 'A', 'O');
                END IF;
           
           ELSE
           
            UPDATE TEL_PERSONAS SET   EST_TELEFONO = 'I' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO = v_num_telefono;
            
             IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN
                 UPDATE TEL_PERSONAS SET   EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
            ELSE
                INSERT INTO TEL_PERSONAS
                (COD_PERSONA, COD_AREA, NUM_TELEFONO, TIP_TELEFONO, TEL_UBICACION, EXTENSION, NOTA, ES_DEFAULT, POSICION, COD_DIRECCION, CONTACTO_DIA, CONTACTO_HORA, FECHA_ADICION, ADICIONADO_POR, FECHA_MODIFICACION, MODIFICADO_POR, EST_TELEFONO, ORIGEN_CEL)
                VALUES
                (:NEW.COD_CLIENTE, '503', REPLACE(:NEW.TELEFONO , '503 ', ''), 'M', 'M', NULL, NULL, 'N', 1, NULL, 'CUA', 'HAB', SYSDATE, USER, NULL, NULL, 'A', 'O');
            END IF;
            
           
           END IF;
          
        

	   END IF;

   	END IF;

   EXCEPTION
   WHEN OTHERS THEN
   NULL;

END;
