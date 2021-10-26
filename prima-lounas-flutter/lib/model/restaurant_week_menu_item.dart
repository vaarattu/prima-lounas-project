// To parse this JSON data, do
//
//     final restaurantWeekMenuItem = restaurantWeekMenuItemFromJson(jsonString);

import 'dart:convert';

List<RestaurantWeekMenuItem> restaurantWeekMenuItemFromJson(String str) =>
    List<RestaurantWeekMenuItem>.from(json.decode(str).map((x) => RestaurantWeekMenuItem.fromJson(x)));
String restaurantWeekMenuItemToJson(List<RestaurantWeekMenuItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Course> courseFromJson(String str) => List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));
String courseToJson(List<Course> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<CourseVote> courseVoteListFromJson(String str) =>
    List<CourseVote>.from(json.decode(str).map((x) => CourseVote.fromJson(x)));
String courseVoteListToJson(List<CourseVote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    required this.courseVote,
  });

  final int id;
  final String name;
  final String price;
  final String type;
  final List<String> tags;
  final CourseVote courseVote;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        type: json["type"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        courseVote: CourseVote.fromJson(json["courseVote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "type": type,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "courseVote": courseVote.toJson(),
      };
}

class CourseVote {
  CourseVote({
    required this.id,
    required this.likes,
    required this.dislikes,
    required this.votes,
    required this.ranked,
  });

  final int id;
  final int likes;
  final int dislikes;
  final int votes;
  final int ranked;

  double calculateLikeDislikeRatio() {
    if (likes == 0 && dislikes == 0) {
      return -1;
    }
    if (likes == 0 && dislikes > 0) {
      return 0;
    }
    if (likes > 0 && dislikes == 0) {
      return 1;
    }

    return likes / (likes + dislikes);
    //return (likes - dislikes) / (likes + dislikes);
  }

  factory CourseVote.fromJson(Map<String, dynamic> json) => CourseVote(
        id: json["id"],
        likes: json["likes"],
        dislikes: json["dislikes"],
        votes: json["votes"],
        ranked: json["ranked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "likes": likes,
        "dislikes": dislikes,
        "votes": votes,
        "ranked": ranked,
      };
}
