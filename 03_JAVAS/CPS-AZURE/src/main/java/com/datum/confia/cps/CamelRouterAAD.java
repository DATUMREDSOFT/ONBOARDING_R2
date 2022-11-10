package com.datum.confia.cps;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.rest.RestBindingMode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.datum.confia.cps.model.JSONCSActualizaDato;
import com.datum.confia.cps.model.JSONDato1;
import com.datum.confia.cps.model.entity.EEstado;
import com.datum.confia.cps.services.AADService;
import com.fasterxml.jackson.core.JsonParseException;
import com.google.gson.Gson;

import java.net.InetAddress;
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
public class CamelRouterAAD extends RouteBuilder {

	@Value("${CPS.AMBIENTE}")
	private String sufix;
	@Value("${cps.log.service}")
	private String cpsLogService;
	@Value("${cps.reproceso.period}")
	private String period;
	@Value("${cps.reproceso.permitidos}")
	private String reprocesoPermitidos;

	private static final String HEADER_MESSAJE_LOG = "messajeLog";
	private static final String CALL_LOG_SERVICE = "seda:LogCassandra";
	private static final String APPLICATION_JSON = "application/json";
	private static final String DIRECT_UPDATE_LOG = "direct:UpdateLog";
	private static final String EXCEPTION_STACKTRACE = "${exception.stacktrace}";
	private static final String DISABLE_REPLY_TO = "?disableReplyTo=true";
	private static final String CPS_UPDATE_DB_USER= "direct:CPSUpdateDBUser";
	private static final String EXCEPTION_MESSAGE ="${exception.message}";
	
	/*
	
	 @PostConstruct
	  private void addStuff() {
	     
	 }
	*/
	@Override
	public void configure() throws Exception {

		// @formatter:off
        restConfiguration()
                .apiContextPath("/api-doc")
                .apiProperty("api.title", "CPS AZURE REST API")
                .apiProperty("api.version", "1.0")
                .apiProperty("cors", "true")
                .apiProperty("host", "")
                .apiContextRouteId("doc-api")
            .component("servlet")
            .bindingMode(RestBindingMode.json);

	     
      //TODO: validar que json venga bonito
        onException(JsonParseException.class)
        .handled(true)
        .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(400))
        .setHeader(Exchange.CONTENT_TYPE, constant("text/plain"))
        .setBody().constant("Invalid json data");
        
        
        rest("/ADUserConsultUniRest").get("/{tipDoc}/{numDoc}/{fechaNac}")
									 .produces(APPLICATION_JSON)
									 .route()
									 .bean(AADService.class, "isValidUser(${header.tipDoc},${header.numDoc},${header.fechaNac})")
									 .endRest(); 
        
               
        from("activemq:queue:cps_cloud::Pendientes"+sufix).routeId("PENDIENTES_AZURE")
        		.doTry()
	    			.log(LoggingLevel.WARN,"PASO 1.1: Se lee registro pendientes de AMQ azure")
	        		.setHeader(HEADER_MESSAJE_LOG, constant("PASO 1: Se lee regsitro de la cola de pendientes de amq azure"))
	        		
						.to("direct:updateAAD")
					
					.process(new Processor() {						
						@Override
						public void process(Exchange exchange) throws Exception {
							
							String body = exchange.getIn().getBody(String.class);
							JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
							
							if( csa.getReproceso() > Integer.parseInt(reprocesoPermitidos) ) {							
								csa.setValid( String.valueOf( EEstado.ANULADO.ordinal() ) );
							}
							
							exchange.getIn().setHeader("estado", csa.getValid());
							exchange.getIn().setHeader("idActualizacion", csa.getIdActualizacion());
							exchange.getIn().setHeader("AADRespuesta", csa.getMensaje());
						}
					})
					.log(LoggingLevel.WARN,"PASO 1.2: estado[${header.estado}] - idActualizacion[${header.idActualizacion}]")
					.log(LoggingLevel.WARN,"PASO 1.3: Repueta ad = [${header.AADRespuesta}]")
					.choice()
				        .when( simple("${header.estado} == '4'") )
				        	.to(CPS_UPDATE_DB_USER)
				        	.log(LoggingLevel.WARN,"PASO 1.4.1: Regsitro fallo en la actualizar regsitro")
				        	.setHeader(HEADER_MESSAJE_LOG, constant("PASO 5: Regsitro fallo en la actualizar regsitro"))
				        	.to(DIRECT_UPDATE_LOG)
				        .otherwise()
				        	.to(CPS_UPDATE_DB_USER)
				        	.log(LoggingLevel.WARN,"PASO 1.4.2: Se actulizo el registo")
				        	.setHeader( HEADER_MESSAJE_LOG, constant("PASO 5: Se actulizo el registo"))
				        	.to(DIRECT_UPDATE_LOG)
				    .endChoice()
				   
