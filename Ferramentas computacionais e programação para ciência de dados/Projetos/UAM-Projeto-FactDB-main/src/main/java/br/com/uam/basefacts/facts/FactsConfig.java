package br.com.uam.basefacts.facts;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration


public class FactsConfig {

    @Bean
    CommandLineRunner commandLineRunner(FactsRepository repository) {
        return args -> {
            Facts fact1 = new Facts(
                    "https://www.youtube.com/watch?v=9bZkp7q19f0",
                    "strangeasian@tiktok.com"
            );

            Facts fact2 = new Facts(
                    "https://grobonius.com/bolsonaro-da-um-tiro-no-lula/",
                    "insanidades@feiquenius.com"
            );
        repository.saveAll(
                List.of(
                        fact1,
                        fact2));
        };
    }
}