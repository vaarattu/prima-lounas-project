package com.divit.springboot.application.controller;

import com.divit.springboot.application.util.RestaurantUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping(value = "/api/v1")
public class ApiRestController {

	@GetMapping(value = "/week")
	public ResponseEntity<?> fetchWeekMenu() {
		return ResponseEntity.ok(RestaurantUtil.getWeekMenu());
	}

	@GetMapping(value = "/today")
	public ResponseEntity<?> fetchTodayMenu() {
		return ResponseEntity.ok(RestaurantUtil.getDayMenu());
	}

}
