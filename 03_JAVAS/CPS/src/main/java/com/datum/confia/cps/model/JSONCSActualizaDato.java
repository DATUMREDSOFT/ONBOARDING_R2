package com.datum.confia.cps.model;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Generated;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

@Generated("jsonschema2pojo")
public class JSONCSActualizaDato {
	
	@SerializedName("ID_ACTUALIZACION") @Expose 	private Integer idActualizacion;
	@SerializedName("FECHA_ACTUALIZACION") @Expose 	private String fechaActualizacion;
	@SerializedName("TIPO_DOCUMENTO_AD") @Expose 	private String tipoDocumentoAd;
	@SerializedName("NIT") @Expose 					private String nit;
	@SerializedName("NUM_ID") @Expose 				private String numId;
	@SerializedName("FECHA_NACIMIENTO_AD") @Expose 	private String fechaNacimientoAd;
	@SerializedName("NUP") @Expose 					private String nup;
	@SerializedName("NOMBRE_NEW") @Expose 			private String nombreNew;
	@SerializedName("NOMBRE_OLD") @Expose 			private String nombreOld;
	@SerializedName("PRIMER_NOMBRE_OLD") @Expose 	private String primerNombreOld;
	@SerializedName("PRIMER_NOMBRE_NEW") @Expose 	private String primerNombreNew;
	@SerializedName("SEGUNDO_NOMBRE_OLD") @Expose 	private String segundoNombreOld;
	@SerializedName("SEGUNDO_NOMBRE_NEW") @Expose 	private String segundoNombreNew;
	@SerializedName("PRIMER_APELLIDO_OLD") @Expose 	private String primerApellidoOld;
	@SerializedName("PRIMER_APELLIDO_NEW") @Expose 	private String primerApellidoNew;
	@SerializedName("SEGUNDO_APELLIDO_OLD") @Expose private String segundoApellidoOld;
	@SerializedName("SEGUNDO_APELLIDO_NEW") @Expose private String segundoApellidoNew;
	@SerializedName("APELLIDO_CASADA_NEW") @Expose	private String apellidoCasadaNew;
	@SerializedName("APELLIDO_CASADA_OLD") @Expose 	private String apellidoCasadaOld;
	@SerializedName("TELEFONO1_OLD") @Expose 		private String telefono1Old;
	@SerializedName("TELEFONO1_NEW") @Expose 		private String telefono1New;
	@SerializedName("TELEFONO2_NEW") @Expose 		private String telefono2New;
	@SerializedName("TELEFONO2_OLD") @Expose 		private String telefono2Old;
	@SerializedName("TIPO_DOCUMENTO_OLD") @Expose 	private String tipoDocumentoOld;
	@SerializedName("TIPO_DOCUMENTO_NEW") @Expose 	private String tipoDocumentoNew;
	@SerializedName("NUMERO_DOCUMENTO_OLD") @Expose private String numeroDocumentoOld;
	@SerializedName("NUMERO_DOCUMENTO_NEW") @Expose private String numeroDocumentoNew;
	@SerializedName("FECHA_NACIMIENTO_OLD") @Expose private String fechaNacimientoOld;
	@SerializedName("FECHA_NACIMIENTO_NEW") @Expose private String fechaNacimientoNew;
	@SerializedName("CORREO1_OLD") @Expose 			private String correo1Old;
	@SerializedName("CORREO1_NEW") @Expose 			private String correo1New;
	@SerializedName("CORREO2_OLD") @Expose 			private String correo2Old;
	@SerializedName("CORREO2_NEW") @Expose 				private String correo2New;
	@SerializedName("IND_ESTADO_REGISTRO_OLD") @Expose 	private String indEstadoRegistroOld;
	@SerializedName("IND_ESTADO_REGISTRO_NEW") @Expose 	private String indEstadoRegistroNew;
	@SerializedName("ESTADO_AFILIADO_OLD") @Expose 		private String estadoAfiliadoOld;
	@SerializedName("ESTADO_AFILIADO_NEW") @Expose 		private String estadoAfiliadoNew;
	@SerializedName("ESTADO") @Expose 					private Integer estado;
	@SerializedName("ADICIONADO_POR") @Expose 			private String adicionadoPor;
	@SerializedName("FECHA_INGRESADO") @Expose 			private String fechaIngresado;
	@SerializedName("FECHA_PROCESADO") @Expose 			private String fechaProcesado;
	@SerializedName("FECHA_MODIFICADO") @Expose 		private String fechaModificado;
	@SerializedName("MODIFICADO_POR") @Expose 			private String modificadoPor;
	@SerializedName("FUENTE") @Expose 					private String fuente;
	@SerializedName("USUARIO_WEB_OLD") @Expose 			private String usuarioWebOld;
	@SerializedName("USUARIO_WEB_NEW") @Expose 			private String usuarioWebNew;
	@SerializedName("VALID") @Expose					private String valid;
	@SerializedName("ID_AAD") @Expose					private String idAad;
	@SerializedName("MENSAJE") @Expose					private String mensaje;
	@SerializedName("REPROCESO") @Expose				private Integer reproceso;
	
	
	
