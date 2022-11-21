create or replace PACKAGE    ge_util01 IS

 --*************************************************************************************************
 --* FUNCION : F_Tipo_Gestion
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : cod_empresa y Tipo Gestion
 --* RETORNA : La Descripcion del Tipo de Gestion Seleccionada
 --*************************************************************************************************
 FUNCTION F_TIPO_GESTION(P_empresa VARCHAR2,p_tipo_Gestion NUMBER) RETURN VARCHAR2;
 PRAGMA RESTRICT_REFERENCES (F_TIPO_GESTION, wnds,wnps);

 --*************************************************************************************************
 --* FUNCION : P_Numero_Gestion
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS :cod_empresa
 --* RETORNA : Devuelve el ultimo Numero de la Gestion
 --*************************************************************************************************
 FUNCTION P_NUMERO_GESTION (pCod_empresa VARCHAR2) RETURN NUMBER;
 PRAGMA RESTRICT_REFERENCES (P_NUMERO_GESTION, wnds,wnps);

 --*************************************************************************************************
 --* PROCEDIMIENTO: P_Validacion_Empleado
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : flag Bandera, tipo_gestion, user, cod_empresa
 --* COMENTARIO : Validar que el usuario se encuentre registrado para resolver el tipo de gestión
 --* especificado (Ge_Encargado_x_Tipo).
 --*************************************************************************************************
 PROCEDURE P_VALIDACION_EMPLEADO(flag IN OUT VARCHAR2, flag_error IN OUT VARCHAR2, p_tipo_gestion NUMBER, p_usuario VARCHAR2, pCod_empresa VARCHAR2, p_entrada IN OUT VARCHAR2, p_salida IN OUT VARCHAR2, ferror IN OUT VARCHAR2, pProcesar_Canal VARCHAR2);
 PRAGMA RESTRICT_REFERENCES (P_VALIDACION_EMPLEADO, wnds,wnps);

 --*************************************************************************************************
 --* PROCEDIMIENTO: P_Valida_Registrador
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : flag Bandera, user, cod_empresa
 --* COMENTARIO : Validar que el usuario se encuentre registrado en el sistema.
 --* Validar que el usuario se encuentre registrado para resolver el tipo de gestión
 --* especificado(Ge_Encargado_x_Tipo).
 --*************************************************************************************************
 PROCEDURE P_VALIDA_REGISTRADOR(flag IN OUT VARCHAR2, flag_error IN OUT VARCHAR2, pUsuario VARCHAR2, pCod_empresa VARCHAR2);
 PRAGMA RESTRICT_REFERENCES (P_VALIDA_REGISTRADOR, wnds,wnps);

 --*************************************************************************************************
 --* PROCEDIMIENTO: P_Canal_Entrada_Salida
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : flag Bandera, tipo_canal, codigo_empleado, cod_empresa
 --* COMENTARIO : Verificar si p_tipo_canal en tabla ge_canal tiene una 'S'
 --*************************************************************************************************
 PROCEDURE P_CANAL_ENTRADA_SALIDA(flag IN OUT VARCHAR2, flag_error IN OUT VARCHAR2, p_tipo_canal VARCHAR2,p_cod_empleado NUMBER, pCod_empresa VARCHAR2, pResultado IN OUT VARCHAR2);
 PRAGMA RESTRICT_REFERENCES (P_CANAL_ENTRADA_SALIDA, wnds,wnps);

 --*************************************************************************************************
 --* FUNCION : F_Cod_Empleado
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS :: user
 --* RETORNA : Devuelve el código de empleado registrado en el mantenimiento de gestiones
 --*************************************************************************************************
 FUNCTION F_COD_EMPLEADO(usuario VARCHAR2) RETURN NUMBER;
 PRAGMA RESTRICT_REFERENCES (F_COD_EMPLEADO, wnds,wnps);

 --*************************************************************************************************
 --* FUNCION : F_Canal_Empleado
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : empresa, codigo_empleado
 --* RETORNA : Devuelve el canal al que pertenece el usuario que trata de ingresar la gestión
 --*************************************************************************************************
 FUNCTION F_CANAL_EMPLEADO(pCod_empresa VARCHAR2, p_cod_empleado NUMBER) RETURN NUMBER;
 PRAGMA RESTRICT_REFERENCES (F_CANAL_EMPLEADO, wnds,wnps);

 --*************************************************************************************************
 --* PROCEDIMIENTO: P_Canal_Tipo_Gestion
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : flag Bandera, canal, tipo_gestion, cod_empresa
 --* COMENTARIO : Validar que el canal se encuentre registrado para el tipo de gestion seleccionado
 --*************************************************************************************************
 PROCEDURE P_CANAL_TIPO_GESTION(flag IN OUT VARCHAR2,flag_error IN OUT VARCHAR2,p_canal NUMBER,p_tipo_gestion NUMBER, pCod_empresa VARCHAR2);
 PRAGMA RESTRICT_REFERENCES (P_CANAL_TIPO_GESTION, wnds,wnps);

 --*************************************************************************************************
 --* PROCEDIMIENTO: P_Valida_Registrador_Canal
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* PARAMETROS : flag Bandera, codigo_empleado, canal, cod_empresa
 --* COMENTARIO : Cuando p_canal is null entonces: Verificar que el usuario se encuentre registrado
 --* en Ge_registrador_x_canal
 --* Cuando p_canal is not null entonces: Verificar que el usuario se encuentre
 --* registrado en p_canal en Ge_registrador_x_canal
 --*************************************************************************************************
 PROCEDURE P_VALIDA_REGISTRADOR_CANAL(flag IN OUT VARCHAR2, flag_error IN OUT VARCHAR2, p_cod_empleado NUMBER, p_canal NUMBER, pCod_empresa VARCHAR2);
 PRAGMA RESTRICT_REFERENCES (P_VALIDA_REGISTRADOR_CANAL, wnds,wnps);


 --*************************************************************************************************
 --* PROCEDIMIENTO: Gestion_Automatica
 --* HECHA : Edwin Monsalve
 --* FECHA : 04/07/2005
 --* COMENTARIO : Inserta un registro (una Gestion Manual o Automatica) en GE_GESTION.
 --* Se incorporan 6 Parametros que en las formas estaran nulos para posteriores
 --* utilizaciones
 --* PARAMETROS : Parametro Tipo Valor Campo de la Tabla Descripcion Especial
 --* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --* flag VARCHAR2 VARCHAR2(15)
 --* flag_error VARCHAR2 VARCHAR2(100)
 --* ferror VARCHAR2 VARCHAR2(500)
 --* pUsuario VARCHAR2 Varchar(15) USER o Nulo segun el caso
 --* pCod_empresa VARCHAR2 VARCHAR2(5) Cod_Empresa
 --* pNup VARCHAR2 VARCHAR2(12) Nup
 --* pNit_empleador VARCHAR2 VARCHAR2(14) Nit_Empleador_Gestion
 --* pTipo_documento VARCHAR2 VARCHAR2(2) Tipo_Documento
 --* pNumero_documento VARCHAR2 VARCHAR2(10) Num_Documento
 --* pNit_empleador_afil VARCHAR2 VARCHAR2(14) Nit Empleador Afiliado
 --* pTipo_gestion NUMBER NUMBER(3) Tipo_Gestion
 --* pCod_empleado_salida NUMBER NUMBER(4) Cod_Empleado_Salida
 --* pCanal_salida NUMBER NUMBER(3) Canal_Salida
 --* pAuxiliar VARCHAR2 VARCHAR2(10) Cod_Auxiliar
 --* pCorpo NUMBER NUMBER(4) Cod_Corporativo
 --* pAgente VARCHAR2 VARCHAR2(10) Cod_Agente
 --* pPeriodo VARCHAR2 VARCHAR2(6) Periodo
 --* pSupervisor VARCHAR2 VARCHAR2(10) Cod_Supervisor
 --* pDescripcion VARCHAR2 VARCHAR2(300) Descripcion
 --* pCausa_Cierre NUMBER NUMBER(3) Causa_Cierre
 --* pDescripcion_Cierre VARCHAR2 VARCHAR2(500) Comentarios
 --* pObservacion_Cierre VARCHAR2 VARCHAR2(500) Comentarios
 --* pEstado_gestion VARCHAR2 VARCHAR2(3) Estado_Gestion
 --* pEstado VARCHAR2 VARCHAR2(3) Estado
 --* pPrioridad VARCHAR2 VARCHAR2(3) Prioridad
 --* pFecha_resuelta DATE Fecha_Resuelta
 --* pFecha_cerrada DATE Fecha_Cerrada
 --* pVigencia DATE Vigencia
 --* pCod_Empleado_Encargado NUMBER NUMBER(4) Cod_Empleado_Encargado
 --* pResponsable VARCHAR2 VARCHAR2(1) Seguimiento de Gestion S = Si Obtener Responsable y N = No Obtener Responsable
 --* pNumero_gestion_origen NUMBER NUMBER(6) Numero_Gestion_Origen
 --* pNum_planilla VARCHAR2 VARCHAR2(35) Num_Planilla
 --* pFormulario NUMBER NUMBER(4) Formulario
 --* pFecha_recibido DATE Fecha_Recibido
 --* pGestion_madre VARCHAR2 VARCHAR2(1) Gestion_Madre
 --* pMonitoreo_sip VARCHAR2 VARCHAR2(1) Monitoreo_Sip
 --* pCategoria_srv NUMBER NUMBER(5) Categoria_Srv
 --* pTramita_pension VARCHAR2 VARCHAR2(1) Tramita_Pension
 --* pParam1 VARCHAR2 Actualmente su valor es nulo
 --* pParam2 VARCHAR2 Actualmente su valor es nulo
 --* pParam3 DATE Actualmente su valor es nulo
 --* pParam4 DATE Actualmente su valor es nulo
 --* pParam5 NUMBER Actualmente su valor es nulo
 --* pPäram6 NUMBER Actualmente su valor es nulo
 --*
 --* GE.Ge_Util01.gestion_automatica(flag ,flag_error ,ferror ,"pUsuario" ,
 --* cod_empresa ,nup ,nit_empleador_gestion ,tipo_documento ,
 --* num_documento ,nit empleador afiliado ,tipo_gestion ,cod_empleado_salida ,
 --* canal_salida ,cod_auxiliar ,cod_corporativo ,cod_agente ,
 --* periodo ,cod_supervisor ,descripcion ,causa_cierre ,
 --* comentarios ,comentarios ,estado_gestion ,estado ,
 --* prioridad ,fecha_resuelta ,fecha_cerrada ,vigencia ,
 --* cod_empleado_encargado ,"pResponsable" ,numero_gestion_origen ,num_planilla ,
 --* formulario ,fecha_recibido ,gestion_madre ,monitoreo_sip ,
 --* categoria_srv ,tramita_pension ,null ,null ,
 --* null ,null ,null ,null );
 --*
 --*************************************************************************************************
 --*30/07/2008 ELVM: Se utilizo el parametro pParam1 para guardar el campo periodo_gestion_origen,
 --* quedando disponibles unicamente 5 parametros.
 --*************************************************************************************************
 PROCEDURE GESTION_AUTOMATICA(flag IN OUT VARCHAR2, -- Bandera de exito o fracaso
 flag_error IN OUT VARCHAR2, --Bandera de Error
 ferror IN OUT VARCHAR2, -- Bandera de Acumulacion de Errores
 pUsuario VARCHAR2, -- Usuario (USER)
 pCod_empresa VARCHAR2, -- Codigo Empresa
 pNup VARCHAR2, -- Nup
 pNit_empleador VARCHAR2, -- Nit
 pTipo_documento VARCHAR2, -- Tipo Documento
 pNumero_documento VARCHAR2, -- Numero Documento
 pNit_empleador_afil VARCHAR2, -- Nit Empleador Afiliado
 pTipo_gestion NUMBER, -- Tipo Gestion
 pCod_empleado_salida NUMBER, -- Codigo de empleado (planilla)
 pCanal_salida NUMBER, -- Codigo de Canal que cerrara la gestion
 pAuxiliar VARCHAR2, -- Codigo de auxiliar que cerrara la gestion
 pCorpo NUMBER, -- Codigo de corporativo que cerrara la gestion
 pAgente VARCHAR2, -- Codigo de agente que cerrara la gestion
 pPeriodo VARCHAR2, -- Periodo de la Gestion
 pSupervisor VARCHAR2, -- Codigo de supervisor que cerrara la gestion
 pDescripcion VARCHAR2, -- Descripcion Gestion
 pCausa_Cierre NUMBER, -- Causa Cierre
 pDescripcion_Cierre VARCHAR2, -- Descripcion de la Causa de Cierre
 pObservacion_Cierre VARCHAR2, -- Observacion de la Causa de Cierre
 pEstado_gestion VARCHAR2, -- Estado de la Gestion por default es (CER)
 pEstado VARCHAR2, -- Estado del registro ACT:Activo , INA:Inactivo
 pPrioridad VARCHAR2, -- Prioridad de la gestion
 pFecha_resuelta DATE, -- Fecha Resolucion de Gestion
 pFecha_cerrada DATE, -- Fecha de Cierre Gestion
 pVigencia DATE, -- Fecha de vigencia del estado del registro
 pCod_Empleado_Encargado NUMBER, -- Codigo del Empleado Encargado del Tipo Gestion
 pResponsable VARCHAR2, -- Con Responsable de Seguimiento de Gestion
 pNumero_gestion_origen NUMBER, -- Numero de Gestion (inicia en 1 cada mes)
 pNum_planilla VARCHAR2, -- Número de Planilla de Recaudo
 pFormulario NUMBER, -- Numero de formulario ingresado ventanilla de gestiones
 pFecha_recibido DATE, -- Fecha de recibo formulario
 pGestion_madre VARCHAR2, -- Campo con valor=S para identificar que existen gestiones dependientes
 pMonitoreo_sip VARCHAR2, -- Indica (S/N) es monitoreada por la SIP
 pCategoria_srv NUMBER, -- Categoría de Servicio.
 pTramita_pension VARCHAR2, -- Indica si un afiliado se encuentra en Trámite de Pensión. Tomará los valores de S (para indicar que sí) y N (para indicar que no).
 pPeriodo_Gestion_Origen VARCHAR2, -- Periodo de la Gestion Origen VARCHAR2(6) -- campo = periodo_gestion_origen
 pParam1 VARCHAR2,
 pParam2 DATE,
 pParam3 DATE,
 pParam4 NUMBER,
 pPäram5 NUMBER
 );
