package com.datum.confia.cps;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.apache.camel.model.rest.RestBindingMode;

//import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.datum.confia.cps.model.JSONCSActualizaDato;
import com.datum.confia.cps.model.JSONDato1;
import com.datum.confia.cps.model.entity.EEstado;
import com.datum.confia.cps.services.ADUserConsultUniRestService;
import com.datum.confia.cps.utils.EscapeForJSON;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.net.InetAddress;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;

/**
 * A simple Camel REST DSL route that implements the greetings service.
 * 
 */
@Component
public class CamelRouter extends RouteBuilder {

	Logger log = LoggerFactory.getLogger(CamelRouter.class);

	private static final String HEADER_MESSAJE_LOG = "messajeLog";
	private static final String CALL_LOG_SERVICE = "seda:CallLog";

	private static final String APPLICATION_JSON = "application/json";

	private static final String EXCEPTION_GENERIC = "${exception}";
	private static final String EXCEPTION_MESSAGE = "${exception.message}";
	private static final String EXCEPTION_STACKTRACE = "${exception.stacktrace}";

	@Value("${cps.log.service}")
	private String cpsLogService;
	@Value("${CPS.AMBIENTE}")
	private String sufix;
	@Value("${cps.reproceso.period}")
	private String period;
	@Value("${cps.reproceso.permitidos}")
	private String reprocesoPermitidos;
	// @Value("${cps.num-row}")
	// private String numRow;

	@Override
	public void configure() throws Exception {

		// @formatter:off
        restConfiguration()
                .apiContextPath("/api-doc")
                .apiProperty("api.title", "CPS REST API")
                .apiProperty("api.version", "1.0")
                .apiProperty("cors", "true")
                .apiProperty("host", "")
                .producerComponent("http")
                .apiContextRouteId("doc-api")
            .component("servlet")
            .bindingMode(RestBindingMode.json);
        /*JsonParseException.class,*/
        onException( Exception.class)
        .handled(true)
        .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(400))
        .setHeader(Exchange.CONTENT_TYPE, constant("text/plain"))
        /*.setBody().constant("Invalid json data");*/
        .setBody().simple(EXCEPTION_STACKTRACE);

        
        rest("/cps-log").apiDocs(true).description("Log que guarda en casandra")
    	.post("/")
    	.type(JSONDato1.class)
    	.route().routeId("post-generacion-archivos-encriptados")
    	.setHeader("Access-Control-Allow-Origin", constant("*"))                
        .setHeader("Access-Control-Allow-Credentials", constant(true))                
        .setHeader("Access-Control-Allow-Methods", constant("GET, HEAD, POST, PUT, DELETE, OPTIONS"))                
        .setHeader("Access-Control-Allow-Headers", constant("Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Authorization"))                
        .setHeader("Allow", constant("GET, HEAD, POST, PUT, DELETE, OPTIONS"))
    	.wireTap("seda:LogCassandra")
    	.endRest();
              
        rest("/ADUserConsultUniRest").get("/{tipDoc}/{numDoc}/{fechaNac}")
					 .produces(APPLICATION_JSON)
					 .route()
					 .bean(ADUserConsultUniRestService.class, "isValidUser(${header.tipDoc},${header.numDoc},${header.fechaNac})")
					 .endRest(); 

