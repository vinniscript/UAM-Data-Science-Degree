package br.com.learningspring.learningwithamigos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController // This annotation is used to indicate that the class is a controller, which means that it will receive requests from the client.
public class LearningwithamigosApplication {

	public static void main(String[] args) {

		SpringApplication.run(LearningwithamigosApplication.class, args);
	}

	/*
	# Simple example of a REST API
	@GetMapping // Get something from the server, in this case, a simple message.
	public String hello() {
		return "Hello World!";
	}
	 */

	// # ====================================

	/*
			# Simple example of a REST API with a list, this returns a JSON with the list. Spring boot does that automatically.
	@GetMapping
	public List<String> hello() { // Get something from the server, in this case, a simple message.
		return List.of("Hello", "World");
	}
	*/


}


