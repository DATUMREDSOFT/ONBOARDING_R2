package com.datum.confia.cps;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource({"file:${jboss.server.config.dir}/cps-onpremises.properties"})
public class Application extends SpringBootServletInitializer{

    /**
     * Main method to start the application.
     */
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder){
      return builder.sources(Application.class);
    }

}