-- PRAGMA RESTRICT_REFERENCES (GESTION_AUTOMATICA, wnds,wnps);

--*************************************************************************************************
 --* PROCEDIMIENTO: Gestion_Automatica2
 --* HECHA : Edward Mejía
 --* FECHA : 02/07/2012
 --* COMENTARIO : Inserta un registro (una Gestion Manual o Automatica) en GE_GESTION.
 --*              Se crea por correcciones de 11g por enllavamientos
 --************************************************************************************************

PROCEDURE Gestion_Automatica2(P_usuario        varchar2,
                             nit              varchar2,           
                             tipo_documento   varchar2,
                             documento        varchar2,
                             nup              varchar2,
                             tipo_gestion     number,
                             descripcion      varchar2,
                             P_estado         varchar2,
                             P_empresa        varchar2,
                             flag  in out     varchar2,
                             P_periodo        varchar2,
                             P_numero_gestion number,
                             P_cod_auxiliar   varchar2,
                             P_cod_corporativo  number,
                             P_cod_agente     varchar2,
                             P_cod_supervisor varchar2,
                             p_periodo_gest        in out varchar2, --new
                             p_numero_gest        in out number --new
                             );


   --*************************************************************************************************
   --* PROCEDIMIENTO: P_Asigna_Encargado
   --* HECHA        : Federico Melendez
   --* FECHA        : 06/07/2005
   --* PARAMETROS    :  flag , flag_error , pCod_empresa, p_tipo_gestion ,p_descripcion_gestion, p_encargado
   --* COMENTARIO   : Retorna el Responsable de Darle Seguimiento a la Gestión
   --*************************************************************************************************
    PROCEDURE P_ASIGNA_ENCARGADO(flag IN OUT VARCHAR2, flag_error IN OUT VARCHAR2,pCod_empresa VARCHAR2, p_tipo_gestion NUMBER,p_descripcion_gestion VARCHAR2,p_encargado OUT NUMBER);
    PRAGMA RESTRICT_REFERENCES (P_ASIGNA_ENCARGADO, wnds,wnps);


   --*************************************************************************************************
   --* FUNCION      : F_nombre
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 04/07/2005
   --* PARAMETROS   :: user
   --* RETORNA      : Devuelve el Nombre Largo o Corto del Afiliado segun el para metro enviado pTipo
   --*                L = Largo  y C = Corto
   --*************************************************************************************************
    FUNCTION F_Nombre (pNup VARCHAR2, pTipo VARCHAR2) RETURN VARCHAR2;
    PRAGMA RESTRICT_REFERENCES (F_Nombre, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Apellido
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 04/07/2005
   --* PARAMETROS   :: Nup y Tipo
   --* RETORNA      : Devuelve el Apellido Largo o Corto del Afiliado segun el para metro enviado pTipo
   --*                L = Largo  y C = Corto
   --*************************************************************************************************
    FUNCTION F_Apellido (pNup VARCHAR2, pTipo VARCHAR2,pViuda VARCHAR2 default null) RETURN VARCHAR2;
    PRAGMA RESTRICT_REFERENCES (F_Apellido, wnds,wnps);


   --*************************************************************************************************
   --* PROCEDIMIENTO: P_Canales
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 07/07/2005
   --* PARAMETROS   : p_tipo_canal, p_cod_empleado, pCod_empresa, p_canal, p_entrada, v_salida, v_cod_empleado
   --* COMENTARIO   : Retorna los Codigos del Empleado para el Canal de Entrada y Salida y el Canal del Usuario
   --*************************************************************************************************
     PROCEDURE P_CANALES(p_cod_empleado VARCHAR2, pCod_empresa VARCHAR2, p_canal IN OUT NUMBER, p_entrada IN OUT VARCHAR2, p_salida IN OUT VARCHAR2, p_empleado IN OUT NUMBER);
  PRAGMA RESTRICT_REFERENCES (P_CANALES, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Razon_social
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 12/07/2005
   --* PARAMETROS   : Empresa y Nit Empleador
   --* RETORNA      : Devuelve la Razon Social del Empleador
   --*************************************************************************************************
  FUNCTION F_Razon_social (pEmpresa VARCHAR2, pNit VARCHAR2) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Razon_social, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Nombre_solicitud
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 12/07/2005
   --* PARAMETROS   : Tipo Solicitud y Numero Documento
   --* RETORNA      : Devuelve el Nombre del solicitante
   --*************************************************************************************************
     FUNCTION F_Nombre_solicitud (pSolicitud VARCHAR2, pDocumento VARCHAR2) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Nombre_solicitud, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Nombre_Encargado
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 13/07/2005
   --* PARAMETROS   : Compañia y Codigo del Encargado
   --* RETORNA      : Devuelve el Nombre del Encargado
   --*************************************************************************************************
     FUNCTION F_Nombre_Encargado (pEmpresa VARCHAR2, pCodigo NUMBER) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Nombre_Encargado, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Nom_Gestion
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 13/07/2005
   --* PARAMETROS   : Empresa y Tipo Gestion
   --* RETORNA      : Devuelve la Descripcion del Tipo de la Gestion
   --*************************************************************************************************
  FUNCTION F_Desc_Gestion (pEmpresa VARCHAR2, pCodigo NUMBER) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Desc_Gestion, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Desc_Cierre
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 13/07/2005
   --* PARAMETROS   : Empresa y Codigo Causa de Cierre
   --* RETORNA      : Devuelve la Descripcion del Motivo de la Causa de Cierre
   --*************************************************************************************************
  FUNCTION F_Desc_Cierre (pEmpresa VARCHAR2, pCausa NUMBER) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Desc_Cierre, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Grupo_Gestion
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 13/07/2005
   --* PARAMETROS   : Grupo y Tipo Gestión
   --* RETORNA      : Devuelve la Descripcion del Grupo al que pertenece la Gestión
   --*************************************************************************************************
  FUNCTION F_Grupo_Gestion (pGrupo NUMBER, pTipo NUMBER) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Grupo_Gestion, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Val_Numero
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 18/07/2005
   --* PARAMETROS   : Cadena
   --* RETORNA      : Devuelve el valor de cero si la cadena enviada es un numero y 1 si la cadena enviada
   --*                es un string
   --*************************************************************************************************
     FUNCTION F_Val_Numero ( p_cadena IN VARCHAR2) RETURN  NUMBER;
  PRAGMA RESTRICT_REFERENCES (F_Val_Numero, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Val_Cadena
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 18/07/2005
   --* PARAMETROS   : Cadena
   --* RETORNA      : Devuelve el valor de cero si la cadena enviada es un caracter y 1 si la cadena enviada
   --*                es un numero
   --* Nota : Se toma en cuenta el punto como dato numerico dentro de la cadena.
   --*************************************************************************************************
     FUNCTION F_Val_Cadena ( p_cadena IN VARCHAR2) RETURN  NUMBER;
  PRAGMA RESTRICT_REFERENCES (F_Val_Cadena, wnds,wnps);



   --*************************************************************************************************
   --* FUNCION      : F_GrpGest
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 26/07/2005
   --* PARAMETROS   : pTipo (campo numerico)
   --* RETORNA      : Devuelve el valor del Grupo al cual pertenece la gestion
   --*************************************************************************************************
     FUNCTION F_GrpGest (pTipo NUMBER) RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (F_GrpGest, wnds,wnps);


   --*************************************************************************************************
   --* FUNCION      : F_ult_trans_doc
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 18/01/2006
   --* RETORNA      : Dado un documento, devolver su última transacción. En caso de que no posea
   --*                ninguna, devolverá cero.
   --*************************************************************************************************
     FUNCTION F_ult_trans_doc (p_COD_EMPRESA varchar2,
                               p_TIPO_DOC    varchar2,
                               p_NUM_DOC     varchar2,
                               p_COPIA_DOC   number)
                               RETURN number;
   PRAGMA RESTRICT_REFERENCES (F_ult_trans_doc, wnds,wnps);

   --*************************************************************************************************
   --* FUNCION      : F_Mora_Real
   --* HECHA        : Edwin Monsalve
   --* FECHA        : 02/02/2006
   --* RETORNA      : Dado un Nit de Empleador Devuelve la Mora Real.
   --*************************************************************************************************
     FUNCTION F_Mora_Real (p_Cod_Empresa varchar2, p_NIT varchar2) RETURN number;
   PRAGMA RESTRICT_REFERENCES (F_Mora_Real, wnds,wnps);


   --****************************************************************
   --* PROCEDURE : Inserta Gestion , Sobrecarga. 
   --* HECHA     : Ernesto Moran 07/05/2007
   --* Se adicionara el parametro del la Categoria del Servicio ya que el
   --* procedimiento original no lo incluye.
   --*****************************************************************
    PROCEDURE inserta_gestion(
      pCodEmpresa VARCHAR2,                    pNup VARCHAR2 default null,
      pNitEmpleador VARCHAR2 default null,     pNitEmpleadorAfil VARCHAR2 default null,
      pDescripcion VARCHAR2  default null,     pComentarios VARCHAR2 default null,
      pTipoGestion NUMBER,                     pEstadoGestion VARCHAR2,
      pCanalEntrada NUMBER,                    pCodEmpleadoEntrada NUMBER,
      pCanalSalida NUMBER default null,        pCodEmpleadoSalida NUMBER default null,
      pNumPlanilla varchar2 default null,      pNumGestion out NUMBER,
      pCategoriaServicio number default null);


    --Inserta gestion sobrecargado.
    procedure inserta_gestion(
            pCodEmpresa VARCHAR2,                    pNup VARCHAR2 default null,
            pNitEmpleador VARCHAR2 default null,     pNitEmpleadorAfil VARCHAR2 default null,
            pDescripcion VARCHAR2  default null,     pComentarios VARCHAR2 default null,
            pTipoGestion NUMBER,                     pEstadoGestion VARCHAR2,
            pCanalEntrada NUMBER,                    pCodEmpleadoEntrada NUMBER,
            pCanalSalida NUMBER default null,        pCodEmpleadoSalida NUMBER default null,
            pNumPlanilla varchar2 default null,      pNumGestion out NUMBER,
            pCategoriaServicio number default null,  pTipoDoc varchar2,             
            pNumDoc varchar2,                        pSupervisor varchar2,            
            pAgente varchar2,                        pAuxiliar varchar2,               
            pCorporativo number,                     pDocImpreso varchar2,          
            pTipoDocAnt varchar2,                    pNumDocAnt varchar2,              
            pNumGestionOrigen number,                pFechaCeseAnt date,        
            pFormulario number,                      pFechaRecibido date,         
            pGestionMadre varchar2,                  pWizard varchar2, 
            pCorrPlanilla number,                    pNacionalidadAnt varchar2);   

   --*************************************************************************************************
   --* FUNCION     : F_Estado_Gestion
   --* HECHA        : Julio Lozano
   --* FECHA        : 08/05/2007
   --* RETORNA      : Dado un período y un número de gestión, devuelve el estado en que esta se encuentra.
   --*************************************************************************************************
     FUNCTION F_Estado_Gestion (p_Cod_Empresa varchar2, p_periodo VARCHAR2, p_Numero_gestion NUMBER) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (F_Estado_Gestion, wnds);

   --*************************************************************************************************
   --* FUNCION     : F_Fecha_Cerrada
   --* HECHA        : Julio Lozano
   --* FECHA        : 08/05/2007
   --* RETORNA      : Dado un período y un número de gestión, devuelve la fecha en que se cerro la gestion.
   --*************************************************************************************************
     FUNCTION F_Fecha_Cerrada (p_Cod_Empresa varchar2, p_periodo VARCHAR2, p_Numero_gestion NUMBER) RETURN DATE;
   PRAGMA RESTRICT_REFERENCES (F_Fecha_Cerrada, wnds);

      --*************************************************************************************************
   --* FUNCION      : F_Desc_Gerencia
   --* HECHA        : ELVM
   --* FECHA        : 03/07/2008
   --* PARAMETROS   : Tipo_Gestion
   --* RETORNA      : Devuelve la gerencia del area responsable de una gestion.
   --*************************************************************************************************
      FUNCTION F_Desc_Gerencia (pCod_Empresa varchar2, pTipo_Gestion number) RETURN varchar2;

      FUNCTION F_estado_civil (p_Cod_Empresa varchar2, p_nup VARCHAR2) RETURN varchar2;

    PROCEDURE p_asigna_encargado (pCodEmpresa VARCHAR2, pTipoGestion NUMBER, pPeriodo VARCHAR2, pNumGestion NUMBER, pCodEmpleadoEncargado IN OUT NUMBER);

    FUNCTION f_obtiene_encargado (pCodEmpresa VARCHAR2, pTipoGestion NUMBER) RETURN NUMBER;

    PROCEDURE p_inserta_seguimiento (pEmpresa varchar2, pDescripcion varchar2 , pNumGestion number, pPerGestion varchar2);

    --****************************************************************
   --* PROCEDURE : Inserta Gestion Carga DBF.
   --* Procedimiento de insercion de gestiones generadas en el proceso de
   --* carga de planillas magneticas.
   --*****************************************************************
    /*procedure inserta_gestion_carga_dbf(
                             p_empresa        		  varchar2,
                             p_nit              		varchar2,           
                             p_tipo_documento   		varchar2,
                             p_documento        		varchar2,
                             p_nup              		varchar2,
                             p_tipo_gestion    			number,
                             p_descripcion     			varchar2,
                             p_nit_afil							varchar2,
                             P_estado         		  varchar2,
                             P_periodo        		  varchar2,
                             p_numero_gestion 		  number,
                             p_cod_auxiliar   		  varchar2,
                             P_cod_corporativo  	  number,
                             p_cod_agente     		  varchar2,
                             p_cod_supervisor 		  varchar2,
				     								 p_tipo_doc_ant				  varchar2,
												     p_num_doc_ant					varchar2,
												     p_nac_ant							varchar2,
												     p_fec_ant							date,
												     p_encargado            number,
                             p_num_planilla         varchar2,
                             p_canal                number,
                             p_cat_servicio         number,
                             p_empleado             number,
                             p_correlativo_planilla number, 
                             p_comentarios          varchar2);*/

END;