		from("timer:CPS?fixedRate=true&delay=0&period=10000")
			.routeId("Timer")
			.log(LoggingLevel.WARN, "PASO 1.1: Inicio de timer ")
			.to("direct:bucarIngresados");
		
		
		from("direct:bucarIngresados")
		.routeId("bucarIngresados")
		.doTry()
			.to("sql:SELECT ID_ACTUALIZACION"
					+ ", FECHA_ACTUALIZACION"
					+ ", TIPO_DOCUMENTO_AD"
					+ ", NUM_ID"
					+ ", TO_CHAR(FECHA_NACIMIENTO_AD,'YYYY-MM-DD') FECHA_NACIMIENTO_AD"
					+ ", NUP, NOMBRE_OLD"
					+ ", NOMBRE_NEW"
					+ ", PRIMER_NOMBRE_OLD"
					+ ", PRIMER_NOMBRE_NEW"
					+ ", SEGUNDO_NOMBRE_OLD"
					+ ", SEGUNDO_NOMBRE_NEW"
					+ ", PRIMER_APELLIDO_OLD"
					+ ", PRIMER_APELLIDO_NEW"
					+ ", SEGUNDO_APELLIDO_OLD"
					+ ", SEGUNDO_APELLIDO_NEW"
					+ ", APELLIDO_CASADA_OLD"
					+ ", APELLIDO_CASADA_NEW"
					+ ", TELEFONO1_OLD"
					+ ", TELEFONO1_NEW"
					+ ", TELEFONO2_NEW"
					+ ", TELEFONO2_OLD"
					+ ", TIPO_DOCUMENTO_OLD"
					+ ", TIPO_DOCUMENTO_NEW"
					+ ", NUMERO_DOCUMENTO_OLD"
					+ ", NUMERO_DOCUMENTO_NEW"
					+ ", FECHA_NACIMIENTO_OLD"
					+ ", FECHA_NACIMIENTO_NEW"
					+ ", CORREO1_OLD"
					+ ", CORREO1_NEW"
					+ ", CORREO2_OLD"
					+ ", CORREO2_NEW"
					+ ", IND_ESTADO_REGISTRO_OLD"
					+ ", IND_ESTADO_REGISTRO_NEW"
					+ ", ESTADO, ADICIONADO_POR"
					+ ", FECHA_INGRESADO"
					+ ", FECHA_PROCESADO"
					+ ", FECHA_MODIFICADO"
					+ ", MODIFICADO_POR"
					+ ", FUENTE"
					+ ", USUARIO_WEB_OLD"
					+ ", USUARIO_WEB_NEW"
					+ ", '' as valid"
					+ ", '' as ID_AAD"
					+ ", '' as MENSAJE"
					+ ", '0' as REPROCESO "
					+ "FROM CPSAD.CS_ACTUALIZA_DATOS where estado = 1 and ROWNUM <= 5" )
			// TODO : paramamerizar rownum
				.log(LoggingLevel.WARN, "PASO 1.2: Consulta base de datos ")
			.doCatch(SQLException.class)
				.log(LoggingLevel.ERROR, "SQLException [direct:bucarIngresados] "+ EXCEPTION_MESSAGE)
			.doCatch(Exception.class)
				.log(LoggingLevel.ERROR, "SQLException [direct:bucarIngresados] "+ EXCEPTION_MESSAGE)
			.end()
			.onCompletion()
			.choice()
			.when(simple("${body} != ''"))
				.log(LoggingLevel.WARN, "PASO 1.3: ingresa choise [direct:bucarIngresados] ")
				.split(body()).streaming()
				.marshal().json(JsonLibrary.Gson)
				
				.setHeader(HEADER_MESSAJE_LOG, constant("Paso 2: Se valida el regsitro en AAD"))
				.wireTap(CALL_LOG_SERVICE)
				.log(LoggingLevel.WARN, "PASO 2.1: Primera invocacion a log ")
				
					.to("direct:ADUserConsultUniRest")
				
				.log(LoggingLevel.WARN, "PASO 2.2: Luego invocacion de AAD ")
				.process(new Processor() {
					
					@Override
					public void process(Exchange exchange) throws Exception {
						
						String body = exchange.getIn().getBody(String.class);
						
						try {
						log.warn("PASO 2.2.1 ingreso al proceso luego de invocacion AAD");
						
						Gson gson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create();
						JSONCSActualizaDato csa = gson.fromJson( body, JSONCSActualizaDato.class );
						log.warn("PASO 2.2.2 parse JSON");
						csa.setReproceso( csa.getReproceso() ==null ? 0 : (csa.getReproceso() +1) );
						
						if( csa.getReproceso() > Integer.parseInt(reprocesoPermitidos) ) {
							csa.setValid( String.valueOf( EEstado.ANULADO.ordinal() )); 
						}
						
						exchange.getIn().setHeader("estado", csa.getValid());
						exchange.getIn().setHeader("idActualizacion", csa.getIdActualizacion());
						
						log.warn("PASO 2.2.3 fin process");
						exchange.getIn().setHeader(HEADER_MESSAJE_LOG, "Se inicializo el estado del registro con "+ csa.getValid() );
						
						}catch (Exception e ) {
								
							try {
								log.warn(body);
								log.warn( EscapeForJSON.escapeForJSON(body) );
								Gson gson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create();
								JSONCSActualizaDato csa = gson.fromJson( body.replace("\\", ""), JSONCSActualizaDato.class );
								exchange.getIn().setHeader("estado",  String.valueOf( EEstado.ANULADO.ordinal() ) );
								exchange.getIn().setHeader(HEADER_MESSAJE_LOG, "ERROR EN EL PROCESAMEINTO DE DATOS" + e.getMessage());
								exchange.getIn().setHeader("idActualizacion", csa.getIdActualizacion() );
							
							}catch (Exception ee) {
								ee.printStackTrace();
							}
						}
					}
					
				})
				.wireTap(CALL_LOG_SERVICE)
				.log(LoggingLevel.WARN, "Paso 2.3: Fin validacion AAD")
				.setHeader(HEADER_MESSAJE_LOG, constant("Paso 3: Fin validacion AAD"))
				.wireTap(CALL_LOG_SERVICE)
				
