create or replace TRIGGER "PA"."TEL_PERSONA_TRG_INT" AFTER
    UPDATE OF num_telefono, ORIGEN_CEL ON PA.tel_personas
    REFERENCING
            OLD AS old
            NEW AS new
    FOR EACH ROW
DECLARE

    vnup VARCHAR2(12 BYTE);
    vtipo_id VARCHAR2(5 BYTE);
    vnum_id VARCHAR2(15 BYTE);
    vlfecha DATE;
    vfnacimiento DATE;
    vier VARCHAR2(1 BYTE);
    correo_preexistente EXCEPTION;

    t1_old varchar2(10);
	t1_new varchar2(10);

    CURSOR cDBFP_PERSONA
    IS
    select NUP,TIPO_ID,NUM_ID,LOTE_FECHA,FECHA_NACIMIENTO,IND_ESTADO_REGISTRO
    from RE.bfp_persona
    where NUP = :OLD.COD_PERSONA;
BEGIN

    OPEN cDBFP_PERSONA;
    FETCH cDBFP_PERSONA INTO vnup,vtipo_id,vnum_id,vlfecha,vfnacimiento,vier;
    CLOSE cDBFP_PERSONA;

    if :old.num_telefono=:new.num_telefono then t1_old:=null; else t1_old:=:old.num_telefono; end if;
	if :new.num_telefono=:old.num_telefono then t1_new:=null; else t1_new:=:new.num_telefono; end if;

    IF ( substr(to_char(:new.num_telefono), 1, 1) <> '2' AND length(to_char(:new.num_telefono)) = 8) 
    and (vtipo_id in (2,3,4,10)) AND ( vier = 'A' ) AND updating('NUM_TELEFONO') and (t1_old is not null and t1_new is not null) 
    and :new.ORIGEN_CEL !='O'
    THEN
        INSERT INTO cpsad.cs_actualiza_datos (
            id_actualizacion,
                fecha_actualizacion,
                tipo_documento_ad,
                num_id,
                fecha_nacimiento_ad,
                nup,
                cod_empresa,
                telefono1_old,
                telefono1_new,
                estado,
                adicionado_por,
                fecha_ingresado,
                fecha_procesado,
                fecha_modificado,
                modificado_por,
                fuente
       ) VALUES (
                cpsad.cs_actualiza_datos_seq.nextval,
                SYSDATE,
                vtipo_id,
                vnum_id,
                vfnacimiento,
                vnup,
                1,
                t1_old,
                t1_new,
                1,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                'TEL_PERSONA'
            );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20091, ' Error al crear registro en CS_ACTUALIZA_DATOS.' || sqlerrm);
        RAISE;
END;
