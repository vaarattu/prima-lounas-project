package com.divit.springboot.application.model;

import java.util.List;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RestaurantDay {
    private String day;
    private List<RestaurantCourse> courses;

    public RestaurantDay(String day, List<RestaurantCourse> courses) {
        this.day = day;
        this.courses = courses;
    }
}
