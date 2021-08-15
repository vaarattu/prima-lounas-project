package com.divit.springboot.application.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RestResponse {
    private int responseCode;
    private String errorText;
    private List<RestaurantDay> items;

    public RestResponse(int responseCode, String errorText, List<RestaurantDay> items) {
        this.responseCode = responseCode;
        this.errorText = errorText;
        this.items = items;
    }

    public RestResponse() {
    }
}



