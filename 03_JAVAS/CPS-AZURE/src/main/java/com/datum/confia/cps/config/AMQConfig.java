package com.datum.confia.cps.config;

import java.util.UUID;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.activemq.camel.component.ActiveMQComponent;
import org.apache.camel.component.jms.JmsComponent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AMQConfig {
	Logger log = LoggerFactory.getLogger( AMQConfig.class );

	@Value("${spring.activemq.user}")
	private String activemqUser;
	@Value("${spring.activemq.password}")
	private String activemqPassword;
	@Value("${cps.activemq.broker-url-azure}")
	 private String brokerURLAzure;
	@Value("${cps.activemq.broker-url-onpremise}")
	private String brokerURLOnPremise;
	
	
	    public ActiveMQConnectionFactory registerActiveMQConnectionFactoryOnPremise() {
	    	 log.warn("ActiveMQ On premise  Listener: STARTING..."+brokerURLOnPremise);
	        ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory();
	        //connectionFactory.setBrokerURL( "tcp://172.16.2.199:61616" );
	        connectionFactory.setBrokerURL( brokerURLOnPremise );
	        connectionFactory.setUserName(activemqUser);
	        connectionFactory.setPassword(activemqPassword);
	        connectionFactory.setUseAsyncSend(false);
	        connectionFactory.setClientID(UUID.randomUUID().toString());
	        connectionFactory.setConnectResponseTimeout(300);
	        log.warn( "ActiveMQ On premise Listener: STARTED");
	        return connectionFactory;
	    }
	    
	    public ActiveMQConnectionFactory registerActiveMQConnectionFactoryAzure() {
	        log.warn( "ActiveMQ Azure Listener: STARTING..."+brokerURLAzure);
	        ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory();
	       // connectionFactory.setBrokerURL( "tcp://10.10.51.17:61616" );
	        connectionFactory.setBrokerURL( brokerURLAzure ); 
	        connectionFactory.setUserName(activemqUser);
	        connectionFactory.setPassword(activemqPassword);
	        connectionFactory.setUseAsyncSend(false);
	        connectionFactory.setClientID(UUID.randomUUID().toString());
	        connectionFactory.setConnectResponseTimeout(300);
	        log.warn("ActiveMQ Azure Listener: STARTED");
	        return connectionFactory;
	    }

	    public JmsComponent createComponentAzure() {
	    	ActiveMQComponent amq = new ActiveMQComponent();
		    amq.setConnectionFactory(registerActiveMQConnectionFactoryAzure());
		    return amq;
		  }
		
		public JmsComponent createComponentOnPremise() {
			ActiveMQComponent amq = new ActiveMQComponent();
		    amq.setConnectionFactory(registerActiveMQConnectionFactoryOnPremise());     
		    return amq;
		  }
		
}