					.to("direct:CPSUpdateDBUser")
				
				.setHeader(HEADER_MESSAJE_LOG, constant("Paso 6: Se evalua regsitro si pasa a amq-onprimese"))
				.log(LoggingLevel.WARN, "Paso 2.4: Inicia envio a cola ")
				.wireTap(CALL_LOG_SERVICE)
				.choice()
			        .when( simple("${header.estado} == '2'") )
				        	.to("direct:PendienteAAD")
				        	.log(LoggingLevel.WARN, "Paso 2.5.1: Envia a cola exitosamente ")
				     .endChoice()
			        .otherwise()
			        	.setHeader(HEADER_MESSAJE_LOG, constant("Paso 10:registro no valido no se envia a cola"))
			        	.wireTap(CALL_LOG_SERVICE)
			        	.log(LoggingLevel.WARN,"Paso 2.5.2:registro no valido no se envia a cola")
			     .endChoice()
			  .endChoice()
		.end().end();
		
		from("direct:CPSUpdateDBUser").routeId("CPSUpdateDBUser")

			  .log(LoggingLevel.WARN, "Paso 3.1: inicia la actulizacion de estado en base")
			  .setHeader(HEADER_MESSAJE_LOG, constant("Paso 4: inicia la actulizacion de estado en base"))
              .wireTap(CALL_LOG_SERVICE)
              .to("sql:update CPSAD.cs_actualiza_datos set estado = :#estado , fecha_modificado = sysdate, MODIFICADO_POR = 'FLUJO_ON-PRIMESE' where ID_ACTUALIZACION = :#idActualizacion")
              .setHeader(HEADER_MESSAJE_LOG, constant("Paso 5: Fin actualiza estado"))
              .wireTap(CALL_LOG_SERVICE)
              ;
		
		from("direct:ADUserConsultUniRest").routeId("ADUserConsultUniRest")
		.doTry()
			
				.to("bean:ADUserConsultUniRestService?method=isValidUser")
				.log(LoggingLevel.WARN, "PASO B2: Lectura correcta del Servicio AAD")
			
		.endDoTry()
	    .doCatch(Exception.class)
	    	.log( LoggingLevel.ERROR, "direct:ADUserConsultUniRest " + EXCEPTION_GENERIC )
	    .end()
	    ;
		
		from("seda:LogCassandra").routeId("LogCassandra")
			.doTry()
		    	.to("bean:LogCassandraService?method=log")
		    .doCatch(Exception.class)
		    	.log( EXCEPTION_GENERIC )
		    ;
		
		from("direct:PendienteAAD").routeId("PendienteAAD")
			.doTry()

				.setHeader(HEADER_MESSAJE_LOG, constant("Paso 8: El registro se regsitra en cola a amq-onpremise"))
				.wireTap(CALL_LOG_SERVICE)
			
					.to("activemq:queue:cps::Pendientes"+sufix+"?disableReplyTo=true")
			
				.setHeader(HEADER_MESSAJE_LOG, constant("Paso 9: Se completo el regsitro en amq-onprime"))
				.wireTap(CALL_LOG_SERVICE)
				.log(LoggingLevel.WARN, "PASO C1 [direct:PendienteAAD]: Fin envio a cola ")
			
			.endDoTry()
			.doCatch(Exception.class)
				.log(LoggingLevel.ERROR, "direct:PendienteAAD " + EXCEPTION_GENERIC)					
				.wireTap("activemq:queue:cps::Exception"+sufix+"?disableReplyTo=true")
			;
		
		
		from("timer:CPSReproceso?fixedRate=true&delay=0&period="+period).routeId("CPSReproceso")
			.log("Se inica clasificacion de reproceso")
			.doTry()
			.choice()
	        	.when( simple("${body} != null ") )	
	        		.to("activemq:queue:cps::Reproceso"+sufix)
	        		.setHeader(HEADER_MESSAJE_LOG, constant("Paso 10: El Registro se envia a reproceso "))
	        		.wireTap(CALL_LOG_SERVICE)
					.process( new Processor() {
										
							@Override
							public void process(Exchange exchange) throws Exception {
								
								String body = exchange.getIn().getBody(String.class);
								JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
								
								csa.setReproceso( csa.getReproceso() ==null ? 0 : (csa.getReproceso() +1) );
								
								if( csa.getReproceso() > Integer.parseInt(reprocesoPermitidos) ) {
									
									csa.setValid( String.valueOf( EEstado.ANULADO.ordinal() ) );
								}
								
								exchange.getIn().setHeader("estado", csa.getValid() );
								exchange.getIn().setHeader("idActualizacion", csa.getIdActualizacion() );
								
								
							}
						})
					.choice()
						.when(simple("${body} != null && ${header.estado} == 2  ")).to("activemq:queue:cps::Pendientes"+sufix+"?disableReplyTo=true")
						.otherwise().setHeader(HEADER_MESSAJE_LOG, constant("Paso 10: Registro no valido")).wireTap(CALL_LOG_SERVICE).log("Paso 10:registro no valido")
					.endChoice()
	        		
