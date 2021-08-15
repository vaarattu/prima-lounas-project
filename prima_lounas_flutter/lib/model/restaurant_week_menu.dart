// To parse this JSON data, do
//
//     final restaurantWeekMenu = restaurantWeekMenuFromJson(jsonString);

import 'dart:convert';

RestaurantWeekMenu restaurantWeekMenuFromJson(String str) => RestaurantWeekMenu.fromJson(json.decode(str));

String restaurantWeekMenuToJson(RestaurantWeekMenu data) => json.encode(data.toJson());

class RestaurantWeekMenu {
  RestaurantWeekMenu({
    required this.responseCode,
    required this.errorText,
    required this.items,
  });

  int responseCode;
  String errorText;
  List<Item> items;

  factory RestaurantWeekMenu.fromJson(Map<String, dynamic> json) => RestaurantWeekMenu(
        responseCode: json["responseCode"],
        errorText: json["errorText"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "errorText": errorText,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.day,
    required this.courses,
  });

  String day;
  List<Course> courses;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        day: json["day"],
        courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class Course {
  Course({
    required this.name,
    required this.price,
    required this.type,
    required this.flags,
  });

  String name;
  String price;
  String type;
  List<String> flags;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
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
