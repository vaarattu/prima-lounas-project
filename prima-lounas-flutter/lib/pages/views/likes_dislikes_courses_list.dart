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
                    "Tykätyimmät",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: courses.where((element) => element.courseVote.calculateLikeDislikeRatio() != -1).length,
                  itemBuilder: (context, index) {
                    Course course = courses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              CourseDataRow(
                                course: course,
                                index: index,
                                count: 0,
                                showLikesDislikes: true,
                              ),
                            ],
                          ),
                        ),
                      ),
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