	/**
	* No args constructor for use in serialization
	*
	*/
	public JSONCSActualizaDato() {
	}

	public JSONCSActualizaDato(Integer idActualizacion, String fechaActualizacion, String tipoDocumentoAd, String nit,
			String numId, String fechaNacimientoAd, String nup, String nombreNew, String nombreOld,
			String primerNombreOld, String primerNombreNew, String segundoNombreOld, String segundoNombreNew,
			String primerApellidoOld, String primerApellidoNew, String segundoApellidoOld, String segundoApellidoNew,
			String apellidoCasadaNew, String apellidoCasadaOld, String telefono1Old, String telefono1New,
			String telefono2New, String telefono2Old, String tipoDocumentoOld, String tipoDocumentoNew,
			String numeroDocumentoOld, String numeroDocumentoNew, String fechaNacimientoOld, String fechaNacimientoNew,
			String correo1Old, String correo1New, String correo2Old, String correo2New, String indEstadoRegistroOld,
			String indEstadoRegistroNew, String estadoAfiliadoOld, String estadoAfiliadoNew, Integer estado,
			String adicionadoPor, String fechaIngresado, String fechaProcesado, String fechaModificado,
			String modificadoPor, String fuente, String usuarioWebOld, String usuarioWebNew, String valid, String idAad,
			Integer reproceso) {
		
		super();
		this.idActualizacion = idActualizacion;
		this.fechaActualizacion = fechaActualizacion;
		this.tipoDocumentoAd = tipoDocumentoAd;
		this.nit = nit;
		this.numId = numId;
		this.fechaNacimientoAd = fechaNacimientoAd;
		this.nup = nup;
		this.nombreNew = nombreNew;
		this.nombreOld = nombreOld;
		this.primerNombreOld = primerNombreOld;
		this.primerNombreNew = primerNombreNew;
		this.segundoNombreOld = segundoNombreOld;
		this.segundoNombreNew = segundoNombreNew;
		this.primerApellidoOld = primerApellidoOld;
		this.primerApellidoNew = primerApellidoNew;
		this.segundoApellidoOld = segundoApellidoOld;
		this.segundoApellidoNew = segundoApellidoNew;
		this.apellidoCasadaNew = apellidoCasadaNew;
		this.apellidoCasadaOld = apellidoCasadaOld;
		this.telefono1Old = telefono1Old;
		this.telefono1New = telefono1New;
		this.telefono2New = telefono2New;
		this.telefono2Old = telefono2Old;
		this.tipoDocumentoOld = tipoDocumentoOld;
		this.tipoDocumentoNew = tipoDocumentoNew;
		this.numeroDocumentoOld = numeroDocumentoOld;
		this.numeroDocumentoNew = numeroDocumentoNew;
		this.fechaNacimientoOld = fechaNacimientoOld;
		this.fechaNacimientoNew = fechaNacimientoNew;
		this.correo1Old = correo1Old;
		this.correo1New = correo1New;
		this.correo2Old = correo2Old;
		this.correo2New = correo2New;
		this.indEstadoRegistroOld = indEstadoRegistroOld;
		this.indEstadoRegistroNew = indEstadoRegistroNew;
		this.estadoAfiliadoOld = estadoAfiliadoOld;
		this.estadoAfiliadoNew = estadoAfiliadoNew;
		this.estado = estado;
		this.adicionadoPor = adicionadoPor;
		this.fechaIngresado = fechaIngresado;
		this.fechaProcesado = fechaProcesado;
		this.fechaModificado = fechaModificado;
		this.modificadoPor = modificadoPor;
		this.fuente = fuente;
		this.usuarioWebOld = usuarioWebOld;
		this.usuarioWebNew = usuarioWebNew;
		this.valid = valid;
		this.idAad = idAad;
		this.reproceso = reproceso;
	}

