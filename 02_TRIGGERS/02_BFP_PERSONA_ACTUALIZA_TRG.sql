CREATE OR REPLACE TRIGGER "RE"."BFP_PERSONA_ACTUALIZA_TRG" AFTER
    UPDATE OF primer_nombre,segundo_nombre,tipo_id,num_id,fecha_nacimiento,
    primer_apellido,segundo_apellido,apellido_casada,correo_electronico,
    correo_electronico2,ind_estado_registro,ESTADO_AFILIADO,ESTADO_EMAIL1,
    ESTADO_EMAIL2
    ON RE.bfp_persona
    REFERENCING
            OLD AS old
            NEW AS new
    FOR EACH ROW
DECLARE 
    no_aplica                EXCEPTION;
	pnombre_old varchar2(30)   := null;
	pnombre_new varchar2(30)   := null;
	snombre_old varchar2(30)   := null;
	snombre_new varchar2(30)   := null;
	tid_old varchar2(5 BYTE)   := null;
	tid_new varchar2(5 BYTE)   := null;
 	nid_old varchar2(30)       := null;
	nid_new varchar2(30)       := null;
	fnacimiento_old date       := null;
	fnacimiento_new date       := null;
	papellido_old varchar2(30) := null;
	papellido_new varchar2(30) := null;
	sapellido_old varchar2(20) := null;
	sapellido_new varchar2(20) := null;
	acasada_old varchar2(20)   := null;
	acasada_new varchar2(20)   := null;
	celectronico_old varchar2(100)  := null;
	celectronico_new varchar2(100)  := null;
	celectronico2_old varchar2(100) := null;
	celectronico2_new varchar2(100) := null;
	ind_er_old varchar2(1, BYTE)    := null;
	ind_er_new varchar2(1, BYTE)    := null;
    eafiliado_old varchar2(3, BYTE) := null;
	eafiliado_new varchar2(3, BYTE) := null;
	vcampos_con_cambios integer    := 0;  -- Variable para determinar el numero 
	                                      -- de campos con cambios a insertar.
    vestadoonboarding VARCHAR2(10 CHAR) := null;
    err_msg  VARCHAR2(2000 CHAR) := null;

