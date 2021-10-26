import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/pages/views/likes_dislikes_courses_list.dart';

import '../course_data_row.dart';

class LikesDislikesCoursesSummaryCard extends StatelessWidget {
  const LikesDislikesCoursesSummaryCard({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              "Tykätyimmät",
              style: TextStyle(fontSize: 18),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      CourseDataRow(courseName: courses[index].name, index: index, count: 0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                            ),
                            Text(courses[index].courseVote.likes.toString()),
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                backgroundColor: Colors.red,
                                color: Colors.green,
                                value: courses[index].courseVote.calculateLikeDislikeRatio(),
                              ),
                            ),
                            Text(courses[index].courseVote.dislikes.toString()),
                            Icon(
                              Icons.thumb_down,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikesDislikesCoursesList(
                          courses: this.courses,
                        ),
                      ),
                    );
                  },
                  child: Text("Näytä kaikki"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikesDislikesCoursesList(
                          courses: this.courses,
                        ),
                      ),
                    );
                  },
                  child: Text("Äänestä"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
