package com.datum.confia.cps.services;



import org.apache.camel.Body;
import org.apache.xerces.impl.dv.util.Base64;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.datum.confia.cps.model.JSONCSActualizaDato;
import com.datum.confia.cps.model.entity.EEstado;
import com.google.gson.Gson;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;


@Service("AADService")
public class AADService {
	
	Logger log = LoggerFactory.getLogger( AADService.class );
	
	public static final String KEEP_ALIVE = "keep-alive";
	public static final String FILTRO_1   = "filtro_1";
	public static final String FILTRO_2   = "filtro_2";
	public static final String FILTRO_3   = "filtro_3";
	public static final String IDENTITIES   = "identities";
	public static final String VALUE   = "value";
												  
	public static final String APPLICATION_JSON = "application/json";
	public static final String CONNECTION ="Connection";
	public static final String USER_AGENT = "User-Agent";
	public static final String ACCEPT = "Accept";
	public static final String AUTHORIZATION = "Authorization";
	public static final String ACCEPT_ENCODING = "Accept-Encoding";
	public static final String USER_AND_FILTER = "/users?&filter=";
	public static final String CONTENT_TYPE = "Content-Type";
	
	@Value("${cps.mulitiregion}")
	private boolean mulitiregion;
	@Value("${cps.prefijo.tel}")
	private String prefijoTel;
	@Value("${cps.document_bussines}")
	private String documentBussines;
	@Value("${cps.graph_authentication_phone}")
	private String graphAuthenticationPhoneUrl;
	@Value("${cps.graph_authentication_phone_mobil}")
	private String graphAuthenticationPhoneMobilId;
	@Value("${graph_update_authentication_email}")
	private String graphUpdateAuthenticationEmail;
	@Value("${graph_authentication_phone_email_id}")
	private String graphUpdateAuthenticationEmailId;
	
	private Properties oAuthProperties = null;
	private String clientId = null; 
	private String clientSecret = null;
	private String tenant = null;
	private String cURL = null;
	private String scope = null;

	private static final String CONFIG_FILE="/opt/fuse/jboss-eap-7.2/cps-azure.properties";
	
	
	/**
	 * Se valida el usuario
	 * 
	 * @return
	 * @throws Exception
	 */
	
	public String deleteUser(String input) {
		
		if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
		//TODO el metodo email para autentificacion solo aplicas para empresas.
		//TODO El metodo de telefono solo aplica para afiliados y empresas en los metodos de autenficacion del AAD.	
    	Map<String, String> headers = getHeaderGraph(tmpToken);
    	
    	String uri = oAuthProperties.getProperty("graph_delete").concat(input);
    	
       	log.warn("uri {}", uri);
	    HttpResponse<String> jsonResponse = null;
	    
		try {
			jsonResponse = Unirest.delete(uri).headers(headers).asString();
		} catch (UnirestException e) {
		
			e.printStackTrace();
		}
        
        return jsonResponse.getBody();
    }
    
  
	public String isValidUser(String tipDoc, String numDoc, String fechaNac ) throws Exception {
		
		if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
		
		String evalauator="%20EQ%20'";
		String andCondition="'%20and%20";
		
		StringBuilder param = new StringBuilder();
		
		param.append( oAuthProperties.getProperty("graph_uri") );
		
		param.append(tenant)
		  .append(USER_AND_FILTER)
		  .append(oAuthProperties.getProperty(FILTRO_1)).append(evalauator).append(fechaNac)
		  .append(andCondition)
		  .append(oAuthProperties.getProperty(FILTRO_2)).append(evalauator).append(tipDoc)
		  .append(andCondition)
		  .append(oAuthProperties.getProperty(FILTRO_3)).append(evalauator).append(numDoc).append("'");
			
    	Map<String, String> headers = getHeaderGraph(tmpToken);
    	
	    HttpResponse<JsonNode> jsonResponse = Unirest.get(param.toString()).headers(headers).asJson();
	    
	    return jsonResponse.getBody().getObject().getJSONArray( VALUE ).length() == 1 ? "Si" : "No";
    }
	
	
	public JSONObject getDataUser(String tipDoc, String numDoc, String fechaNac ) throws Exception {
		
		if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
		
		String evalauator="%20EQ%20'";
		String andCondition="'%20and%20";
		
		StringBuilder param = new StringBuilder();
		
		param.append( oAuthProperties.getProperty("graph_uri") );

			param.append(tenant)
			  .append(USER_AND_FILTER)
			  .append(oAuthProperties.getProperty(FILTRO_1)).append(evalauator).append(fechaNac)
			  .append(andCondition)
			  .append(oAuthProperties.getProperty(FILTRO_2)).append(evalauator).append(tipDoc)
			  .append(andCondition)
			  .append(oAuthProperties.getProperty(FILTRO_3)).append(evalauator).append(numDoc).append("'");

    	Map<String, String> headers = new HashMap<>();
        headers.put(ACCEPT, "*/*");
        headers.put(AUTHORIZATION, "Bearer "+tmpToken);
        headers.put(ACCEPT_ENCODING, "gzip, deflate, br");
        headers.put(CONNECTION,KEEP_ALIVE);
    	headers.put(USER_AGENT, "CPS");
    	
	    HttpResponse<JsonNode> jsonResponse = Unirest.get(param.toString()).headers(headers).asJson();
	    
	    return jsonResponse.getBody().getObject();
    }