BEGIN
    -- Si ya tiene estado FCD (fallecido) procede a salirse sin generar registro
	-- en la tabla intermedia
    IF (:OLD.ESTADO_AFILIADO = 'FCD' AND :OLD.IND_ESTADO_REGISTRO = 'A' ) THEN
	    raise no_aplica;
    end if;

    -- Se procede a evaluar uno por uno los campos para identificar las modificaciones
	-- para ser insertados en la tabla intermedia ademas se lleva un conteo de los campos con
    -- modificación, con el objetivo de evitar casos como 
	-- update bfp_persona campo = campo que efectuan update, pero no cambian ningun valor y
	-- pueden provocar que todos los campos vayan nulos.

    if :old.primer_nombre <> :new.primer_nombre then 
	    pnombre_old:=:old.primer_nombre; 
		pnombre_new:=:new.primer_nombre;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.segundo_nombre <> :new.segundo_nombre then 
	    snombre_old:=:old.segundo_nombre; 
		snombre_new:=:new.segundo_nombre;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.tipo_id <> :new.tipo_id then 
	    tid_old:=:old.tipo_id; 
		tid_new:=:new.tipo_id;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.num_id <> :new.num_id then 
	    nid_old:=:old.num_id; 
		nid_new:=:new.num_id;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.fecha_nacimiento <> :new.fecha_nacimiento then 
	    fnacimiento_old:=:old.fecha_nacimiento; 
		fnacimiento_new:=:new.fecha_nacimiento;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.primer_apellido <> :new.primer_apellido then 
	    papellido_old:=:old.primer_apellido; 
		papellido_new:=:new.primer_apellido; 
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.segundo_apellido <> :new.segundo_apellido then 
	    sapellido_old:=:old.segundo_apellido; 
		sapellido_new:=:new.segundo_apellido;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if :old.apellido_casada <> :new.apellido_casada then 
	    acasada_old:=:old.apellido_casada; 
		acasada_new:=:new.apellido_casada; 
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

    -- Se verifica si ha cambiado el correo y que el estado este activo o
	-- que el estado del correo haya pasado a activo para hacer la replica
    if ((LOWER(:old.correo_electronico) <> LOWER(:new.correo_electronico)) and (:NEW.ESTADO_EMAIL1 = 'A'))  then
         celectronico_old:=lower(:old.correo_electronico); 
		 celectronico_new:=lower(:new.correo_electronico);
		 vcampos_con_cambios := vcampos_con_cambios + 1;     
    ELSIF  (:old.ESTADO_EMAIL1 <> 'A' and :new.ESTADO_EMAIL1 = 'A') then 
	     celectronico_old:= null; 
		 celectronico_new:=lower(:new.correo_electronico);
		 vcampos_con_cambios := vcampos_con_cambios + 1; 
    ELSIF  (:old.ESTADO_EMAIL1 = 'A' and :new.ESTADO_EMAIL1 <> 'A') then 
	     celectronico_old:= lower(:old.correo_electronico);  
		 celectronico_new:= null;
		 vcampos_con_cambios := vcampos_con_cambios + 1;          
	end if;

    -- Se verifica si ha cambiado el correo y que el estado este activo o
	-- que el estado del correo haya pasado a activo para hacer la replica
	if ((lower(:old.correo_electronico2) <> lower(:new.correo_electronico2)) and (:NEW.ESTADO_EMAIL2 = 'A')) then
         celectronico2_old:=lower(:old.correo_electronico2); 
		 celectronico2_new:=lower(:new.correo_electronico2);
		 vcampos_con_cambios := vcampos_con_cambios + 1;
    ELSIF   (:old.ESTADO_EMAIL2 <> 'A' and :new.ESTADO_EMAIL2 = 'A') then 
	     celectronico2_old:= null; 
		 celectronico2_new:=lower(:new.correo_electronico2);
		 vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	if (:old.ind_estado_registro <> :new.ind_estado_registro) then 
	     ind_er_old:=:old.ind_estado_registro; 
		 ind_er_new:=:new.ind_estado_registro;
		 vcampos_con_cambios := vcampos_con_cambios + 1;
    end if;

    if :old.ESTADO_AFILIADO <> :new.ESTADO_AFILIADO then 
	    eafiliado_old:=:old.ESTADO_AFILIADO; 
		eafiliado_new:=:new.ESTADO_AFILIADO;
		vcampos_con_cambios := vcampos_con_cambios + 1;
	end if;

	-- Si no hay ningun cambio, procede a salirse sin generar registro en la tabla intermedia
    IF vcampos_con_cambios = 0 THEN
	   RAISE no_aplica;
	end if;

    IF (:old.tipo_id IN (2,3,4,10)) AND :OLD.IND_ESTADO_REGISTRO = 'A' AND :NEW.IND_ESTADO_REGISTRO IN ('I','V','L')
    THEN
        INSERT INTO cpsad.cs_actualiza_datos (
                id_actualizacion,
                fecha_actualizacion,
                tipo_documento_ad,
                num_id,
                fecha_nacimiento_ad,
                nup,
                cod_empresa,
                primer_nombre_old,
                primer_nombre_new,
                segundo_nombre_old,
                segundo_nombre_new,
                primer_apellido_old,
                primer_apellido_new,
                segundo_apellido_old,
                segundo_apellido_new,
                apellido_casada_old,
                apellido_casada_new,
                tipo_documento_old,
                tipo_documento_new,
                numero_documento_old,
                numero_documento_new,
                fecha_nacimiento_old,
                fecha_nacimiento_new,
                correo1_old,
                correo1_new,
                correo2_old,
                correo2_new,
                ind_estado_registro_old,
                ind_estado_registro_new,
                estado_afiliado_old,
                estado_afiliado_new,
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
                :old.tipo_id,
                :old.num_id,
                :old.fecha_nacimiento,
                :old.nup,
                1,
                pnombre_old,
				pnombre_new,
				snombre_old,
				snombre_new,
				papellido_old,
				papellido_new,
				sapellido_old,
				sapellido_new,
				acasada_old,
				acasada_new,
                tid_old,
				tid_new,
				nid_old,
				nid_new,
				fnacimiento_old,
				fnacimiento_new,
				celectronico_old,
				celectronico_new,
				celectronico2_old,
				celectronico2_new,
				ind_er_old,
				ind_er_new,
                eafiliado_old,
                eafiliado_new,
                1,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                'BFP_PERSONA'
        );

    ELSIF (:old.tipo_id IN (2,3,4,10)) AND :OLD.IND_ESTADO_REGISTRO = 'A' AND :NEW.IND_ESTADO_REGISTRO = 'A' 
    THEN
               /* INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, '******************************','*****************************');
              -- INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'vestadoonboarding',vestadoonboarding);
                INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, ':old.nup',:old.nup);
                --INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'ESTADO',:OLD.ESTADO);
                BEGIN
                    SELECT ESTADO INTO vestadoonboarding  FROM WEB.WEB_DOCS_OCR_DATA WHERE cod_cliente = to_char(:old.nup) AND ROWNUM <=1;
                    --INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'vestadoonboarding',vestadoonboarding);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        vestadoonboarding := NULL;
                      --  INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'NO_DATA_FOUND',vestadoonboarding);
                    WHEN OTHERS THEN
                        vestadoonboarding := NULL; --to_char(SQLCODE); -- SQLCODE||' -ERROR- '||SQLERRM;
                      
                      err_msg := SUBSTR(SQLERRM, 1, 2000);
                      INSERT INTO WEB.LOGS_ONBRD_TEMP VALUES(WEB.LOGS_ONBRD_TEMP_SEC.NEXTVAL, 'SQLCODE',err_msg);  
                END;*/

                IF :NEW.ETAPA_INFO_ELECT = 4 THEN
                     INSERT INTO cpsad.cs_actualiza_datos (
                        id_actualizacion,
                        fecha_actualizacion,
                        tipo_documento_ad,
                        num_id,
                        fecha_nacimiento_ad,
                        nup,
                        cod_empresa,
                        primer_nombre_old,
                        primer_nombre_new,
                        segundo_nombre_old,
                        segundo_nombre_new,
                        primer_apellido_old,
                        primer_apellido_new,
                        segundo_apellido_old,
                        segundo_apellido_new,
                        apellido_casada_old,
                        apellido_casada_new,
                        tipo_documento_old,
                        tipo_documento_new,
                        numero_documento_old,
                        numero_documento_new,
                        fecha_nacimiento_old,
                        fecha_nacimiento_new,
                        correo1_old,
                        correo1_new,
                        correo2_old,
                        correo2_new,
                        ind_estado_registro_old,
                        ind_estado_registro_new,
                        estado_afiliado_old,
                        estado_afiliado_new,
                        estado,
                        adicionado_por,
                        fecha_ingresado,
                        fecha_procesado,
                        fecha_modificado,
                        modificado_por,
                        fuente,
                        registro_AAD
                    ) VALUES (
                        cpsad.cs_actualiza_datos_seq.nextval,
                        SYSDATE,
                        :old.tipo_id,
                        :old.num_id,
                        :old.fecha_nacimiento,
                        :old.nup,
                        1,
                        pnombre_old,
                        pnombre_new,
                        snombre_old,
                        snombre_new,
                        papellido_old,
                        papellido_new,
                        sapellido_old,
                        sapellido_new,
                        acasada_old,
                        acasada_new,
                        tid_old,
                        tid_new,
                        nid_old,
                        nid_new,
                        fnacimiento_old,
                        fnacimiento_new,
                        celectronico_old,
                        celectronico_new,
                        celectronico2_old,
                        celectronico2_new,
                        ind_er_old,
                        ind_er_new,
                        eafiliado_old,
                        eafiliado_new,
                        1,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        'BFP_PERSONA',
                        'S'
                    );
                ELSE
                    INSERT INTO cpsad.cs_actualiza_datos (
                        id_actualizacion,
                        fecha_actualizacion,
                        tipo_documento_ad,
                        num_id,
                        fecha_nacimiento_ad,
                        nup,
                        cod_empresa,
                        primer_nombre_old,
                        primer_nombre_new,
                        segundo_nombre_old,
                        segundo_nombre_new,
                        primer_apellido_old,
                        primer_apellido_new,
                        segundo_apellido_old,
                        segundo_apellido_new,
                        apellido_casada_old,
                        apellido_casada_new,
                        tipo_documento_old,
                        tipo_documento_new,
                        numero_documento_old,
                        numero_documento_new,
                        fecha_nacimiento_old,
                        fecha_nacimiento_new,
                        correo1_old,
                        correo1_new,
                        correo2_old,
                        correo2_new,
                        ind_estado_registro_old,
                        ind_estado_registro_new,
                        estado_afiliado_old,
                        estado_afiliado_new,
                        estado,
                        adicionado_por,
                        fecha_ingresado,
                        fecha_procesado,
                        fecha_modificado,
                        modificado_por,
                        fuente,
                        registro_AAD
                    ) VALUES (
                        cpsad.cs_actualiza_datos_seq.nextval,
                        SYSDATE,
                        :old.tipo_id,
                        :old.num_id,
                        :old.fecha_nacimiento,
                        :old.nup,
                        1,
                        pnombre_old,
                        pnombre_new,
                        snombre_old,
                        snombre_new,
                        papellido_old,
                        papellido_new,
                        sapellido_old,
                        sapellido_new,
                        acasada_old,
                        acasada_new,
                        tid_old,
                        tid_new,
                        nid_old,
                        nid_new,
                        fnacimiento_old,
                        fnacimiento_new,
                        celectronico_old,
                        celectronico_new,
                        celectronico2_old,
                        celectronico2_new,
                        ind_er_old,
                        ind_er_new,
                        eafiliado_old,
                        eafiliado_new,
                        1,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        'BFP_PERSONA',
                        NULL
                    );
                END IF;

                


            ELSIF (:NEW.ESTADO_AFILIADO = 'FCD' AND :OLD.IND_ESTADO_REGISTRO = 'A') 
            THEN


            INSERT INTO cpsad.cs_actualiza_datos (
                        id_actualizacion,
                        fecha_actualizacion,
                        tipo_documento_ad,
                        nit,
                        num_id,
                        fecha_nacimiento_ad,
                        nup,
                        cod_empresa,
                        primer_nombre_old,
                        primer_nombre_new,
                        segundo_nombre_old,
                        segundo_nombre_new,
                        primer_apellido_old,
                        primer_apellido_new,
                        segundo_apellido_old,
                        segundo_apellido_new,
                        apellido_casada_old,
                        apellido_casada_new,
                        tipo_documento_old,
                        tipo_documento_new,
                        numero_documento_old,
                        numero_documento_new,
                        fecha_nacimiento_old,
                        fecha_nacimiento_new,
                        correo1_old,
                        correo1_new,
                        correo2_old,
                        correo2_new,
                        ind_estado_registro_old,
                        ind_estado_registro_new,
                        ESTADO_AFILIADO_OLD,
                        ESTADO_AFILIADO_NEW,
                        estado,
                        adicionado_por,
                        fecha_ingresado,
                        fecha_procesado,
                        fecha_modificado,
                        modificado_por,
                        fuente,
                        USUARIO_WEB_OLD,
                        USUARIO_WEB_NEW
                    ) VALUES (
                        cpsad.cs_actualiza_datos_seq.nextval,
                        SYSDATE,
                        :old.tipo_id,
                        :old.num_id,
                        :old.num_id,
                        :old.fecha_nacimiento,
                        :old.nup,
                        1,
                        pnombre_old,
                        pnombre_new,
                        snombre_old,
                        snombre_new,
                        papellido_old,
                        papellido_new,
                        sapellido_old,
                        sapellido_new,
                        acasada_old,
                        acasada_new,
                        tid_old,
                        tid_new,
                        nid_old,
                        nid_new,
                        fnacimiento_old,
                        fnacimiento_new,
                        celectronico_old,
                        celectronico_new,
                        celectronico2_old,
                        celectronico2_new,
                        ind_er_old,
                        ind_er_new,
                        eafiliado_old,
                        eafiliado_new,
                        1,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        'BFP_PERSONA',
                        NULL,
                        NULL
                    );


            END IF;

EXCEPTION
    WHEN NO_APLICA THEN
	     NULL;
    WHEN OTHERS THEN
        raise_application_error(-20091,' Error al crear registro en BFP_PERSONA.'
        || sqlerrm);
        RAISE;
END;

