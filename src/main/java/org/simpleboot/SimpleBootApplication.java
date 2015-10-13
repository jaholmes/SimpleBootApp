package org.simpleboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
//@EnableConfigurationProperties
public class SimpleBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(SimpleBootApplication.class, args);
    }
}
