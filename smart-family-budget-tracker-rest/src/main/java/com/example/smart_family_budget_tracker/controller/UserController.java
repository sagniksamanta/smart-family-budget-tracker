package com.example.smart_family_budget_tracker.controller;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity; 
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
// Import necessary packages

@RestController
@RequestMapping("/api/users")   // Base URL for user-related endpoints
public class UserController {

    @GetMapping("/ping")  // Endpoint to check if the server is running
    @Operation(summary = "Ping the server", description = "Check if the server is up and running")
    public ResponseEntity<String> ping() {
        // Logic to retrieve user by ID
        return new ResponseEntity("Server is up and running", HttpStatus.OK);
    }
}