	public Integer getIdActualizacion() {
	return idActualizacion;
	}

	public void setIdActualizacion(Integer idActualizacion) {
	this.idActualizacion = idActualizacion;
	}

	public String getFechaActualizacion() {
	return fechaActualizacion;
	}

	public void setFechaActualizacion(String fechaActualizacion) {
	this.fechaActualizacion = fechaActualizacion;
	}

	public String getTipoDocumentoAd() {
	return tipoDocumentoAd;
	}

	public void setTipoDocumentoAd(String tipoDocumentoAd) {
	this.tipoDocumentoAd = tipoDocumentoAd;
	}

	public String getNumId() {
	return numId;
	}

	public void setNumId(String numId) {
	this.numId = numId;
	}

	public String getFechaNacimientoAd() {
	return fechaNacimientoAd;
	}

	public void setFechaNacimientoAd(String fechaNacimientoAd) {
	this.fechaNacimientoAd = fechaNacimientoAd;
	}

	public String getNup() {
	return nup;
	}

	public void setNup(String nup) {
	this.nup = nup;
	}

	public String getCorreo1Old() {
	return correo1Old;
	}

	public void setCorreo1Old(String correo1Old) {
	this.correo1Old = correo1Old;
	}

	public String getCorreo1New() {
	return correo1New;
	}

	public void setCorreo1New(String correo1New) {
	this.correo1New = correo1New;
	}

	public Integer getEstado() {
	return estado;
	}

	public void setEstado(Integer estado) {
	this.estado = estado;
	}

	public String getAdicionadoPor() {
	return adicionadoPor;
	}

	public void setAdicionadoPor(String adicionadoPor) {
	this.adicionadoPor = adicionadoPor;
	}

	public String getFechaIngresado() {
	return fechaIngresado;
	}

	public void setFechaIngresado(String fechaIngresado) {
	this.fechaIngresado = fechaIngresado;
	}

	public String getFuente() {
	return fuente;
	}

	public void setFuente(String fuente) {
	this.fuente = fuente;
	}

	public String getValid() {
	return valid;
	}

	public void setValid(String valid) {
	this.valid = valid;
	}

	public String getIdAad() {
	return idAad;
	}

	public void setIdAad(String idAad) {
	this.idAad = idAad;
	}
	
	public String getNit() {
		return nit;
	}

	public String getNombreNew() {
		return nombreNew;
	}

	public String getNombreOld() {
		return nombreOld;
	}

	public String getPrimerNombreOld() {
		return primerNombreOld;
	}

	public String getPrimerNombreNew() {
		return primerNombreNew;
	}

	public String getSegundoNombreOld() {
		return segundoNombreOld;
	}

	public String getSegundoNombreNew() {
		return segundoNombreNew;
	}

	public String getPrimerApellidoOld() {
		return primerApellidoOld;
	}

	public String getPrimerApellidoNew() {
		return primerApellidoNew;
	}

	public String getSegundoApellidoOld() {
		return segundoApellidoOld;
	}

	public String getSegundoApellidoNew() {
		return segundoApellidoNew;
	}

	public String getApellidoCasadaNew() {
		return apellidoCasadaNew;
	}

	public String getApellidoCasadaOld() {
		return apellidoCasadaOld;
	}

	public String getTelefono1Old() {
		return telefono1Old;
	}

	public String getTelefono1New() {
		return telefono1New;
	}

	public String getTelefono2New() {
		return telefono2New;
	}

	public String getTelefono2Old() {
		return telefono2Old;
	}

	public String getTipoDocumentoOld() {
		return tipoDocumentoOld;
	}

	public String getTipoDocumentoNew() {
		return tipoDocumentoNew;
	}

	public String getNumeroDocumentoOld() {
		return numeroDocumentoOld;
	}

	public String getNumeroDocumentoNew() {
		return numeroDocumentoNew;
	}

	public String getFechaNacimientoOld() {
		return fechaNacimientoOld;
	}

	public String getFechaNacimientoNew() {
		return fechaNacimientoNew;
	}

	public String getCorreo2Old() {
		return correo2Old;
	}

	public String getCorreo2New() {
		return correo2New;
	}

