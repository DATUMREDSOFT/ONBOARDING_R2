package com.datum.confia.cps.services;

import org.apache.camel.Body;

import java.net.InetSocketAddress;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.datastax.oss.driver.api.core.CqlIdentifier;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datum.confia.cps.model.JSONDato1;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("LogCassandraService")
public class LogCassandraService {
	
	@Value("${cassandra.host}")
	private String cassandraHost;
	@Value("${cassandra.port}")
    private String cassandraPort;
	@Value("${cassandra.keyspace}")
	private String cassandraKeyspace;
	@Value("${cassandra.table}")
	private String cassandraTable;
	
	public void log(@Body JSONDato1 data ) {
		
		if  (data == null) return;
		
		CqlSession cqlSession = CqlSession.builder()
				    .addContactPoint( new InetSocketAddress(cassandraHost, Integer.parseInt(cassandraPort) ) )
				    .withKeyspace( CqlIdentifier.fromCql(cassandraKeyspace) )
				    .withLocalDatacenter("datacenter1")
				    .build();

		ObjectMapper converter = new ObjectMapper();
		 String identificacionJson = null;
		 String valoresJson = null;
		 
	        try {
	        	identificacionJson = converter.writeValueAsString(data.getIdentificacion());
	        	valoresJson = converter.writeValueAsString(data.getValores());

	        } catch (JsonProcessingException e) {
	            e.printStackTrace();
	        }

		String query = "insert into "+cassandraTable+"( id,origen,categoria,fecha,mensaje,identificacion,valores) "
		  		+ "values ( "+ UUID.randomUUID().toString() +",'"
				+ data.getOrigen()+"','"+data.getCategoria()+"', toTimeStamp( now() ), '"+data.getMensaje() + "',"
				+ identificacionJson.replace("\\\"", "'").replace("\"", "'").replace("''", "'") +", "
		  		+ valoresJson.replace("\\\"", "'").replace("\"", "'").replace("''", "'")+")";
		   System.out.println(query);
		cqlSession.execute(query);
		cqlSession.close();
	   
    }
      
    /**
     * Se cargan las cofifuraciones del conexion a graph
     *//*
    private void loadConfig() {
    	
    	try {
    		
    		oAuthProperties = new Properties();
    		String dir= System.getProperties().getProperty("jboss.server.config.dir");
    		//String dir= "C:\\programas\\redhat\\jboss-eap-7.2\\standalone\\configuration";//System.getProperties().getProperty("jboss.server.config.dir");
    		File configFile = new File(dir.concat("/oAuth.properties"));    		

    		oAuthProperties.load( new FileInputStream(configFile) );
    	
    		this.CASSANDRA_HOST=oAuthProperties.getProperty("cassandra.host");
    		this.CASSANDRA_PORT=oAuthProperties.getProperty("cassandra.port");
    		this.CASSANDRA_KEYSPACE=oAuthProperties.getProperty("cassandra.keyspace");
    		this.CASSANDRA_TABLE=oAuthProperties.getProperty("cassandra.table");
    		
		} catch (Exception e) {
			e.printStackTrace();		    
		}
    	
    }
    */
}
