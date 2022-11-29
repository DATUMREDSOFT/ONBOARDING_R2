CREATE OR REPLACE TRIGGER "WEB"."ONBOARDING_R2_ACTUALIZA"
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
   v_num_gestion            NUMBER                  :=NULL;
   v_correo_a_modificar     NUMBER                  :=NULL;
BEGIN
   -- DELETE FROM WEB.LOGS_ONBRD_TEMP;

   IF :NEW.ESTADO ='PEN' THEN

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
      

	   		BEGIN 
		   		SELECT 
                    CORREO_ELECTRONICO, 
                    CORREO_ELECTRONICO2, 
                    ESTADO_EMAIL1,
                    ESTADO_EMAIL2,
                    FECHA_EXPEDICION_ID,
                    FECHA_EXPIRACION,
                    decode(decode(estado_email1,'A',1,decode(estado_email2,'A',2)), NULL, 1, decode(estado_email1,'A',1,decode(estado_email2,'A',2)) )
                    INTO 
                        v_correo_electronico, 
                        v_correo_electronico2, 
                        v_estado_email1,
                        v_estado_email2,
                        v_fecha_expedicion_id,
                        v_fecha_expiracion,
                        v_correo_a_modificar   
                FROM 
                    RE.BFP_PERSONA 
                WHERE 
                    NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_correo_electronico := NULL;
                v_correo_electronico2 := NULL;
                v_estado_email1 := NULL;
                v_estado_email2 := NULL;
                v_fecha_expedicion_id := NULL;
                v_fecha_expiracion := NULL;
		      WHEN OTHERS THEN
		       	v_correo_electronico := NULL;
                v_correo_electronico2 := NULL;
                v_estado_email1 := NULL;
                v_estado_email2 := NULL;
                v_fecha_expedicion_id := NULL;
                v_fecha_expiracion := NULL;
		   	END;

		  --SI RESPONDE 1 EL CORREO A MODIFICAR ES EL CORREO1
            IF v_correo_a_modificar = 1 THEN
                v_correo_electronico    := :NEW.CORREO_ELECTRONICO;
                v_estado_email1         := 'A';
                f_modifica_correo       :=     1;
            END IF;
          
           --SI RESPONDE 2 EL CORREO A MODIFICAR ES EL CORREO2
            IF v_correo_a_modificar = 2 THEN
                v_correo_electronico2    := :NEW.CORREO_ELECTRONICO;
                v_estado_email2          := 'A';
                f_modifica_correo        :=  1;
            END IF;


            IF :NEW.DOC_DATEOFISSUE IS NOT NULL AND TO_CHAR(TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YY'), 'DD-MON-YY') != TO_CHAR(TO_DATE(v_fecha_expedicion_id,'DD-MON-YY'), 'DD-MON-YY') THEN
		   		v_fecha_expedicion_id := :NEW.DOC_DATEOFISSUE;
                f_fecha_expedicion_id :=1;
		    END IF;



		    IF TO_CHAR(TO_DATE(:NEW.DOC_DATEOFEXPIRY ,'DD-MM-YYYY'), 'DD-MON-YY') != NVL(TO_CHAR(TO_DATE(v_fecha_expiracion,'DD-MON-YY'), 'DD-MON-YY'), ' ')  THEN
                v_fecha_expiracion := :NEW.DOC_DATEOFEXPIRY;
		   		f_fecha_expiracion :=1;
		    END IF;

            /***************************************************************************************
            * INICIA ACTUALIZACION TELEFONO
            ****************************************************************************************/

            -- CONSULTE TELEFONO PARA ESTE NUP
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
           
            /***************************************************************************************
            *  FINALIZA ACTUALIZACION TELEFONO
            ****************************************************************************************/




            UPDATE RE.BFP_PERSONA 
            SET 
                FECHA_EXPEDICION_ID = TO_DATE(TO_DATE(v_fecha_expedicion_id,'DD-MM-YYYY'), 'DD-MON-YY'),  
                FECHA_EXPIRACION = TO_DATE(TO_DATE(v_fecha_expiracion,'DD-MM-YYYY'), 'DD-MON-YY'), 
                ETAPA_INFO_ELECT = 4,
                CORREO_ELECTRONICO = v_correo_electronico, 
                CORREO_ELECTRONICO2= v_correo_electronico2, 
                ESTADO_EMAIL1 = v_estado_email1,
                ESTADO_EMAIL2 = v_estado_email2      
            WHERE  
                NUP = :NEW.COD_CLIENTE; 
                
              --generar gestion automatica
               GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, null, 
                    'Actualizaciones Reconocimiento Facial', 'Actualizaciones Reconocimiento Facial', 
                    623, 'CER', 
                    29, null, 
                    76, null, 
                    null, v_num_gestion,
                    null
                    );
            
                -- generar categoria
               -- GE.ge_inserta_cat_proc(1,v_num_gestion,null,186,null);



	   END IF;

   	END IF;

   END IF;


   EXCEPTION
   WHEN OTHERS THEN
    raise_application_error(-20091, ' Error al crear registro en BFP_PERSONA.' || sqlerrm);
    RAISE;
   NULL;

END;