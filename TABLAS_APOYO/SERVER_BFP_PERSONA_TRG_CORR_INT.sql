  CREATE OR REPLACE TRIGGER "RE"."BFP_PERSONA_TRG_CORR_INT" BEFORE
    UPDATE OF correo_electronico,correo_electronico2, 
    ETAPA_INFO_ELECT,ESTADO_EMAIL1, ESTADO_EMAIL2,NUP ON RE.bfp_persona
    REFERENCING
            OLD AS old
            NEW AS new
    FOR EACH ROW
DECLARE
    etapa_elec_dif_4      EXCEPTION;
    ambos_correos_iguales EXCEPTION;
    primer_correo_duplic  EXCEPTION;
    segundo_correo_duplic EXCEPTION;
    ambos_correos_duplic  EXCEPTION;
    correo1_en_mayuscula  EXCEPTION;
    correo2_en_mayuscula  EXCEPTION;
    vnup BFP_PERSONA.NUP%TYPE := :OLD.NUP;
    vdup_primero NUMERIC := 0;
    vdup_segundo NUMERIC := 0;
    vcorreo1 BFP_PERSONA.correo_electronico%type   := lower(:NEW.correo_electronico);
    vcorreo2 BFP_PERSONA.correo_electronico2%type  := lower(:NEW.correo_electronico2);

BEGIN
  -- Valida si ETAPA_INFO_ELECT = 4 o si estaba con estado fallecido, 
  -- si es asi, no ya no realizan el resto de validaciones.
  IF (:NEW.ETAPA_INFO_ELECT <> '4') OR (:OLD.ESTADO_AFILIADO = 'FCD' AND :OLD.IND_ESTADO_REGISTRO = 'A' ) THEN
     RAISE etapa_elec_dif_4;
  END IF;

  -- Si ambos correos estan activos, se verifica que sean diferentes entre si.
  IF (:NEW.ESTADO_EMAIL1 = 'A' and :NEW.ESTADO_EMAIL2 = 'A') and (vcorreo1=vcorreo2) 
  THEN 
      RAISE ambos_correos_iguales;
  END IF;

  -- Se valida que si se modifica el correo electronico 1 o se habilita, este no contenga mayusculas
  IF (:NEW.ESTADO_EMAIL1 = 'A' and lower(:NEW.correo_electronico) <> :NEW.correo_electronico) and
     (:OLD.correo_electronico <>:NEW.correo_electronico OR :OLD.ESTADO_EMAIL1 <> :NEW.ESTADO_EMAIL1) THEN
     RAISE correo1_en_mayuscula;
  END IF;
 
 -- Se valida que si se modifica el correo electronico 2 o se habilita, este no contenga mayusculas
  IF (:NEW.ESTADO_EMAIL2 = 'A' and lower(:NEW.correo_electronico2) <> :NEW.correo_electronico2) and
     (:OLD.correo_electronico2 <>:NEW.correo_electronico2 OR :OLD.ESTADO_EMAIL2 <> :NEW.ESTADO_EMAIL2) THEN
     RAISE correo2_en_mayuscula;
  END IF;

  -- Se valida con la función si existen nups con el correo electrico 1
  IF :NEW.ESTADO_EMAIL1 = 'A' THEN
      select FNC_VALIDA_CORREO_PERSONA_NUP(vcorreo1,vnup) into vdup_primero from dual;
  END IF;

  -- Se valida con la función si existen nups con el correo electrico 2
  IF :NEW.ESTADO_EMAIL2 = 'A' THEN
      select FNC_VALIDA_CORREO_PERSONA_NUP(vcorreo2,vnup) into vdup_segundo from dual;
  END IF;

  -- Se evalua el resultado de las funciones y se dispara una excepcion si es necesario
  IF (vdup_primero > 0) and (vdup_segundo > 0) THEN 
       RAISE ambos_correos_duplic;
   ELSIF  vdup_primero > 0	THEN
       RAISE primer_correo_duplic;
   ELSIF  vdup_segundo > 0	THEN
       RAISE segundo_correo_duplic;	   
   END IF; 

EXCEPTION
    WHEN etapa_elec_dif_4     THEN 
	     NULL;  -- No es necesario realizar las verificaciones
    WHEN ambos_correos_iguales THEN
        raise_application_error(-20090,'Ambos Correos Electronicos no pueden ser iguales');  
	WHEN ambos_correos_duplic THEN
	     raise_application_error(-20091,'Ambos Correos Electronicos ya estan siendo usados por otros nup');  
    WHEN primer_correo_duplic THEN
        raise_application_error(-20092,'Primer Correo electronico ya esta siendo usado por otro nup');  
    WHEN segundo_correo_duplic THEN
        raise_application_error(-20093,'Segundo Correo electronico ya esta siendo usado por otro nup');  
    WHEN correo1_en_mayuscula  THEN
        raise_application_error(-20094,'El Correo electronico 1 no debe contener mayusculas');  
    WHEN correo2_en_mayuscula  THEN
        raise_application_error(-20095,'El Correo electronico 2 no debe contener mayusculas');  
END;


/
ALTER TRIGGER "RE"."BFP_PERSONA_TRG_CORR_INT" ENABLE;