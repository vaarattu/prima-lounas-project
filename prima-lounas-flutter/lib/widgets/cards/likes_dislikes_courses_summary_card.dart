import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/pages/views/likes_dislikes_courses_list.dart';
import 'package:priima_lounas_flutter/pages/views/vote_likes_dislikes.dart';

import '../course_data_row.dart';

class LikesDislikesCoursesSummaryCard extends StatelessWidget {
  const LikesDislikesCoursesSummaryCard({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Tykätyimmät",
          style: TextStyle(fontSize: 20),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          CourseDataRow(course: courses[index], index: index, count: 0, showLikesDislikes: true),
                          Divider(
                            height: 2,
                            indent: 16,
                            endIndent: 16,
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
                            builder: (context) => VoteLikesDislikes(
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
        ),
      ],
    );
  }
}
