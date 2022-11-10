package com.datum.confia.cps.model;

import java.util.Date;
import java.util.Map;

import javax.annotation.Generated;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

@Generated("jsonschema2pojo")
public class JSONDato1 {
	
	@SerializedName("id")
	@Expose
	private String id;
	@SerializedName("origen")
	@Expose
	private String origen;
	@SerializedName("categoria")
	@Expose
	private String categoria;
	@SerializedName("mensaje")
	@Expose
	private String mensaje;
	@SerializedName("fecha")
	@Expose
	private Date fecha;
	@SerializedName("identificacion")
	@Expose
	private Map<String,String> identificacion;
	@SerializedName("valores")
	@Expose
	private Map<String,String> valores;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getCategoria() {
		return categoria;
	}
	public void setCategoria(String categoria) {
		this.categoria = categoria;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public Map<String, String> getIdentificacion() {
		return identificacion;
	}
	public void setIdentificacion(Map<String, String> identificacion) {
		this.identificacion = identificacion;
	}
	public Map<String, String> getValores() {
		return valores;
	}
	public void setValores(Map<String, String> valores) {
		this.valores = valores;
	}
	
	public String getMensaje() {
		return mensaje;
	}
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	@Override
	public String toString() {
		return "JSONDato1 [id=" + id + ", origen=" + origen + ", categoria=" + categoria + ", fecha=" + fecha
				+ ", identificacion=" + identificacion + ", valores=" + valores + "]";
	}
	
	
	public String parseStr() { 
		
		
		
		 ObjectMapper converter = new ObjectMapper();
		 String identificacionJson = null;
		 String valoresJson = null;
		 
	        try {
	        	identificacionJson = converter.writeValueAsString(identificacion);
	        	valoresJson = converter.writeValueAsString(valores);

	        } catch (JsonProcessingException e) {
	            e.printStackTrace();
	        }
		
		return "{\"id\":\"" + id + "\""
				+ ",  \"origen\":\"" + origen+ "\"" 
				+ ", \"categoria\":\"" + categoria + "\""
				+ ", \"fecha\":\"" + fecha + "\""
				+ ", \"mensaje\":\"" + mensaje + "\""
				+ ", \"identificacion \":" + identificacionJson 
				+ ", \"valores\":" + valoresJson 
				+ "}";
	}
	
	public JSONDato1(String id, String origen, String categoria, Date fecha, Map<String, String> identificacion,
			Map<String, String> valores) {
		super();
		this.id = id;
		this.origen = origen;
		this.categoria = categoria;
		this.fecha = fecha;
		this.identificacion = identificacion;
		this.valores = valores;
	}
	public JSONDato1() {
		
	}
	
	
}