	        .endChoice()
		.endDoTry()
		.doCatch(Exception.class)
			.wireTap("activemq:queue:cps::Exception"+sufix+"?disableReplyTo=true");
		
		

		from("timer:CPSInsetLog?fixedRate=true&delay=0&period="+period).routeId("CPSInsetLog")
		.doTry()/*
		.process( new Processor() {
			
			@Override
			public void process(Exchange exchange) throws Exception {
				
				String categoria = exchange.getIn().getHeader("Categoria", String.class);
				String messajeLog = exchange.getIn().getHeader(HEADER_MESSAJE_LOG, String.class);
				Map<String,String> identificacion = new HashMap<>();
				
				String body = exchange.getIn().getBody(String.class);
				JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
				InetAddress ip = InetAddress.getLocalHost();
		        String hostname = ip.getHostName();
		        JSONDato1 log = new JSONDato1();
		        
		        if (csa != null) {
			        identificacion.put("documentoId","\""+csa.getNumId()+"\"");
			        identificacion.put("tipoDocumentoId","\""+csa.getTipoDocumentoAd()+"\"");
			        csa.setReproceso( csa.getReproceso() != null ? (csa.getReproceso() + 1):0 );
			        log.setValores(csa.parseMap());
			    }else{
			    	categoria = "ERROR";
			    	messajeLog = "Error de conversion de datos ==> ".concat(messajeLog == null ? "" : messajeLog);
			    }
		        
		        identificacion.put("usuario","Flujo CPS On-Primese");
		        identificacion.put("SourceIP","\""+ip.toString()+"\"");
		        identificacion.put("targeIp","\""+hostname+"\"");
		       
		        log.setMensaje( "Enviado desde timer:CPSInsetLog log ["+( messajeLog == null ? "" : messajeLog )+"]" );
				log.setCategoria( categoria == null ? "INFO" : categoria );
				log.setOrigen("CPS On-premise");
				log.setIdentificacion(identificacion);
				
				exchange.getIn().setBody( new Gson().toJson(log) , String.class);
			}
		})*/
			.to("bean:LogCassandraService?method=log")
		.doCatch(Exception.class)
			.log(EXCEPTION_STACKTRACE)
			.log("${body}");
		
		from(CALL_LOG_SERVICE).routeId(CALL_LOG_SERVICE)
			.log(LoggingLevel.WARN, "PASO A1: inicio log")
	        .setHeader("CamelHttpMethod", constant("POST"))
	     	.setHeader("logCPS", simple(cpsLogService) )
	     	.setHeader("Content-Type", constant(APPLICATION_JSON))
	        .setHeader("Accept", constant(APPLICATION_JSON))
			.doTry()
		        .removeHeader(Exchange.HTTP_PATH)
				.process( new Processor() {
					
					@Override
					public void process(Exchange exchange) throws Exception {

						String categoria = exchange.getIn().getHeader("Categoria", String.class);
						String messajeLog = exchange.getIn().getHeader(HEADER_MESSAJE_LOG, String.class);
						Map<String,String> identificacion = new HashMap<>();
						
						String body = exchange.getIn().getBody(String.class);
						JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
						InetAddress ip = InetAddress.getLocalHost();
				        String hostname = ip.getHostName();
				        JSONDato1 log = new JSONDato1();
				        
				        if (csa != null) {
					        identificacion.put("documentoId","\""+csa.getNumId()+"\"");
					        identificacion.put("tipoDocumentoId","\""+csa.getTipoDocumentoAd()+"\"");
					        csa.setReproceso( csa.getReproceso() ==null ? 0 : (csa.getReproceso() +1) );
					        log.setValores(csa.parseMap());
					    }else{
					    	categoria = "WARN";
					    	messajeLog = "Error de conversion de datos ==> ".concat(messajeLog == null ? "" : messajeLog);
					    }
				        
				        identificacion.put("usuario","Flujo CPS On-Primese");
				        identificacion.put("SourceIP","\""+ip.toString()+"\"");
				        identificacion.put("targeIp","\""+hostname+"\"");
				       
				        log.setMensaje( "Enviado desde CALL_LOG_SERVICE log["+( messajeLog == null ? "" : messajeLog )+"]" );
						log.setCategoria( categoria == null ? "INFO" : categoria );
						log.setOrigen("CPS On-premise");
						log.setIdentificacion(identificacion);
						
						exchange.getIn().setBody( new Gson().toJson(log) , String.class);
					}
				})
			.toD("${header.logCPS}")
		.doCatch( Exception.class )
			.log(LoggingLevel.WARN, "PASO A2 Exception " + EXCEPTION_MESSAGE)

