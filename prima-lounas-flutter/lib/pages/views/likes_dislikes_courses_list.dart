import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/widgets/course_data_row.dart';

class LikesDislikesCoursesList extends StatelessWidget {
  const LikesDislikesCoursesList({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    "Yleisimmät ruokalajit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    Course course = courses[index];
                    CourseVote vote = course.courseVote;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Card(
                          child: Column(
                        children: [
                          CourseDataRow(courseName: course.name, index: index, count: 0),
                          LinearProgressIndicator(
                            backgroundColor: Colors.red,
                            color: Colors.green,
                            value: vote.calculateLikeDislikeRatio(),
                          ),
                        ],
                      )),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
