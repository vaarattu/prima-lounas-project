package com.divit.springboot.application.controller;

import com.divit.springboot.application.model.RestResponse;
import com.divit.springboot.application.util.RestaurantUtil;
import org.springframework.http.HttpStatus;
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
		log.info("Received fetchWeekMenu -request.");
		RestResponse restResponse = RestaurantUtil.getWeekMenu();
		if (restResponse.getResponseCode() == 1){
			return ResponseEntity.ok(restResponse.getItems());
		}
		else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(restResponse.getErrorText());
		}
	}

	@GetMapping(value = "/today")
	public ResponseEntity<?> fetchTodayMenu() {
		return ResponseEntity.ok(RestaurantUtil.getDayMenu());
	}
}
