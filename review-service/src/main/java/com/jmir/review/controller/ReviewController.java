package com.jmir.review.controller;

import com.jmir.review.model.Review;
import com.jmir.review.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
// @RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping
    public Review createReview(@RequestBody Review review) {
        return reviewService.createReview(review);
    }

    @GetMapping("/review/{id}")
    public Optional<Review> getReview(@PathVariable Long id) {
        return reviewService.getReview(id);
    }

    @GetMapping("/health")
    public String health() {
        return "Review Service is UP";
    }

    @GetMapping("/db-health")
    public String dbHealth() {
        try {
            jdbcTemplate.execute("SELECT 1");
            return "Database connection is OK";
        } catch (Exception e) {
            return "Database connection failed: " + e.getMessage();
        }
    }
}