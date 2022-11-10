package com.datum.confia.cps.services;

import org.apache.camel.Body;
import org.apache.xerces.impl.dv.util.Base64;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.datum.confia.cps.model.JSONCSActualizaDato;
import com.datum.confia.cps.model.entity.EEstado;
import com.google.gson.Gson;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;


@Service
public class ADUserConsultUniRestService {
	
	
	Logger log = LoggerFactory.getLogger(ADUserConsultUniRestService.class);
	
	private static final String NODE_VALUE = "value";
	
	private Properties oAuthProperties = null;
	private String clientId = null; 
	private String clientSecret = null;
	private String tenant = null;
	private String cURL = null;
	private String scope = null;

	/**
	 * Se valida el usuario
	 * 
	 * @param input
	 * @return
	 * @throws Exception
	 */
	
	public String isValidUser(@Body String input )  {
		

		JSONCSActualizaDato data = new Gson().fromJson(input, JSONCSActualizaDato.class);
		String tipDoc = data.getTipoDocumentoAd();
		String numDoc = data.getNumId();
		String fechaNac = data.getFechaNacimientoAd();
	
		if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
		
		String evalauator="%20EQ%20'";
		String andCondition="'%20and%20";
		
		StringBuilder param = new StringBuilder();
		
		param.append( oAuthProperties.getProperty("graph_uri") );
		// Se comenta porque la fecha se obtendra de labase dea datros puesto que para empresas ya se envia ese campo corregido.

		param.append(tenant)
		  .append("/users?&filter=")
		  .append(oAuthProperties.getProperty("filtro_1")).append(evalauator).append(fechaNac)
		  .append(andCondition)
		  .append(oAuthProperties.getProperty("filtro_2")).append(evalauator).append(tipDoc)
		  .append(andCondition)
		  .append(oAuthProperties.getProperty("filtro_3")).append(evalauator).append(numDoc).append("'");

		
    	Map<String, String> headers = new HashMap<>();
        headers.put("Accept", "*/*");
        headers.put("Authorization", "Bearer "+tmpToken);
        headers.put("Accept-Encoding", "gzip, deflate, br");
        headers.put("Connection","keep-alive");
    	headers.put("User-Agent", "CPS");
	    HttpResponse<JsonNode> jsonResponse;
		try {
			
			log.warn( " isValidUser -> headers envaidos al AD -> " + headers );
			log.warn(" isValidUser -> param -> " + param.toString());
			
			jsonResponse = Unirest.get(param.toString()).headers(headers).asJson();
			
			 for( Object regsitro : jsonResponse.getBody().getObject().getJSONArray( NODE_VALUE ) ) {
			    	org.json.JSONObject registro = ( (org.json.JSONObject) regsitro );
			    	data.setIdAad( registro.getString("id") );
			    }
			 
			 log.warn( " isValidUser -> Respuesta AD -> " + jsonResponse.getBody() );			 
			 log.warn( " isValidUser -> Respuesta length AD  -> " + jsonResponse.getBody().getObject().getJSONArray( NODE_VALUE ).length() );
			 
		     data.setValid( jsonResponse.getBody().getObject().getJSONArray( NODE_VALUE ).length() == 1 ? EEstado.PENDIENTE.ordinal()+"" : EEstado.ANULADO.ordinal()+"");
		        			    
		} catch (UnirestException e) {
			log.error(e.getMessage());
			e.printStackTrace();
			data.setMensaje( e.getMessage() );
		}catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
			data.setMensaje( e.getMessage() );
		}
	    
		return data.parseStr();
	    
    }
    
  
	public String isValidUser(String tipDoc, String numDoc, String fechaNac ) {
		
		if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
		
		String evalauator="%20EQ%20'";
		String andCondition="'%20and%20";
		
		StringBuilder param = new StringBuilder();
		
		param.append( oAuthProperties.getProperty("graph_uri") );

			param.append(tenant)
				  .append("/users?&filter=")
				  .append(oAuthProperties.getProperty("filtro_1")).append(evalauator).append(fechaNac)
				  .append(andCondition)
				  .append(oAuthProperties.getProperty("filtro_2")).append(evalauator).append(tipDoc)
				  .append(andCondition)
				  .append(oAuthProperties.getProperty("filtro_3")).append(evalauator).append(numDoc).append("'");

    	Map<String, String> headers = new HashMap<>();
        headers.put("Accept", "*/*");
        headers.put("Authorization", "Bearer "+tmpToken);
        headers.put("Accept-Encoding", "gzip, deflate, br");
        headers.put("Connection","keep-alive");
    	headers.put("User-Agent", "CPS");
    	
	    HttpResponse<JsonNode> jsonResponse;
	    
	    log.warn( " isValidUser -> headers envaidos al AD" + headers );
		log.warn(" isValidUser -> param" + param.toString());
		
		try {
			jsonResponse = Unirest.get(param.toString()).headers(headers).asJson();
			
			 log.warn( " isValidUser -> Respuesta AD  " + jsonResponse.getBody() );
			 
			 log.warn( " isValidUser -> Respuesta length AD  " + jsonResponse.getBody().getObject().getJSONArray( NODE_VALUE ).length() );
			 
			return jsonResponse.getBody().getObject().getJSONArray( NODE_VALUE ).length() == 1 ? "Si" : "No";
			
			
		} catch (UnirestException e) {
			log.error(e.getMessage());
			e.printStackTrace();
			return null;
		}
	    	    
	    
    }
	
	/**
	 * Se optine el token de graph
	 * @return
	 */
    @SuppressWarnings("null")
	public String initializeGraphAuth() {
    	
    	if(oAuthProperties==null) loadConfig();

    	StringBuilder body = new StringBuilder();
    	body.append("grant_type=client_credentials&")
    	    .append("client_id=").append( clientId ).append("&")
    		.append("client_secret=").append( clientSecret ).append("&")
    		.append("scope=").append( scope );
    	
    	HttpResponse<JsonNode> jsonResponse  = null;
    	
    	try {
    		jsonResponse = Unirest.post(cURL)
								 .header("content-type", "application/x-www-form-urlencoded")
								 .body( body.toString() )
								 .asJson();
			 
			return (String) jsonResponse.getBody().getObject().get("access_token");
			
		} catch (UnirestException e) {
			log.error( jsonResponse.toString() );
			log.error( body.toString() );
			e.printStackTrace();
			return e.getMessage();
		}
    }
    
    
    
    /**
     * Se cargan las cofifuraciones del conexion a graph
     */
    private void loadConfig() {
    	
    	try {
    		
    		oAuthProperties = new Properties();
    		String dir = System.getProperties().getProperty("jboss.server.config.dir");
    		
    		File configFile = new File(dir.concat("/cps-onpremises.properties"));    		
    		
    		oAuthProperties.load( new FileInputStream( configFile ) );
    		
    		clientId = new String( Base64.decode( oAuthProperties.getProperty("clientId") ) ); 
    		clientSecret = new String( Base64.decode( oAuthProperties.getProperty("clientSecret") ) );
    		tenant =  new String( Base64.decode( oAuthProperties.getProperty("tenant") ) );
    		cURL = new String( Base64.decode( oAuthProperties.getProperty("cURL") ) );
    		scope =  new String( Base64.decode( oAuthProperties.getProperty("scope") ) );    		
    	
		} catch (Exception e) {
			e.printStackTrace();		    
		}finally {
			log.warn(" PASO B1:Fin lectura parametros AAD");
		}
    	
    }
    
}
