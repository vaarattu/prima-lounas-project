import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/widgets/icons/course_icon.dart';
import 'package:priima_lounas_flutter/widgets/icons/trophy_icon.dart';

class CourseDataRow extends StatelessWidget {
  const CourseDataRow(
      {Key? key, required this.course, required this.index, required this.count, required this.showLikesDislikes})
      : super(key: key);

  final dynamic course;
  final int index;
  final int count;
  final bool showLikesDislikes;

  Widget getCourseIcon() {
    if (index < 3) {
      return TrophyIcon(index: index);
    } else {
      return CourseIcon(courseName: course.name);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          course.name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      !showLikesDislikes
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      course.courseVote.likes.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      minHeight: 6,
                                      backgroundColor: Colors.red,
                                      color: Colors.green,
                                      value: course.courseVote.calculateLikeDislikeRatio(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      course.courseVote.dislikes.toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          count == 0
              ? Container()
              : Text(
                  count.toString(),
                  style: TextStyle(fontSize: 18),
                ),
        ],
      ),
    );
  }
}