				.endDoTry()
				
			    .doCatch(Exception.class)
					.log(LoggingLevel.ERROR, "PENDIENTES_AZURE  " +  EXCEPTION_STACKTRACE )
					.setHeader("Categoria", constant("ERROR"))
					.setHeader( HEADER_MESSAJE_LOG,constant( "PENDIENTES_AZURE  " + EXCEPTION_MESSAGE ))
		        	.to(DIRECT_UPDATE_LOG)
				;
        
        
		from(DIRECT_UPDATE_LOG).routeId(DIRECT_UPDATE_LOG)
			.wireTap(CALL_LOG_SERVICE);
		
		from("direct:PendienteAAD").routeId("direct:PendienteAAD")
			.doTry()
			    .log("ingresando a cola")
			    .setHeader(HEADER_MESSAJE_LOG, constant("Reproceso PASO 1: Se ingresa el registro a la cola de reproceso"))
				.wireTap(CALL_LOG_SERVICE)
				.wireTap("activemq:queue:cps_cloud::ReprocesoCPS"+sufix+DISABLE_REPLY_TO)
				.log("saliendo de la cola")
			.endDoTry()
	    	.doCatch(Exception.class)
				.log(LoggingLevel.ERROR, "PendienteAAD "+ EXCEPTION_STACKTRACE)
				.setHeader("Categoria", constant("ERROR"))
				.setHeader( HEADER_MESSAJE_LOG,constant( "direct:PendienteAAD  " + EXCEPTION_MESSAGE ))
	        	.to(DIRECT_UPDATE_LOG)
	       ;
        
        from(CPS_UPDATE_DB_USER).routeId(CPS_UPDATE_DB_USER)
        	.doTry()
				.log("PASO 4: Inicio actualiza estado tabla intermedia")
				.setHeader(HEADER_MESSAJE_LOG, constant("PASO 4: Inicio actualiza estado tabla intermedia"))
				.wireTap(CALL_LOG_SERVICE)
				.to("sql:update CPSAD.cs_actualiza_datos set estado = :#estado , fecha_modificado = sysdate, MODIFICADO_POR = 'FLUJO-AZURE' where ID_ACTUALIZACION = :#idActualizacion")
				.setHeader(HEADER_MESSAJE_LOG, constant("PASO 4: Fin actualiza estado tabla intermedia"))
				.wireTap(CALL_LOG_SERVICE)
				.log("PASO 4: Fin actualiza estado tabla intermedia")
			.endDoTry()
	    	.doCatch(Exception.class)
				.log(LoggingLevel.ERROR, CPS_UPDATE_DB_USER +" " + EXCEPTION_STACKTRACE)
				.setHeader("Categoria", constant("ERROR"))
				.setHeader( HEADER_MESSAJE_LOG,constant(CPS_UPDATE_DB_USER+ "  " + EXCEPTION_MESSAGE ))
	        	.to(DIRECT_UPDATE_LOG);
        
