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
   f_agrega_correo          NUMBER(2, 0)			:=0;
   f_fecha_expedicion_id	NUMBER(2, 0)			:=0;
   f_fecha_expiracion		NUMBER(2, 0)			:=0;
   f_telefono_find			NUMBER(2, 0)			:=0;
   f_telefono_exist			NUMBER(2, 0)			:=0;
   v_telefono_exist 	    VARCHAR2(20 CHAR)		:=NULL;
   v_num_gestion            NUMBER                  :=NULL;
   v_correo_a_modificar     NUMBER                  :=NULL;
   v_mensaje_gestion 	    VARCHAR2(100 CHAR)		:=NULL;
   f_agrega_telefono		NUMBER(2, 0)			:=0;
   f_modifica_telefono		NUMBER(2, 0)			:=0;
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
                IF v_correo_electronico != :NEW.CORREO_ELECTRONICO AND v_correo_electronico IS NOT NULL THEN
                    f_modifica_correo     :=  1;
                ELSIF v_correo_electronico IS NULL THEN
                    f_agrega_correo       :=  1;
                ELSE
                    f_agrega_correo       :=  0;
                END IF;
                v_correo_electronico    := :NEW.CORREO_ELECTRONICO;
                v_estado_email1         := 'A';
                v_mensaje_gestion       := :NEW.CORREO_ELECTRONICO || ' - ';
            END IF;
          
           --SI RESPONDE 2 EL CORREO A MODIFICAR ES EL CORREO2
            IF v_correo_a_modificar = 2 THEN
                IF v_correo_electronico2 != :NEW.CORREO_ELECTRONICO AND v_correo_electronico2 IS NOT NULL THEN
                    f_modifica_correo     :=  1;
                ELSIF v_correo_electronico IS NULL THEN
                    f_agrega_correo       :=  1;
                ELSE
                    f_agrega_correo       :=  0;
                END IF;
                v_correo_electronico2    := :NEW.CORREO_ELECTRONICO;
                v_estado_email2          := 'A';
                f_modifica_correo        :=  1;
                v_mensaje_gestion       := :NEW.CORREO_ELECTRONICO || ' - ';
            END IF;
             
        
            IF :NEW.DOC_DATEOFISSUE IS NOT NULL AND ( v_fecha_expedicion_id !=  TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YY') OR v_fecha_expedicion_id IS NULL) THEN
                v_fecha_expedicion_id := TO_DATE(:NEW.DOC_DATEOFISSUE,'DD-MM-YY');
                f_fecha_expedicion_id :=1;   
                v_mensaje_gestion    := v_mensaje_gestion || v_fecha_expedicion_id || ' - ';   
            END IF;
            
        
            IF  :NEW.DOC_DATEOFEXPIRY IS NOT NULL AND (v_fecha_expiracion  != TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YY') OR v_fecha_expiracion IS NULL )  THEN
                v_fecha_expiracion := TO_DATE(:NEW.DOC_DATEOFEXPIRY,'DD-MM-YY');
		   		    f_fecha_expiracion :=1;
              v_mensaje_gestion    := v_mensaje_gestion || v_fecha_expiracion || ' - ';
		    END IF;


            /***************************************************************************************
            * INICIA ACTUALIZACION TELEFONO
            ****************************************************************************************/
            UPDATE PA.tel_personas SET   EST_TELEFONO = 'I', ORIGEN_CEL =NULL  WHERE COD_PERSONA = :NEW.COD_CLIENTE and (num_telefono like '7%' OR num_telefono like '8%' OR num_telefono like '6%') AND NUM_TELEFONO !=  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
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

           
           IF NVL(v_num_telefono, ' ') = ' ' THEN   --SE VALIDA SI NO VINO NUMERO DE TELEFONO                       
                IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN --SE VALIDA QUE EL TELEFONO EXISTA AUNQUE SEA EN ESTADO INAC PARA HACER UPDATE DE ESTADO
                     UPDATE PA.tel_personas SET  tip_telefono = 'M', EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
                      f_modifica_telefono	:=1;
                      v_mensaje_gestion    := v_mensaje_gestion ||  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) || ' - ';
                ELSE 
                    INSERT INTO PA.tel_personas
                    (COD_PERSONA, COD_AREA, NUM_TELEFONO, TIP_TELEFONO, TEL_UBICACION, EXTENSION, NOTA, ES_DEFAULT, POSICION, COD_DIRECCION, CONTACTO_DIA, CONTACTO_HORA, FECHA_ADICION, ADICIONADO_POR, FECHA_MODIFICACION, MODIFICADO_POR, EST_TELEFONO, ORIGEN_CEL)
                    VALUES
                    (:NEW.COD_CLIENTE, '503', REPLACE(:NEW.TELEFONO , '503 ', ''), 'M', 'M', NULL, NULL, NULL, 1, NULL, 'CUA', 'CUA', SYSDATE, USER, NULL, NULL, 'A', 'O');
                
                    v_mensaje_gestion    := v_mensaje_gestion ||  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) || ' - ';
                    f_agrega_telefono	:=1;
                END IF;
           ELSE
             IF NVL(v_telefono_exist, ' ') =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) THEN --VALIDO SI EL NUEMRO INGRESADO YA EXISTE PARA HACERLE UPDATE AL CAMPO ORIGEN_CEL
                -- UPDATE PA.tel_personas SET   EST_TELEFONO = 'A', ORIGEN_CEL = 'O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', ''));
                f_modifica_telefono	:=0;
             ELSE -- HAGO UPDATE AL NUMERO
              UPDATE PA.tel_personas SET tip_telefono = 'M',   EST_TELEFONO = 'A', ORIGEN_CEL = 'O',  NUM_TELEFONO =  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) WHERE COD_PERSONA = :NEW.COD_CLIENTE  AND  EST_TELEFONO = 'A' AND tip_telefono='M';
                  f_modifica_telefono	:=1;
                  v_mensaje_gestion    := v_mensaje_gestion ||  TO_CHAR(REPLACE(:NEW.TELEFONO , '503 ', '')) || ' - ';
             END IF;
           END IF; 
           
            /***************************************************************************************
            *  FINALIZA ACTUALIZACION TELEFONO
            ****************************************************************************************/




            UPDATE RE.BFP_PERSONA 
            SET 
                FECHA_EXPEDICION_ID = v_fecha_expedicion_id,  
                FECHA_EXPIRACION = v_fecha_expiracion, 
                ETAPA_INFO_ELECT = 4,
                CORREO_ELECTRONICO = v_correo_electronico, 
                CORREO_ELECTRONICO2= v_correo_electronico2, 
                ESTADO_EMAIL1 = v_estado_email1,
                ESTADO_EMAIL2 = v_estado_email2      
            WHERE  
                NUP = :NEW.COD_CLIENTE; 

         IF (f_fecha_expiracion = 1 OR f_fecha_expedicion_id = 1) AND (f_agrega_correo != 1  AND f_modifica_correo != 1  AND  f_modifica_telefono	!=1  AND   f_agrega_telefono!=1) THEN
               --generar gestion automatica
               GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ', 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    GE.ge_inserta_cat_proc(1,v_num_gestion,null,724,null);
                    
            ELSIF f_agrega_correo = 1 AND f_fecha_expiracion != 1 AND f_fecha_expedicion_id != 1 AND f_modifica_correo != 1 AND  f_modifica_telefono	!=1  AND   f_agrega_telefono!=1  THEN
                GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ', 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    GE.ge_inserta_cat_proc(1,v_num_gestion,null,725,null);
            
            ELSIF f_modifica_correo = 1 AND  f_agrega_correo != 1 AND f_fecha_expiracion != 1 AND f_fecha_expedicion_id != 1  AND  f_modifica_telefono	!=1  AND   f_agrega_telefono!=1 THEN
                  GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ', 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    GE.ge_inserta_cat_proc(1,v_num_gestion,null,726,null);
            ELSIF f_modifica_correo != 1 AND  f_agrega_correo != 1 AND f_fecha_expiracion != 1 AND f_fecha_expedicion_id != 1  AND  f_modifica_telefono	=1  AND   f_agrega_telefono!=1  THEN
                GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ', 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    GE.ge_inserta_cat_proc(1,v_num_gestion,null,728,null);
             ELSIF f_modifica_correo != 1 AND  f_agrega_correo != 1 AND f_fecha_expiracion != 1 AND f_fecha_expedicion_id != 1  AND  f_modifica_telefono	!=1  AND   f_agrega_telefono=1  THEN
                GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ', 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    GE.ge_inserta_cat_proc(1,v_num_gestion,null,727,null);
            ELSIF f_modifica_correo = 1 OR  f_agrega_correo  = 1 OR f_fecha_expiracion  = 1 OR f_fecha_expedicion_id  = 1 OR  f_modifica_telefono	 = 1 OR   f_agrega_telefono=1 THEN
                GE.ge_util01.inserta_gestion(
                    1, :NEW.COD_CLIENTE, 
                    null, 
                    null, 
                    'Actualizaciones Reconocimiento Facial ' || v_mensaje_gestion, 
                    null,
                    623, 'CER', 
                    29, null, 
                    29, null, 
                    null, v_num_gestion,
                    null
                    );
                    
            END IF;



	   END IF;

   	END IF;

   END IF;


   EXCEPTION
   WHEN OTHERS THEN
    raise_application_error(-20091, ' Error al crear registro en BFP_PERSONA.' || sqlerrm);
    RAISE;

END;