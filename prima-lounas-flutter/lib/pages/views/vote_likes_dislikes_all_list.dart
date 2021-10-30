import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu.dart';
import 'package:priima_lounas_flutter/widgets/cards/restaurant_course_card.dart';

class VoteLikesDislikesAllList extends StatelessWidget {
  const VoteLikesDislikesAllList({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          Course course = courses[index];
          return RestaurantCourseCard(course: course, showVoteButtons: true);
        },
      ),
    );
  }
}
