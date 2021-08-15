package com.divit.springboot.application.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RestaurantCourse {
    private String name;
    private String price;
    private String type;
    private List<String> flags;

    public RestaurantCourse(String name, String price, String type, List<String> flags) {
        this.name = name;
        this.price = price;
        this.type = type;
        this.flags = flags;
    }
}