		from("direct:ADUserConsultUniRest").routeId("direct:ADUserConsultUniRest")
			.doTry()
				.to("bean://deleteUser(${header.user-id})")
			.endDoTry()
	    	.doCatch(Exception.class)
	    	.log(LoggingLevel.ERROR, "direct:ADUserConsultUniRest"+ EXCEPTION_STACKTRACE )
	    	.setHeader("Categoria", constant("ERROR"))
	    	.setHeader( HEADER_MESSAJE_LOG,constant("direct:ADUserConsultUniRest  " + EXCEPTION_MESSAGE ))
        	.to(DIRECT_UPDATE_LOG);
			;

		from("direct:updateAAD").routeId("updateAAD")
			.doTry()
				.log("PASO 2: Se incia validaciones del regsitro para actualizacion en AAD")
				.setHeader( HEADER_MESSAJE_LOG, constant("PASO 2: Se incia validaciones del regsitro para actualizacion en AAD") )
				.wireTap( CALL_LOG_SERVICE )
		    	.to("bean://AADService?method=update")
		    	.setHeader( HEADER_MESSAJE_LOG, constant("PASO 2: FIN Se completa actulizacion en AAD") )
		    	.wireTap(CALL_LOG_SERVICE)
	    	.endDoTry()
	    	.doCatch(Exception.class)
				.log(LoggingLevel.ERROR, "updateAAD" + EXCEPTION_STACKTRACE)
				.setHeader("Categoria", constant("ERROR"))
				.setHeader(HEADER_MESSAJE_LOG, constant("PASO 2: Error Actualizar el registro "  + EXCEPTION_MESSAGE ))
		    	.wireTap(CALL_LOG_SERVICE)
	    	;
		
		from(CALL_LOG_SERVICE).routeId("CALL_LOG_SERVICE")
		//.log("Se inicia el llamado a log cassandra")
        .setHeader("CamelHttpMethod", constant("POST"))
     	.setHeader("logCPS",simple(cpsLogService))
     	.setHeader("Content-Type", constant(APPLICATION_JSON))
        .setHeader("Accept", constant(APPLICATION_JSON))
        .removeHeader(Exchange.HTTP_PATH)
    	.doTry()
        	.process( new Processor() {
				
				@Override
				public void process(Exchange exchange) throws Exception {
					
					String categoria = exchange.getIn().getHeader("Categoria", String.class);
					String mensajeLog = exchange.getIn().getHeader(HEADER_MESSAJE_LOG, String.class);
					String mensajeAAD = exchange.getIn().getHeader("AADRespuesta", String.class);
					Map<String,String> identificacion = new HashMap<>();
					
					String body = exchange.getIn().getBody(String.class);
					JSONCSActualizaDato csa = new Gson().fromJson(body, JSONCSActualizaDato.class);
					
					
					InetAddress ip = InetAddress.getLocalHost();
			        String hostname = ip.getHostName();
			        
			        identificacion.put("documentoId","\""+csa.getNumId()+"\"");
			        identificacion.put("tipoDocumentoId","\""+csa.getTipoDocumentoAd()+"\"");
			        identificacion.put("usuario","Processo CPS AZURE");
			        identificacion.put("SourceIP","\""+ip.toString()+"\"");
			        identificacion.put("targeIp","\""+hostname+"\"");
			        
			        csa.setReproceso( csa.getReproceso() + 1 );
			        
					JSONDato1 log = new JSONDato1();

					if( mensajeAAD != null ) {			           
			            categoria = "WARN";
					}
					
					log.setCategoria( categoria == null ? "INFO" : categoria );
					log.setOrigen("CPS AZURE");
					log.setIdentificacion(identificacion);
					log.setValores(csa.parseMap());
					log.setMensaje(mensajeLog.concat(( mensajeAAD == null ? "": "\n[".concat( mensajeAAD ).concat("]"))) );
					
					exchange.getIn().setBody( new Gson().toJson(log) ,String.class);
				}
			})
        	
    		.toD("${header.logCPS}")
    	.endDoTry()
    	.doCatch(Exception.class)
    		.log(LoggingLevel.ERROR, "CALL_LOG_SERVICE" + EXCEPTION_STACKTRACE)
    		.to("activemq:queue:cps_cloud::ExceptionLog"+sufix+DISABLE_REPLY_TO);
    		

        // @formatter:on

	}

}