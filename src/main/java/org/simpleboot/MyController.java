package org.simpleboot;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class MyController {

	private RestTemplate restTemplate = new RestTemplate();
	
	@Value("${serviceUrl}")
	private String serviceUrl;
	
	public void setServiceUrl(String serviceUrl) {
		this.serviceUrl = serviceUrl;
	}

	@RequestMapping("/hello")
	public String hello() {
	    String response = restTemplate.getForObject(serviceUrl, String.class);
	    return response;
	}
}
