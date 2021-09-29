// To parse this JSON data, do
//
//     final frequentCourseItem = frequentCourseItemFromJson(jsonString);

import 'dart:convert';

List<FrequentCourseItem> frequentCourseItemFromJson(String str) =>
    List<FrequentCourseItem>.from(json.decode(str).map((x) => FrequentCourseItem.fromJson(x)));

String frequentCourseItemToJson(List<FrequentCourseItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FrequentCourseItem {
  FrequentCourseItem({
    required this.name,
    required this.count,
  });

  final String name;
  final int count;

  factory FrequentCourseItem.fromJson(Map<String, dynamic> json) => FrequentCourseItem(
        name: json["name"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
      };
}
