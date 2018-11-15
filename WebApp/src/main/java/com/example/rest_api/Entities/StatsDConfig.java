package com.example.rest_api.Entities;

import com.timgroup.statsd.NoOpStatsDClient;
import com.timgroup.statsd.NonBlockingStatsDClient;
import com.timgroup.statsd.StatsDClient;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class StatsDConfig{

    @Bean
    public StatsDClient metricsClient(
                            @Value("${metrics.server.hostname}") String hostname,
                            @Value("${metrics.server.port}") String port,
                            @Value("${publish.metrics}") String publish
    ){
        
        if(publish.equals("true")){
            return new NonBlockingStatsDClient("CSYE", hostname, Integer.parseInt(port));
        }

        return new NoOpStatsDClient();

    }

}
