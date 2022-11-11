CREATE OR REPLACE TRIGGER ONBOARDING_R2_ACTUALIZA
AFTER INSERT OR UPDATE ON WEB.WEB_DOCS_OCR_DATA FOR EACH ROW 
DECLARE 
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
	BEGIN
		SELECT NUM_ID INTO v_num_id FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE AND ROWNUM <=1;
	EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_num_id := NULL;
      WHEN OTHERS THEN
       	v_num_id := NULL;
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
		   
		   
		    IF v_correo_electronico != :NEW.CORREO_ELECTRONICO AND v_correo_electronico2 != :NEW.CORREO_ELECTRONICO THEN 
		   	 IF v_estado_email1 ='A' OR v_estado_email2 ='A' THEN 
		   		f_modifica_correo := 1;
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
		   
		    IF :NEW.DOC_DATEOFISSUE != v_fecha_expedicion_id THEN
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
		   
		    IF :NEW.DOC_DATEOFEXPIRY != v_fecha_expiracion THEN
		   		f_fecha_expiracion :=1;
		    END IF;
		  
		  
		    IF f_modifica_correo = 1 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET CORREO_ELECTRONICO = :NEW.CORREO_ELECTRONICO, FECHA_EXPEDICION_ID = :NEW.DOC_DATEOFISSUE,  FECHA_EXPIRACION = :NEW.DOC_DATEOFEXPIRY, ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	COMMIT;
		    END IF;
		   
		    IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 1 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET  FECHA_EXPEDICION_ID = :NEW.DOC_DATEOFISSUE,  FECHA_EXPIRACION = :NEW.DOC_DATEOFEXPIRY, ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	COMMIT;
		    END IF;
		   
		    IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =1 THEN
		    	UPDATE BFP_PERSONA SET    FECHA_EXPIRACION = :NEW.DOC_DATEOFEXPIRY, ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	COMMIT;
		    END IF;
		   
		   IF f_modifica_correo = 0 AND  f_fecha_expedicion_id = 0 AND f_fecha_expiracion =0 THEN
		    	UPDATE BFP_PERSONA SET  ETAPA_INFO_ELECT = 4  WHERE  NUP = :NEW.COD_CLIENTE;
		    	COMMIT;
		    END IF;
		   
		   
		   BEGIN
			   SELECT TELEFONO INTO v_num_telefono FROM (
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
           EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_num_telefono := NULL;
		      WHEN OTHERS THEN
		       	v_num_telefono := NULL;
		   END;
		  
		   IF v_num_telefono IS NOT NULL THEN
		   		UPDATE TEL_PERSONAS SET NUM_TELEFONO = REPLACE(:NEW.TELEFONO , '503 ', ''), ORIGEN_CEL ='O' WHERE COD_PERSONA = :NEW.COD_CLIENTE AND TIP_TELEFONO ='M' AND EST_TELEFONO ='A';
		   		COMMIT;
		   END IF;
		  
		   IF v_num_telefono IS  NULL THEN
		   		INSERT INTO TEL_PERSONAS
				(COD_PERSONA, COD_AREA, NUM_TELEFONO, TIP_TELEFONO, TEL_UBICACION, EXTENSION, NOTA, ES_DEFAULT, POSICION, COD_DIRECCION, CONTACTO_DIA, CONTACTO_HORA, FECHA_ADICION, ADICIONADO_POR, FECHA_MODIFICACION, MODIFICADO_POR, EST_TELEFONO, ORIGEN_CEL)
				VALUES(:NEW.COD_CLIENTE, '503', REPLACE(:NEW.TELEFONO , '503 ', ''), 'M', 'M', NULL, NULL, 'N', 1, NULL, 'CUA', 'HAB', SYSDATE, USER, NULL, NULL, 'A', 'O');
		   		COMMIT;
		   END IF;		  		  		  		  
		   
		  
		  --PREPARADO PARA INSERT EN DB INTERMEDIA AD
		  
		   BEGIN 
		   		SELECT TIPO_ID INTO v_TIPO_DOCUMENTO_AD FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_TIPO_DOCUMENTO_AD := NULL;
		      WHEN OTHERS THEN
		       	v_TIPO_DOCUMENTO_AD := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT NIT_AFILIADO INTO v_NIT FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_NIT := NULL;
		      WHEN OTHERS THEN
		       	v_NIT := NULL;
		   	END;
		   
		    BEGIN 
		   		SELECT NUM_ID INTO v_NUM_ID FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_NUM_ID := NULL;
		      WHEN OTHERS THEN
		       	v_NUM_ID := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT COD_EMPRESA INTO v_COD_EMPRESA FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_COD_EMPRESA := NULL;
		      WHEN OTHERS THEN
		       	v_COD_EMPRESA := NULL;
		   	END;
		   
		   
		   v_NOMBRE_NEW:=   :NEW.DOC_MRZ_FULLNAME;
		   
		   BEGIN 
		   		SELECT PRIMER_NOMBRE INTO v_PRIMER_NOMBRE_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_PRIMER_NOMBRE_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_PRIMER_NOMBRE_NEW := NULL;
		   	END;
		   
		    BEGIN 
		   		SELECT SEGUNDO_NOMBRE INTO v_SEGUNDO_NOMBRE_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_SEGUNDO_NOMBRE_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_SEGUNDO_NOMBRE_NEW := NULL;
		   	END;
		   
		    BEGIN 
		   		SELECT PRIMER_APELLIDO  INTO v_PRIMER_APELLIDO_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_PRIMER_APELLIDO_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_PRIMER_APELLIDO_NEW := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT SEGUNDO_APELLIDO  INTO v_SEGUNDO_APELLIDO_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_SEGUNDO_APELLIDO_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_SEGUNDO_APELLIDO_NEW := NULL;
		   	END;
		   
		   
		   BEGIN 
		   		SELECT APELLIDO_CASADA  INTO v_APELLIDO_CASADA_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_APELLIDO_CASADA_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_APELLIDO_CASADA_NEW := NULL;
		   	END;
		   
		   v_TELEFONO1_NEW:=REPLACE(:NEW.TELEFONO , '503 ', '');
		  
		   BEGIN 
		   		SELECT TIPO_ID INTO v_TIPO_DOCUMENTO_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_TIPO_DOCUMENTO_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_TIPO_DOCUMENTO_NEW := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT NUP  INTO v_NUMERO_DOCUMENTO_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_NUMERO_DOCUMENTO_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_NUMERO_DOCUMENTO_NEW := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT FECHA_NACIMIENTO  INTO v_FECHA_NACIMIENTO_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_FECHA_NACIMIENTO_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_FECHA_NACIMIENTO_NEW := NULL;
		   	END;
		   
		    BEGIN 
		   		SELECT CORREO_ELECTRONICO  INTO v_CORREO1_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_CORREO1_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_CORREO1_NEW := NULL;
		   	END;
		   
		   BEGIN 
		   		SELECT CORREO_ELECTRONICO2  INTO v_CORREO2_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_CORREO2_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_CORREO2_NEW := NULL;
		   	END;
		   
		   
		    BEGIN 
		   		SELECT CORREO_ELECTRONICO2  INTO v_CORREO2_NEW FROM RE.BFP_PERSONA WHERE NUP = :NEW.COD_CLIENTE;
		   	EXCEPTION
		      WHEN NO_DATA_FOUND THEN
		        v_CORREO2_NEW := NULL;
		      WHEN OTHERS THEN
		       	v_CORREO2_NEW := NULL;
		   	END;
		   
		   
		   

		  INSERT INTO CPSAD.CS_ACTUALIZA_DATOS 
		  (
			  	ID_ACTUALIZACION,
			    FECHA_ACTUALIZACION,
			    TIPO_DOCUMENTO_AD,
			    NIT,
			    NUM_ID,
			    FECHA_NACIMIENTO_AD,
			    NUP,
			    COD_EMPRESA,
			    NOMBRE_NEW,
			    PRIMER_NOMBRE_NEW,
			    SEGUNDO_NOMBRE_NEW,
			    PRIMER_APELLIDO_NEW,
			    SEGUNDO_APELLIDO_NEW,
			    APELLIDO_CASADA_NEW,
			    TELEFONO1_NEW,
			    TIPO_DOCUMENTO_NEW,
			    NUMERO_DOCUMENTO_NEW,
			    FECHA_NACIMIENTO_NEW,
			    CORREO1_NEW,
			    CORREO2_NEW,
			    ESTADO,
			    ADICIONADO_POR,
			    FECHA_INGRESADO,
			    FUENTE,
			   	REGISTRO_AAD,
			    USUARIO_AAD  
		  )
		  VALUES
		  (      
		  		CPSAD.CS_ACTUALIZA_DATOS_SEQ.nextval,       
				v_FECHA_ACTUALIZACION,
				v_TIPO_DOCUMENTO_AD,
				v_NIT,
				v_NUM_ID,
				v_FECHA_NACIMIENTO_AD,
				v_NUP,
				v_COD_EMPRESA ,
				v_NOMBRE_NEW,
				v_PRIMER_NOMBRE_NEW,
				v_SEGUNDO_NOMBRE_NEW,
				v_PRIMER_APELLIDO_NEW,
				v_SEGUNDO_APELLIDO_NEW,
				v_APELLIDO_CASADA_NEW,
				v_TELEFONO1_NEW,
				v_TIPO_DOCUMENTO_NEW,
				v_NUMERO_DOCUMENTO_NEW,
				v_FECHA_NACIMIENTO_NEW,
				v_CORREO1_NEW,
				v_CORREO2_NEW,
				v_ESTADO,
				v_ADICIONADO_POR,
				v_FECHA_INGRESADO ,
				v_FUENTE,
				v_registro_AAD,
				v_usuario_AAD 
		  );
		 COMMIT;
		  
		   
		   
		   
		   
	   END IF;
	   
   	END IF;
   
   EXCEPTION
   WHEN OTHERS THEN
   NULL;
     
END;
 