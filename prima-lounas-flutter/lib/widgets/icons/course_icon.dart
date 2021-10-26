import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/utils/icons.dart';

class CourseIcon extends StatelessWidget {
  const CourseIcon({Key? key, required this.courseName}) : super(key: key);

  final String courseName;

  Icon getCourseIcon() {
    // default
    IconData data = PrimaLounasIcons.dish;
    Color color = Colors.teal;
    if (courseName.contains("pöytä")) {
      data = PrimaLounasIcons.salad;
      color = Colors.green;
    }
    if (courseName.contains("keitto")) {
      data = PrimaLounasIcons.soup;
      color = Colors.pink;
    }

    return Icon(
      data,
      size: 36,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getCourseIcon();
  }
}