	public String getIndEstadoRegistroOld() {
		return indEstadoRegistroOld;
	}

	public String getIndEstadoRegistroNew() {
		return indEstadoRegistroNew;
	}

	public String getEstadoAfiliadoOld() {
		return estadoAfiliadoOld;
	}

	public String getEstadoAfiliadoNew() {
		return estadoAfiliadoNew;
	}

	public String getFechaProcesado() {
		return fechaProcesado;
	}

	public String getFechaModificado() {
		return fechaModificado;
	}

	public String getModificadoPor() {
		return modificadoPor;
	}

	public String getUsuarioWebOld() {
		return usuarioWebOld;
	}

	public String getUsuarioWebNew() {
		return usuarioWebNew;
	}

	public Integer getReproceso() {
		return reproceso;
	}

	public void setNit(String nit) {
		this.nit = nit;
	}

	public void setNombreNew(String nombreNew) {
		this.nombreNew = nombreNew;
	}

	public void setNombreOld(String nombreOld) {
		this.nombreOld = nombreOld;
	}

	public void setPrimerNombreOld(String primerNombreOld) {
		this.primerNombreOld = primerNombreOld;
	}

	public void setPrimerNombreNew(String primerNombreNew) {
		this.primerNombreNew = primerNombreNew;
	}

	public void setSegundoNombreOld(String segundoNombreOld) {
		this.segundoNombreOld = segundoNombreOld;
	}

	public void setSegundoNombreNew(String segundoNombreNew) {
		this.segundoNombreNew = segundoNombreNew;
	}

	public void setPrimerApellidoOld(String primerApellidoOld) {
		this.primerApellidoOld = primerApellidoOld;
	}

	public void setPrimerApellidoNew(String primerApellidoNew) {
		this.primerApellidoNew = primerApellidoNew;
	}

	public void setSegundoApellidoOld(String segundoApellidoOld) {
		this.segundoApellidoOld = segundoApellidoOld;
	}

	public void setSegundoApellidoNew(String segundoApellidoNew) {
		this.segundoApellidoNew = segundoApellidoNew;
	}

	public void setApellidoCasadaNew(String apellidoCasadaNew) {
		this.apellidoCasadaNew = apellidoCasadaNew;
	}

	public void setApellidoCasadaOld(String apellidoCasadaOld) {
		this.apellidoCasadaOld = apellidoCasadaOld;
	}

	public void setTelefono1Old(String telefono1Old) {
		this.telefono1Old = telefono1Old;
	}

	public void setTelefono1New(String telefono1New) {
		this.telefono1New = telefono1New;
	}

	public void setTelefono2New(String telefono2New) {
		this.telefono2New = telefono2New;
	}

	public void setTelefono2Old(String telefono2Old) {
		this.telefono2Old = telefono2Old;
	}

	public void setTipoDocumentoOld(String tipoDocumentoOld) {
		this.tipoDocumentoOld = tipoDocumentoOld;
	}

	public void setTipoDocumentoNew(String tipoDocumentoNew) {
		this.tipoDocumentoNew = tipoDocumentoNew;
	}

	public void setNumeroDocumentoOld(String numeroDocumentoOld) {
		this.numeroDocumentoOld = numeroDocumentoOld;
	}

	public void setNumeroDocumentoNew(String numeroDocumentoNew) {
		this.numeroDocumentoNew = numeroDocumentoNew;
	}

	public void setFechaNacimientoOld(String fechaNacimientoOld) {
		this.fechaNacimientoOld = fechaNacimientoOld;
	}

	public void setFechaNacimientoNew(String fechaNacimientoNew) {
		this.fechaNacimientoNew = fechaNacimientoNew;
	}

	public void setCorreo2Old(String correo2Old) {
		this.correo2Old = correo2Old;
	}

	public void setCorreo2New(String correo2New) {
		this.correo2New = correo2New;
	}

	public void setIndEstadoRegistroOld(String indEstadoRegistroOld) {
		this.indEstadoRegistroOld = indEstadoRegistroOld;
	}

	public void setIndEstadoRegistroNew(String indEstadoRegistroNew) {
		this.indEstadoRegistroNew = indEstadoRegistroNew;
	}

	public void setEstadoAfiliadoOld(String estadoAfiliadoOld) {
		this.estadoAfiliadoOld = estadoAfiliadoOld;
	}

