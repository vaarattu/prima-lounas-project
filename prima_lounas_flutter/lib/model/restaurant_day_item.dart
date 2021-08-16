// To parse this JSON data, do
//
//     final restaurantDayItem = restaurantDayItemFromJson(jsonString);

import 'dart:convert';

List<RestaurantDayItem> restaurantDayItemFromJson(String str) =>
    List<RestaurantDayItem>.from(json.decode(str).map((x) => RestaurantDayItem.fromJson(x)));

String restaurantDayItemToJson(List<RestaurantDayItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantDayItem {
  RestaurantDayItem({
    required this.day,
    required this.courses,
  });

  final String day;
  final List<RestaurantCourseItem> courses;

  factory RestaurantDayItem.fromJson(Map<String, dynamic> json) => RestaurantDayItem(
        day: json["day"],
        courses: List<RestaurantCourseItem>.from(json["courses"].map((x) => RestaurantCourseItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class RestaurantCourseItem {
  RestaurantCourseItem({
    required this.name,
    required this.price,
    required this.type,
    required this.flags,
  });

  final String name;
  final String price;
  final String type;
  final List<String> flags;

  factory RestaurantCourseItem.fromJson(Map<String, dynamic> json) => RestaurantCourseItem(
        name: json["name"],
        price: json["price"],
        type: json["type"],
        flags: List<String>.from(json["flags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "type": type,
        "flags": List<dynamic>.from(flags.map((x) => x)),
      };
}