	public String updateUser( JSONCSActualizaDato data ) throws Exception {
		log.info("updateUser - inicio");
		if(oAuthProperties==null) loadConfig();
		
		StringBuilder sb = new StringBuilder();
		
		String tmpToken = initializeGraphAuth();
	
    	Map<String, String> headers = getHeaderGraph(tmpToken);
    	
    	String b2cExtensionApp = oAuthProperties.getProperty("b2c_extension_app");
    	String extension = "\"extension_".concat(b2cExtensionApp);
    	int validaCampos = 0;

        sb.append("{");
        
		if (  ( validFields( data.getPrimerNombreNew() ) || validFields( data.getPrimerNombreOld() ) )  ) {
			sb.append( extension ).append( "_primerNombre\": \"").append( data.getPrimerNombreNew() ).append("\",");
			++validaCampos;
		}
		
		if ( ( validFields( data.getSegundoNombreNew() ) || validFields( data.getSegundoNombreOld() ) ) ) {
			sb.append( extension ).append( "_segundoNombre\": \"").append( data.getSegundoNombreNew() ).append("\",");
			++validaCampos;
		}
		
		if ( ( validFields( data.getPrimerApellidoNew() ) || validFields( data.getPrimerApellidoOld() ) )  ) {
			sb.append( extension ).append( "_primerApellido\": \"").append( data.getPrimerApellidoNew() ).append("\",");
			++validaCampos;
		}
		if ( ( validFields( data.getSegundoApellidoNew() )  || validFields( data.getSegundoApellidoOld() )  ) ) {
			sb.append( extension  ).append( "_segundoApellido\": \"").append( data.getSegundoApellidoNew() ).append("\",");
			++validaCampos;
		}
		if ( ( validFields( data.getApellidoCasadaNew() ) || validFields( data.getApellidoCasadaOld() ) ) ) {
			sb.append( extension ).append( "_apellidoCasada\": \"").append( data.getApellidoCasadaNew() ).append("\",");
			++validaCampos;
		}
		
		if ( validFields( data.getFechaNacimientoNew() ) || validFields( data.getFechaNacimientoOld() )) {
			sb.append( extension ).append( "_fechaNacimiento\": \"").append( data.getFechaNacimientoNew() ).append("\",");
			++validaCampos;
		}
		if ( validFields( data.getTipoDocumentoNew() ) ) {
			sb.append( extension ).append( "_tipoId\": \"").append( data.getTipoDocumentoNew() ).append("\",");
			++validaCampos;
		}
		if ( validFields( data.getNumeroDocumentoNew() ) || validFields( data.getNumeroDocumentoOld() ) ) {
			sb.append( extension  ).append( "_numId\": \"").append( data.getNumeroDocumentoNew() ).append("\",");
			++validaCampos;
		}    
		
		if ( ( validFields( data.getCorreo1New() ) || validFields( data.getCorreo1Old() )  ) &&  
				!documentBussines.equalsIgnoreCase( data.getTipoDocumentoAd() ))	{
			sb.append( "\"mail\": \"" ).append( data.getCorreo1New() ).append( "\"," );
			sb.append( extension ).append( "_correoElectronico1\": \"").append( data.getCorreo1New() ).append("\",");
			++validaCampos;
		}
		
		if ( ( validFields( data.getCorreo2New() ) || validFields( data.getCorreo2Old() ) )  ) 	{
			sb.append( extension ).append( "_correoElectronico2\": \"").append( data.getCorreo2New() ).append("\",");
			++validaCampos;
		}
		if ( validFields( data.getTelefono1New() ) || validFields( data.getTelefono1Old() )) {
			sb.append( extension  ).append( "_telefono1\": \"").append( data.getTelefono1New() ).append("\",");
			++validaCampos;
		}
		if ( validFields( data.getTelefono2New() ) || validFields( data.getTelefono2Old() )) {
			sb.append( extension ).append( "_telefono2\": \"").append( data.getTelefono2New() ).append("\",");
			++validaCampos;
		}

		if ( validFields( data.getNombreNew() ) || validFields( data.getNombreOld() )) {
			sb.append( "\"displayName\": \"" ).append( data.getNombreNew() ).append( "\"," );
			sb.append( "\"givenName\": \"" ).append( data.getNombreNew() ).append( "\"," );
			++validaCampos;
		}


        JSONObject dataUser = getDataUser( data.getTipoDocumentoAd(), data.getNumId(), data.getFechaNacimientoAd() );
        log.warn(dataUser.toString());
        JSONArray  usuarios = dataUser.getJSONArray( VALUE );
        
        for( Object registros : usuarios ) {
	    	 JSONObject registro = ( (org.json.JSONObject) registros );
	    	
	    	data.setIdAad( registro.getString("id") );
	    	
	    		String correoAnterior = null;
	
	    		JSONArray jsonArray = new JSONArray();
		    	for( Object identity : registro.getJSONArray(IDENTITIES) ) {
			    	 JSONObject k = ( (org.json.JSONObject) identity );
			    	
			    	 if ( k.getString( "signInType" ).equals( "emailAddress") ) {
			    		 correoAnterior = k.getString("issuerAssignedId");
			    	 }else {
			    		 jsonArray.put(k);
			    	 }
		    	}
		    	
		    	if ( correoAnterior == null && !documentBussines.equalsIgnoreCase( data.getTipoDocumentoAd() ) ) {
		    		log.debug("No se encontro identities");
		    		return "No se encontro identities";		    		
		    	}
		    	
		    	String identitiesNuevo = registro.getJSONArray( IDENTITIES ).toString();
		    	if ( validFields( data.getCorreo1New() )  && !documentBussines.equalsIgnoreCase( data.getTipoDocumentoAd() ) ) {
		    		identitiesNuevo = registro.getJSONArray( IDENTITIES ).toString().replace( correoAnterior, data.getCorreo1New());		    		
	        	} 
		    	
		    	if ( correoAnterior != null && documentBussines.equalsIgnoreCase( data.getTipoDocumentoAd() ) 
		    			&& jsonArray.length() > 0
		            ) {
		    		identitiesNuevo = jsonArray.toString();		    		
	        	}
		    	
		    	sb.append("\"identities\":");
		    	sb.append(identitiesNuevo);
		    	
	    }
        
        sb.append("}");
        
        log.warn("Json Enviado {}",sb);
       
        String uri = oAuthProperties.getProperty("graph_update").concat(data.getIdAad());
        log.warn("url cambio data usuario ", uri );
        /**
         * Validacion de persona 
         * */
        if ( validaCampos > 0 ) { 
	        HttpResponse<String> jsonResponse = Unirest.patch(uri).headers(headers).body(sb.toString()).asString();
	        log.warn("respuest de actulizacion de campos {}", jsonResponse.getBody() );   
		    return jsonResponse.getBody();
		}
        /**
         * Validacion e empreas
         */
        if ( validFields( data.getCorreo1New() ) && documentBussines.equalsIgnoreCase( data.getTipoDocumentoAd() ))	{
        	HttpResponse<String> jsonResponse = Unirest.patch(uri).headers(headers).body(sb.toString()).asString();
 	        log.warn("respuest de actulizacion de campos {}", jsonResponse.getBody() );   
 		    return jsonResponse.getBody();
        }
        
        log.info("updateUser - Fin");
        log.warn("No hay datos que enviar");
        return "No hay datos que enviar";
	}
	
	
	public String update(@Body String input)  {
		log.warn("update String {}",input);
		
		if(oAuthProperties==null) loadConfig();
		
		JSONCSActualizaDato data = new Gson().fromJson(input, JSONCSActualizaDato.class);
		log.warn("update data idActualizacion [{}]",data.getIdActualizacion() );
		String respuesta = null;


		if(  ( data.getIndEstadoRegistroNew().equalsIgnoreCase("I") || data.getIndEstadoRegistroNew().equalsIgnoreCase("V") || data.getIndEstadoRegistroNew().equalsIgnoreCase("L") )  
		     || (  data.getIndEstadoRegistroNew().equalsIgnoreCase("A")  && data.getEstadoAfiliadoNew().equalsIgnoreCase("FCD") )  
		     || data.getUsuarioWebNew().equalsIgnoreCase("N") 
		     ) {
			
			     respuesta = deleteUser( data.getIdAad());
			 
		}else {
			 
				 
			if ( validFields(data.getTelefono1New()) ) {
				
				if( !mulitiregion ) {

					data.setTelefono1New( prefijoTel.trim().concat(" ").concat(data.getTelefono1New()) );
				}
				
				respuesta = saveOrUpdateAuthenticationPhoneMethods( data.getIdAad(),data.getTelefono1New() );
			}
				 
			 if( respuesta == null && validFields( data.getCorreo1New() ) && data.getTipoDocumentoAd().equalsIgnoreCase( documentBussines )) {
				 respuesta = updateAuthenticationEmailMethods( data.getIdAad(), data.getCorreo1New() );
			 }
				 
			 
			 if( respuesta == null ) {
				 try {
					 respuesta = updateUser( data );
				 }catch (Exception e) {
					e.printStackTrace();
					respuesta = e.getMessage();
				}
			 }
		}
		
		
		log.warn( "Respuesta estado de actualizacion graph {}", respuesta );
		
		if( respuesta == null) {
			data.setValid( EEstado.ACTUALIADO.ordinal()+"" );
		}else {
			data.setMensaje( respuesta.replace("\\\"", "" ).replace("\"", "").replace("''", ""));
			data.setValid( EEstado.FALLADO.ordinal()+"" );
			data.setReproceso( data.getReproceso() + 1 );
		}
		
		log.warn( "data trabajanda {}", data );
		
		return data.parseStr();
	}
	
