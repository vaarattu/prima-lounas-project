// To parse this JSON data, do
//
//     final restaurantWeekMenuItem = restaurantWeekMenuItemFromJson(jsonString);

import 'dart:convert';

RestaurantWeekMenuItem restaurantWeekMenuItemFromJson(String str) => RestaurantWeekMenuItem.fromJson(json.decode(str));

String restaurantWeekMenuItemToJson(RestaurantWeekMenuItem data) => json.encode(data.toJson());

class RestaurantWeekMenuItem {
  RestaurantWeekMenuItem({
    required this.id,
    required this.saveDate,
    required this.weekName,
    required this.days,
  });

  final int id;
  final DateTime saveDate;
  final String weekName;
  final List<Day> days;

  factory RestaurantWeekMenuItem.fromJson(Map<String, dynamic> json) => RestaurantWeekMenuItem(
        id: json["id"],
        saveDate: DateTime.parse(json["saveDate"]),
        weekName: json["weekName"],
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "saveDate": saveDate.toIso8601String(),
        "weekName": weekName,
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
      };
}

class Day {
  Day({
    required this.id,
    required this.day,
    required this.courses,
  });

  final int id;
  final String day;
  final List<Course> courses;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        day: json["day"],
        courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class Course {
  Course({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.tags,
  });

  final int id;
  final String name;
  final String price;
  final String type;
  final List<String> tags;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        type: json["type"],
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "type": type,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}