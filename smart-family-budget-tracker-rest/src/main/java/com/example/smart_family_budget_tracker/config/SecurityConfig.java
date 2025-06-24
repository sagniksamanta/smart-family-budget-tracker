package com.example.smart_family_budget_tracker.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.ExternalDocumentation;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())  // Disable CSRF for API endpoints
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/swagger-ui.html", "/v3/api-docs/**", "/swagger-ui/**").permitAll()
                .requestMatchers("/api/users/*").permitAll()  // Allow ping endpoint
                .anyRequest().authenticated()
            );
        return http.build();
    }

    @Bean
    public OpenAPI familyExpenseOpenAPI() {
        return new OpenAPI()
            .info(new Info().title("Family Expense Tracker API")
            .description("Smart Family Budget & Expense Tracker with Forecasting and Multi-Currency Support")
            .version("v1.0")
            .contact(new Contact()
                .name("Arpita Mishra, Sagnik Samanta")
                .email("arpita.mishra.2712@gmail.com, sagnik2000samanta@gmail.com"))
            .license(new License().name("Apache 2.0").url("https://springdoc.org")))
            .externalDocs(new ExternalDocumentation()
            .description("Project Repo")
            .url("https://github.com/sagniksamanta/smart-family-budget-tracker"));
    }

}