	/**
	 * Se optine el token de graph
	 * @return
	 */
    public String initializeGraphAuth() {
    	
    	if(oAuthProperties==null) loadConfig();
    	
    	StringBuilder body = new StringBuilder();
    	body.append("grant_type=client_credentials&")
    	    .append("client_id=").append(clientId).append("&")
    		.append("client_secret=").append(clientSecret).append("&")
    		.append("scope=").append(scope);
        
    	try {
			HttpResponse<JsonNode> jsonResponse = Unirest.post(cURL)
														 .header("content-type", "application/x-www-form-urlencoded")
														 .body(body.toString())
														 .asJson();
			 
			return (String) jsonResponse.getBody().getObject().get("access_token");
			
		} catch (UnirestException e) {
			return e.getMessage();
		}
    }
      
    /**
     * Se cargan las cofifuraciones del conexion a graph
     */
    private void loadConfig() {
    	
    	try {
    		
    		oAuthProperties = new Properties();
    		
    		File configFile = new File(CONFIG_FILE);    		

    		oAuthProperties.load( new FileInputStream(configFile) );
    		
    		clientId = new String( Base64.decode( oAuthProperties.getProperty("clientId") )); 
    		clientSecret = new String( Base64.decode( oAuthProperties.getProperty("clientSecret")));
    		tenant =  new String( Base64.decode( oAuthProperties.getProperty("tenant")));
    		cURL = new String( Base64.decode( oAuthProperties.getProperty("cURL")));
    		scope =  new String( Base64.decode( oAuthProperties.getProperty("scope")));    		
    	
		} catch (Exception e) {
			e.printStackTrace();		    
		}
    	
    }
    
    
    public String saveOrUpdateAuthenticationPhoneMethods(String id, String phone){
    	log.info("saveOrUpdateAuthenticationPhoneMethods inicio");
    	String actualiza = checkAuthenticationPhoneMethods(id);
    	log.info("saveOrUpdateAuthenticationPhoneMethods actualiza [{}]", actualiza);
    	
    	if ( actualiza.equalsIgnoreCase("true") ) {
    		log.info("saveOrUpdateAuthenticationPhoneMethods-FIN");
    		return updateAuthenticationPhoneMethods(id, phone);
    	}else {
    		log.info("saveOrUpdateAuthenticationPhoneMethods-FIN");
        	return createAuthenticationPhoneMethods(id,phone);
    	}    	
    }
    
