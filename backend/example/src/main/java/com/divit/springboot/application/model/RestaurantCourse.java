package com.divit.springboot.application.model;

import java.util.List;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RestaurantCourse {
    private String name;
    private String price;
    private List<String> flags;

    public RestaurantCourse(String name, String price, List<String> flags) {
        this.name = name;
        this.price = price;
        this.flags = flags;
    }
}
