// To parse this JSON data, do
//
//     final restaurantMenuRequest = restaurantMenuRequestFromJson(jsonString);

import 'dart:convert';

RestaurantMenuRequest restaurantMenuRequestFromJson(String str) => RestaurantMenuRequest.fromJson(json.decode(str));

String restaurantMenuRequestToJson(RestaurantMenuRequest data) => json.encode(data.toJson());

class RestaurantMenuRequest {
  RestaurantMenuRequest({
    required this.responseCode,
    required this.errorText,
    required this.items,
  });

  int responseCode;
  String errorText;
  List<RestaurantDayItem> items;

  factory RestaurantMenuRequest.fromJson(Map<String, dynamic> json) => RestaurantMenuRequest(
        responseCode: json["responseCode"],
        errorText: json["errorText"],
        items: List<RestaurantDayItem>.from(json["items"].map((x) => RestaurantDayItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "errorText": errorText,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class RestaurantDayItem {
  RestaurantDayItem({
    required this.day,
    required this.courses,
  });

  String day;
  List<RestaurantCourseItem> courses;

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

  String name;
  String price;
  String type;
  List<String> flags;

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