    public String updateAuthenticationPhoneMethods(String id, String phone) {
    	log.info("updateAuthenticationPhoneMethods - inicio");
    	
    	try {
	    	if(oAuthProperties==null) loadConfig();
			
			StringBuilder sb = new StringBuilder();
			
			String tmpToken = initializeGraphAuth();
		
	    	Map<String, String> headers = getHeaderGraph( tmpToken );
	    
	    	String authenticationPhoneParam = graphAuthenticationPhoneUrl.replace("{id}", id).concat(graphAuthenticationPhoneMobilId);
	    	
	    	log.warn("authenticationPhoneParam {}",authenticationPhoneParam);
	    	
	        sb.append("{")
	    	  .append("\"phoneNumber\": \"").append(phone).append("\",")
			  .append("\"phoneType\": \"mobile\",")
			  .append("}");
	               
	        HttpResponse<String> jsonResponse = Unirest.put(authenticationPhoneParam).headers(headers).body(sb.toString()).asString();
			log.warn("respuesta {}", jsonResponse.getBody());
		    
			if (jsonResponse.getStatus() == 200) {
				return null;
			}
		
			return jsonResponse.getBody();
        }catch(UnirestException e ) {
        	return e.getMessage();
        }finally {
        	log.info("updateAuthenticationPhoneMethods - fin");
		}
		
    }
    
