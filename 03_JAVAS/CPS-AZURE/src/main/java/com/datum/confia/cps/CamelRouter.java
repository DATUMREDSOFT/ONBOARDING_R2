package com.datum.confia.cps;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.rest.RestBindingMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.datum.confia.cps.config.AMQConfig;
import com.datum.confia.cps.model.JSONCSActualizaDato;
import com.datum.confia.cps.model.JSONDato1;
import com.fasterxml.jackson.core.JsonParseException;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import java.net.InetAddress;

/**
 * A simple Camel REST DSL route that implements the greetings service.
 * 
 */
@Component
public class CamelRouter extends RouteBuilder {

	Logger log = LoggerFactory.getLogger(CamelRouter.class);
	
	@Autowired
	AMQConfig amqService;
	
	@Value("${CPS.AMBIENTE}")
	private String sufix;
	@Value("${cps.log.service}")
	private String cpsLogService;
	@Value("${cps.amq.on-premises}")
	private String amqOnPremises;

	private static final String HEADER_MESSAJE_LOG = "messajeLog";
	private static final String CALL_LOG_SERVICE = "seda:CallLog";
	private static final String DISABLE_REPLY_TO = "?disableReplyTo=true";
	private static final String EXCEPTION_STACKTRACE ="${exception.stacktrace}";
	
	
	 
    @Override
    public void configure() throws Exception {

        // @formatter:off
        restConfiguration()
                .apiContextPath("/api-doc")
                .apiProperty("api.title", "CPS Azure")
                .apiProperty("api.version", "1.0")
                .apiProperty("cors", "true")
                .apiProperty("host", "")
                .producerComponent("http")
                .apiContextRouteId("doc-api")
	            .component("servlet")
	            .bindingMode(RestBindingMode.json)
	     ;
        
        getContext().addComponent("amqAzure", amqService.createComponentAzure() );
        getContext().addComponent("amqOnPremise", amqService.createComponentOnPremise() );

      //TODO: validar que json venga bonito
        
        onException(JsonParseException.class)
        .handled(true)
        .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(400))
        .setHeader(Exchange.CONTENT_TYPE, constant("text/plain"))
        .setBody().constant("Invalid json data");
        //activemq:queue:cps::Pendientes?brokerURL=tcp://172.16.2.247:61616
        //amqOnPremise:queue:cps::Pendientes?brokerURL='tcp://172.16.2.199:61616'	
        from("amqOnPremise:queue:cps::Pendientes"+sufix+"?brokerURL='tcp://172.16.2.199:61616'")
        //from("amqOnPremise:queue:cps::Pendientes"+sufix+"?brokerURL='tcp://172.16.2.199:61616'")
        //from(amqOnPremises).routeId("AMQ_ON_PREMISE-AMQ_AZURE")
        .log(LoggingLevel.WARN, "PASO 1.1: Inicio de lectura colas pendientes de on-premise ")
        .doTry()
        	.setHeader(HEADER_MESSAJE_LOG, constant("Paso 1: Leyendo registro on-premise "))
        	.wireTap(CALL_LOG_SERVICE)
			.to("amqAzure:queue:cps_cloud::Pendientes"+sufix+DISABLE_REPLY_TO)
			.log(LoggingLevel.DEBUG, "PASO 1.2: El registro se ha movido a AMQ Azure  ")
			.setHeader(HEADER_MESSAJE_LOG, constant("Paso 2: Registro movido a AMQ Azure"))
			.wireTap(CALL_LOG_SERVICE)
			.log(LoggingLevel.DEBUG, "PASO 1.3: FIN Movimiento registro")
		.endDoTry()
		.doCatch(Exception.class)
			.log(EXCEPTION_STACKTRACE)
			.to("activemq:queue:cps_cloud::Exception"+sufix+DISABLE_REPLY_TO)
		;
        

        from(CALL_LOG_SERVICE).routeId("LOG Cassandra")
        	.log(LoggingLevel.DEBUG, "PASO 1.2: Inicia LOG ")
	        .setHeader("CamelHttpMethod", constant("POST"))
	     	.setHeader("logCPS",simple(cpsLogService))
	     	.setHeader("Content-Type", constant("application/json"))
	        .setHeader("Accept", constant("application/json"))
	        .removeHeader(Exchange.HTTP_PATH)
        	.doTry()
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
				        
				        identificacion.put("documentoId","\""+csa.getNumId()+"\"");
				        identificacion.put("tipoDocumentoId","\""+csa.getTipoDocumentoAd()+"\"");
				        identificacion.put("usuario","Processo AMQ");
				        identificacion.put("SourceIP","\""+ip.toString()+"\"");
				        identificacion.put("targeIp","\""+hostname+"\"");
				        
				        csa.setReproceso( csa.getReproceso() + 1 );
				    
						JSONDato1 log = new JSONDato1();
						
						log.setCategoria(categoria == null ? "INFO" : categoria);
						log.setOrigen("CPS AMQ");
						log.setIdentificacion(identificacion);
						log.setValores(csa.parseMap());
						log.setMensaje(messajeLog.concat( (csa.getMensaje()==null ? "": csa.getMensaje().equals("null") ? "" : csa.getMensaje()) ) );
						
						exchange.getIn().setBody( new Gson().toJson(log) ,String.class);
					}
				})
	        	
	    		.toD("${header.logCPS}")
	    	.endDoTry()
        	.doCatch(Exception.class)
        		.log(EXCEPTION_STACKTRACE)
        		.to("activemq:queue:cps_cloud::ExceptionLog"+sufix+DISABLE_REPLY_TO);
        		}

}