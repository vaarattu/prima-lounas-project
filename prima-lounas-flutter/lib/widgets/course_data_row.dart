import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/widgets/course_icon.dart';
import 'package:priima_lounas_flutter/widgets/trophy_icon.dart';

class CourseDataRow extends StatelessWidget {
  const CourseDataRow({Key? key, required this.courseName, required this.index, required this.count}) : super(key: key);

  final String courseName;
  final int index;
  final int count;

  Widget getCourseIcon() {
    if (index < 3) {
      return TrophyIcon(index: index);
    } else {
      return CourseIcon(courseName: courseName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                getCourseIcon(),
                Flexible(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          courseName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