    public String createAuthenticationPhoneMethods(String id, String phone) {
    	log.info("createAuthenticationPhoneMethods - inicio");
   	 try {
   	if(oAuthProperties==null) loadConfig();
		
		StringBuilder sb = new StringBuilder();
		
		String tmpToken = initializeGraphAuth();
	
   	Map<String, String> headers = getHeaderGraph( tmpToken ); 
   	
   	String authenticationPhoneParam = graphAuthenticationPhoneUrl.replace("{id}", id); 
   	
   	log.warn("authenticationPhoneParam {}",authenticationPhoneParam);
   	
       sb.append("{")
   	  .append("\"phoneNumber\": \"").append(phone).append("\",")
		  .append("\"phoneType\": \"mobile\",")
		  .append("}");
       
      
       HttpResponse<String> jsonResponse = Unirest.post(authenticationPhoneParam).headers(headers).body(sb.toString()).asString();
		log.warn("respuesta {}", jsonResponse.getBody());
	    
		if (jsonResponse.getStatus() == 200) {
			return null;
		}
			return jsonResponse.getBody();
       }catch(UnirestException e ) {
    	e.printStackTrace();
       	return e.getMessage();
       }finally {
    	   log.info("createAuthenticationPhoneMethods - FIN");
	}
		
   }

	public String checkAuthenticationPhoneMethods(String id) {
		log.info("checkAuthenticationPhoneMethods - INICIO");
   	 try {
   	if(oAuthProperties==null) loadConfig();
		
		String tmpToken = initializeGraphAuth();
	
   	Map<String, String> headers =getHeaderGraph(tmpToken);
    
   	String authenticationPhoneParam = graphAuthenticationPhoneUrl.replace("{id}", id); 
   	   
   	   log.warn("URL {}",authenticationPhoneParam);
   	   
       HttpResponse<JsonNode> jsonResponse = Unirest.get(authenticationPhoneParam).headers(headers).asJson();
		log.warn("respuesta {}", jsonResponse.getBody().getObject().get( VALUE ) );
	    
		if ( jsonResponse.getStatus() == 200 ) 
		{
			return jsonResponse.getBody().getObject().getJSONArray( VALUE ).length() > 0 ? "true" : "false";
		}
	
		
			return jsonResponse.getBody().getObject().toString();
       }catch(UnirestException e ) {
    	    e.printStackTrace();    	    
       		return e.getMessage();
       		
       }finally {
    	   log.info("checkAuthenticationPhoneMethods - FIN");
       }
		
   }
    