			.process( new Processor() {
				
				@Override
				public void process(Exchange exchange) throws Exception {
					
					String categoria = exchange.getIn().getHeader("Categoria", String.class);
					String messajeLog = exchange.getIn().getHeader(HEADER_MESSAJE_LOG, String.class);
					Map<String,String> identificacion = new HashMap<>();
					
					String body = exchange.getIn().getBody(String.class);
					//JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
					InetAddress ip = InetAddress.getLocalHost();
			        String hostname = ip.getHostName();
			        JSONDato1 log = new JSONDato1();
			        
			        
				        identificacion.put("documentoId","\" No se pudo extraer datos incorrectos en el regsitro \"");
				        identificacion.put("tipoDocumentoId","\"No se pudo extraer datos incorrectos en el regsitro \"");
				     
				        Map<String, String> erroMap = new HashMap<String, String>();
				        erroMap.put("body", body);
				        log.setValores( erroMap );
				  
			        
			        identificacion.put("usuario","Flujo CPS On-Primese");
			        identificacion.put("SourceIP","\""+ip.toString()+"\"");
			        identificacion.put("targeIp","\""+hostname+"\"");
			       
			        log.setMensaje( "Enviado desde CALL_LOG_SERVICE log["+( messajeLog == null ? "" : messajeLog )+"]" );
					log.setCategoria( categoria == null ? "INFO" : categoria );
					log.setOrigen("CPS On-premise");
					log.setIdentificacion(identificacion);
					
					exchange.getIn().setBody( new Gson().toJson(log) , String.class);
				}
			})

			.end();
		/*.endDoTry()
		.doCatch(Exception.class)
			.log(LoggingLevel.ERROR, EXCEPTION_MESSAGE)
			.doTry()
				.log("Se ingresa cola de log de excepiones ExceptionLog ")
				.process( new Processor() {
					
					@Override
					public void process(Exchange exchange) throws Exception {
						
						String categoria = exchange.getIn().getHeader("Categoria", String.class);
						String messajeLog = exchange.getIn().getHeader(HEADER_MESSAJE_LOG, String.class);
						Map<String,String> identificacion = new HashMap<>();
						
						String body = exchange.getIn().getBody(String.class);
						JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
						InetAddress ip = InetAddress.getLocalHost();
				        String hostname = ip.getHostName();
				        JSONDato1 log = new JSONDato1();
				        
				        if (csa != null) {
					        identificacion.put("documentoId","\""+csa.getNumId()+"\"");
					        identificacion.put("tipoDocumentoId","\""+csa.getTipoDocumentoAd()+"\"");
					        
					        csa.setReproceso( csa.getReproceso() == null ? 0 : (csa.getReproceso() +1) );
					        log.setValores( csa.parseMap() );
					    }else{
					    	categoria = "WARN";
					    	messajeLog = "Error de conversion de datos ==> ".concat( messajeLog == null ? "" : messajeLog );
					    }
				        
				        identificacion.put("usuario","Flujo CPS On-Primese");
				        identificacion.put("SourceIP","\""+ip.toString()+"\"");
				        identificacion.put("targeIp","\""+hostname+"\"");
				       
				        log.setMensaje( "Enviado desde CALL_LOG_SERVICE.Exception log["+( messajeLog == null ? "" : messajeLog )+"]" );
						log.setCategoria( categoria == null ? "INFO" : categoria );
						log.setOrigen("CPS On-premise");
						log.setIdentificacion(identificacion);
						
						exchange.getIn().setBody( new Gson().toJson(log) , String.class);
					}
				})
				.to("activemq:queue:cps::ExceptionLog"+sufix+"?disableReplyTo=true")
				.log(EXCEPTION_STACKTRACE)
			.endDoTry()
			.doCatch(Exception.class)
				.log(EXCEPTION_STACKTRACE)*/
			
		
		
        // @formatter:on

	}

}