	public void setEstadoAfiliadoNew(String estadoAfiliadoNew) {
		this.estadoAfiliadoNew = estadoAfiliadoNew;
	}

	public void setFechaProcesado(String fechaProcesado) {
		this.fechaProcesado = fechaProcesado;
	}

	public void setFechaModificado(String fechaModificado) {
		this.fechaModificado = fechaModificado;
	}

	public void setModificadoPor(String modificadoPor) {
		this.modificadoPor = modificadoPor;
	}

	public void setUsuarioWebOld(String usuarioWebOld) {
		this.usuarioWebOld = usuarioWebOld;
	}

	public void setUsuarioWebNew(String usuarioWebNew) {
		this.usuarioWebNew = usuarioWebNew;
	}

	public void setReproceso(Integer reproceso) {
		this.reproceso = reproceso;
	}

	public JSONCSActualizaDato(Integer idActualizacion, String fechaActualizacion, String tipoDocumentoAd, String nit,
			String numId, String fechaNacimientoAd, String nup, String nombreNew, String nombreOld,
			String primerNombreOld, String primerNombreNew, String segundoNombreOld, String segundoNombreNew,
			String primerApellidoOld, String primerApellidoNew, String segundoApellidoOld, String segundoApellidoNew,
			String apellidoCasadaNew, String apellidoCasadaOld, String telefono1Old, String telefono1New,
			String telefono2New, String telefono2Old, String tipoDocumentoOld, String tipoDocumentoNew,
			String numeroDocumentoOld, String numeroDocumentoNew, String fechaNacimientoOld, String fechaNacimientoNew,
			String correo1Old, String correo1New, String correo2Old, String correo2New, String indEstadoRegistroOld,
			String indEstadoRegistroNew, String estadoAfiliadoOld, String estadoAfiliadoNew, Integer estado,
			String adicionadoPor, String fechaIngresado, String fechaProcesado, String fechaModificado,
			String modificadoPor, String fuente, String usuarioWebOld, String usuarioWebNew, String valid, String idAad,
			String mensaje, Integer reproceso) {
		super();
		this.idActualizacion = idActualizacion;
		this.fechaActualizacion = fechaActualizacion;
		this.tipoDocumentoAd = tipoDocumentoAd;
		this.nit = nit;
		this.numId = numId;
		this.fechaNacimientoAd = fechaNacimientoAd;
		this.nup = nup;
		this.nombreNew = nombreNew;
		this.nombreOld = nombreOld;
		this.primerNombreOld = primerNombreOld;
		this.primerNombreNew = primerNombreNew;
		this.segundoNombreOld = segundoNombreOld;
		this.segundoNombreNew = segundoNombreNew;
		this.primerApellidoOld = primerApellidoOld;
		this.primerApellidoNew = primerApellidoNew;
		this.segundoApellidoOld = segundoApellidoOld;
		this.segundoApellidoNew = segundoApellidoNew;
		this.apellidoCasadaNew = apellidoCasadaNew;
		this.apellidoCasadaOld = apellidoCasadaOld;
		this.telefono1Old = telefono1Old;
		this.telefono1New = telefono1New;
		this.telefono2New = telefono2New;
		this.telefono2Old = telefono2Old;
		this.tipoDocumentoOld = tipoDocumentoOld;
		this.tipoDocumentoNew = tipoDocumentoNew;
		this.numeroDocumentoOld = numeroDocumentoOld;
		this.numeroDocumentoNew = numeroDocumentoNew;
		this.fechaNacimientoOld = fechaNacimientoOld;
		this.fechaNacimientoNew = fechaNacimientoNew;
		this.correo1Old = correo1Old;
		this.correo1New = correo1New;
		this.correo2Old = correo2Old;
		this.correo2New = correo2New;
		this.indEstadoRegistroOld = indEstadoRegistroOld;
		this.indEstadoRegistroNew = indEstadoRegistroNew;
		this.estadoAfiliadoOld = estadoAfiliadoOld;
		this.estadoAfiliadoNew = estadoAfiliadoNew;
		this.estado = estado;
		this.adicionadoPor = adicionadoPor;
		this.fechaIngresado = fechaIngresado;
		this.fechaProcesado = fechaProcesado;
		this.fechaModificado = fechaModificado;
		this.modificadoPor = modificadoPor;
		this.fuente = fuente;
		this.usuarioWebOld = usuarioWebOld;
		this.usuarioWebNew = usuarioWebNew;
		this.valid = valid;
		this.idAad = idAad;
		this.mensaje = mensaje;
		this.reproceso = reproceso;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	@Override
	public String toString() {
		return "{ idActualizacion:" + idActualizacion 
				+ ", fechaActualizacion:" + fechaActualizacion
				+ ", tipoDocumentoAd:" + tipoDocumentoAd 
				+ ", numId:" + numId 
				+ ", fechaNacimientoAd:"+ fechaNacimientoAd 
				+ ", nup:" + nup 
				+ ", correo1Old:" + correo1Old 
				+ ", correo1New:" + correo1New
				+ ", estado:" + estado 
				+ ", adicionadoPor=" + adicionadoPor 
				+ ", fechaIngresado:" + fechaIngresado
				+ ", fuente:" + fuente 
				+ ", valid:" + valid 
				+ ", idAad:" + idAad
				+ ", mensaje:" + mensaje
				+ "}";
	
	}

	public String parseStr() {
		
		return "{\"ID_ACTUALIZACION\":" +idActualizacion+
				",\"FECHA_ACTUALIZACION\":\"" +  fechaActualizacion+
				"\",\"TIPO_DOCUMENTO_AD\":\"" +  tipoDocumentoAd+
				"\",\"NIT\":\"" +  nit+
				"\",\"NUM_ID\":\"" + numId+
				"\",\"FECHA_NACIMIENTO_AD\":\"" +  fechaNacimientoAd+
				"\",\"NUP\":\"" +  nup+
				"\",\"NOMBRE_NEW\":\"" + nombreNew+
				"\",\"NOMBRE_OLD\":\"" + nombreOld+
				"\",\"PRIMER_NOMBRE_OLD\":\"" +  primerNombreOld+
				"\",\"PRIMER_NOMBRE_NEW\":\"" +  primerNombreNew+
				"\",\"SEGUNDO_NOMBRE_OLD\":\"" +  segundoNombreOld+
				"\",\"SEGUNDO_NOMBRE_NEW\":\"" +  segundoNombreNew+
				"\",\"PRIMER_APELLIDO_OLD\":\"" +  primerApellidoOld+
				"\",\"PRIMER_APELLIDO_NEW\":\"" +  primerApellidoNew+
				"\",\"SEGUNDO_APELLIDO_OLD\":\"" + segundoApellidoOld+
				"\",\"SEGUNDO_APELLIDO_NEW\":\"" + segundoApellidoNew+
				"\",\"APELLIDO_CASADA_NEW\":\""+apellidoCasadaNew+
				"\",\"APELLIDO_CASADA_OLD\":\"" +  apellidoCasadaOld+
				"\",\"TELEFONO1_OLD\":\"" + telefono1Old+
				"\",\"TELEFONO1_NEW\":\"" + telefono1New+
				"\",\"TELEFONO2_NEW\":\"" + telefono2New+
				"\",\"TELEFONO2_OLD\":\"" + telefono2Old+
				"\",\"TIPO_DOCUMENTO_OLD\":\"" +  tipoDocumentoOld+
				"\",\"TIPO_DOCUMENTO_NEW\":\"" +  tipoDocumentoNew+
				"\",\"NUMERO_DOCUMENTO_OLD\":\"" + numeroDocumentoOld+
				"\",\"NUMERO_DOCUMENTO_NEW\":\"" + numeroDocumentoNew+
				"\",\"FECHA_NACIMIENTO_OLD\":\"" + fechaNacimientoOld+
				"\",\"FECHA_NACIMIENTO_NEW\":\"" + fechaNacimientoNew+
				"\",\"CORREO1_OLD\":\"" + correo1Old+
				"\",\"CORREO1_NEW\":\"" + correo1New+
				"\",\"CORREO2_OLD\":\"" + correo2Old+
				"\",\"CORREO2_NEW\":\"" + correo2New+
				"\",\"IND_ESTADO_REGISTRO_OLD\":\"" +  indEstadoRegistroOld+
				"\",\"IND_ESTADO_REGISTRO_NEW\":\"" +  indEstadoRegistroNew+
				"\",\"ESTADO_AFILIADO_OLD\":\"" + estadoAfiliadoOld+
				"\",\"ESTADO_AFILIADO_NEW\":\"" + estadoAfiliadoNew+
				"\",\"ESTADO\":\"" +  estado+
				"\",\"ADICIONADO_POR\":\"" + adicionadoPor+
				"\",\"FECHA_INGRESADO\":\"" + fechaIngresado+
				"\",\"FECHA_PROCESADO\":\"" + fechaProcesado+
				"\",\"FECHA_MODIFICADO\":\"" + fechaModificado+
				"\",\"MODIFICADO_POR\":\"" + modificadoPor+
				"\",\"FUENTE\":\"" +  fuente+
				"\",\"USUARIO_WEB_OLD\":\"" + usuarioWebOld+
				"\",\"USUARIO_WEB_NEW\":\"" + usuarioWebNew+
				"\",\"VALID\":\"" + valid+
				"\",\"ID_AAD\":\"" + idAad+
				"\",\"MENSAJE\":\"" +mensaje+
				"\",\"REPROCESO\":\"" + reproceso+"\"}";
	}
	
	
	@SuppressWarnings({"serial","rawtypes", "unchecked"})
	public Map<String, String> parseMap() {
		
	
	Map map = new HashMap<String, String>() {{
		put("ID_ACTUALIZACION",idActualizacion+"");
		put("FECHA_ACTUALIZACION", fechaActualizacion);
		put("TIPO_DOCUMENTO_AD", tipoDocumentoAd);
		put("NIT", nit);
		put("NUM_ID",numId);
		put("FECHA_NACIMIENTO_AD", fechaNacimientoAd);
		put("NUP", nup);
		put("NOMBRE_NEW",nombreNew);
		put("NOMBRE_OLD",nombreOld);
		put("PRIMER_NOMBRE_OLD", primerNombreOld);
		put("PRIMER_NOMBRE_NEW", primerNombreNew);
		put("SEGUNDO_NOMBRE_OLD", segundoNombreOld);
		put("SEGUNDO_NOMBRE_NEW", segundoNombreNew);
		put("PRIMER_APELLIDO_OLD", primerApellidoOld);
		put("PRIMER_APELLIDO_NEW", primerApellidoNew);
		put("SEGUNDO_APELLIDO_OLD",segundoApellidoOld);
		put("SEGUNDO_APELLIDO_NEW",segundoApellidoNew);
		put("APELLIDO_CASADA_NEW",apellidoCasadaNew);
		put("APELLIDO_CASADA_OLD", apellidoCasadaOld);
		put("TELEFONO1_OLD",telefono1Old);
		put("TELEFONO1_NEW",telefono1New);
		put("TELEFONO2_NEW",telefono2New);
		put("TELEFONO2_OLD",telefono2Old);
		put("TIPO_DOCUMENTO_OLD", tipoDocumentoOld);
		put("TIPO_DOCUMENTO_NEW", tipoDocumentoNew);
		put("NUMERO_DOCUMENTO_OLD",numeroDocumentoOld);
		put("NUMERO_DOCUMENTO_NEW",numeroDocumentoNew);
		put("FECHA_NACIMIENTO_OLD",fechaNacimientoOld);
		put("FECHA_NACIMIENTO_NEW",fechaNacimientoNew);
		put("CORREO1_OLD",correo1Old);
		put("CORREO1_NEW",correo1New);
		put("CORREO2_OLD",correo2Old);
		put("CORREO2_NEW",correo2New);
		put("IND_ESTADO_REGISTRO_OLD", indEstadoRegistroOld);
		put("IND_ESTADO_REGISTRO_NEW", indEstadoRegistroNew);
		put("ESTADO_AFILIADO_OLD",estadoAfiliadoOld);
		put("ESTADO_AFILIADO_NEW",estadoAfiliadoNew);
		put("ESTADO", estado+"");
		put("ADICIONADO_POR",adicionadoPor);
		put("FECHA_INGRESADO",fechaIngresado);
		put("FECHA_PROCESADO",fechaProcesado);
		put("FECHA_MODIFICADO",fechaModificado);
		put("MODIFICADO_POR",modificadoPor); 	
		put("FUENTE", fuente);
		put("USUARIO_WEB_OLD",usuarioWebOld);
		put("USUARIO_WEB_NEW",usuarioWebNew);
		put("VALID",valid);
		put("ID_AAD",idAad);
		put("MENSAJE",mensaje);
		put("REPROCESO",reproceso+"");
	}};
		
		return map;
	}
}