	public boolean validFields(String field) {
    	
		boolean valido = true;
		
    	if( field == null || field.isEmpty() || field.equals("null") || field.equals("")) {
    		valido = false;
    	} 
    	
    	return valido; 
    }
    
   public String updateAuthenticationEmailMethods(String id, String email) {
	   try {
	    	if(oAuthProperties==null) loadConfig();
			
			StringBuilder sb = new StringBuilder();
			
			String tmpToken = initializeGraphAuth();
		
	    	Map<String, String> headers = getHeaderGraph(tmpToken); 
	    	headers.put("Content-type:", APPLICATION_JSON);
	    	String authenticationEmailParam = oAuthProperties.getProperty("graph_update_authentication_email").replace("{id}", id); 
	
	        sb.append("{")
	          .append("\"emailAddress\": \"").append(email).append("\"")
	    	  .append("}");
	        
	        HttpResponse<String> jsonResponse = Unirest.put(authenticationEmailParam).headers(headers).body(sb.toString()).asString();
	        
	        log.warn("respuesta {}", jsonResponse.getBody());
		    
			if (jsonResponse.getStatus() == 200) {
				return null;
			}
			
			return jsonResponse.getBody();
	      
	   
	   }catch (Exception e) {
		   return e.getMessage();
	   }
        
    }
   
   public String createAuthenticationEmailMethods(String id, String email) {
	   try {
	    	if(oAuthProperties==null) loadConfig();
			
			StringBuilder sb = new StringBuilder();
			
			String tmpToken = initializeGraphAuth();
		
	    	Map<String, String> headers = getHeaderGraph(tmpToken); 
	    	headers.put("Content-type:", APPLICATION_JSON);
	    	
	    	String authenticationEmailParam = graphUpdateAuthenticationEmail.replace("{id}", id); 
	
	    	
	    	
	        sb.append("{")
	          .append("\"emailAddress\": \"").append(email).append("\"")
	    	  .append("}");
	        
	        HttpResponse<String> jsonResponse = Unirest.post(authenticationEmailParam).headers(headers).body(sb.toString()).asString();
	        
	        log.warn("respuesta {}", jsonResponse.getBody());
		    
			if (jsonResponse.getStatus() == 200) {
				return null;
			}
				
			return jsonResponse.getBody();
	      
	   
	   }catch (Exception e) {
		   return e.getMessage();
	   }
        
    }
   
   public String checkAuthenticationEmailMethods(String id) {
	   try {
	    	
			String tmpToken = initializeGraphAuth();
		
	    	Map<String, String> headers = getHeaderGraph(tmpToken); 
	
	    	String authenticationEmailParam = graphUpdateAuthenticationEmail.replace("{id}", id); 
		        
	        HttpResponse<JsonNode> jsonResponse = Unirest.get(authenticationEmailParam).headers(headers).asJson();
	        
	        log.warn("respuesta {}", jsonResponse.getBody());
		    
			if (jsonResponse.getStatus() == 200) {
				return jsonResponse.getBody().getObject().getJSONArray( VALUE ).getJSONObject(0).getString("id");
			}
				return jsonResponse.getBody().toString();
	      
	   
	   }catch (Exception e) {
		   e.printStackTrace();		  
		   return e.getMessage();
	   }
        
    }

   public String saveOrUpdateAuthenticationEmailMethods(String id, String phone){
   	
   	if (checkAuthenticationEmailMethods(id).equalsIgnoreCase("true")) {
   		return updateAuthenticationEmailMethods(id, phone);
   	}
   	
   	return createAuthenticationEmailMethods(id,phone);
   }
   
   //TODO: Se puede optimiazar utilizandor MEMOIZATION 
   private Map<String, String> getHeaderGraph(String tmpToken) {
	   
   	   Map<String, String> headers = new HashMap<>();
   	   
   	   log.warn("token {} "+tmpToken);
   	   
       headers.put(ACCEPT, "*/*");
       headers.put(AUTHORIZATION, "Bearer "+tmpToken);
       headers.put(ACCEPT_ENCODING, "gzip, deflate, br");
       headers.put(CONNECTION,KEEP_ALIVE);
   	   headers.put(USER_AGENT, "CPS-Azure");
   	   headers.put(CONTENT_TYPE, APPLICATION_JSON);
   	   return headers;
	}

}
