import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/widgets/allergy_icon.dart';
import 'package:priima_lounas_flutter/widgets/course_icon.dart';
import 'package:priima_lounas_flutter/widgets/like_dislike_icons.dart';

class RestaurantCourseCard extends StatelessWidget {
  const RestaurantCourseCard({
    required this.course,
    required this.showVoteButtons,
  });

  final Course course;
  final bool showVoteButtons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: CourseIcon(courseName: course.name),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: course.tags.length == 0 ? 0 : 8,
                          ),
                          SizedBox(
                            height: course.tags.length == 0 ? 0 : 30,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: course.tags.length,
                              itemBuilder: (context, index) {
                                String flag = course.tags[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: AllergyIcon(allergyFlag: flag),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              showVoteButtons
                  ? LikeDislikeIcons(
                      courseId: course.id,
                    )
                  : Container(
                      height: 72,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
