import 'dart:math';

import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/model/user_saved_vote.dart';
import 'package:priima_lounas_flutter/services/local_data_service.dart';
import 'package:priima_lounas_flutter/widgets/cards/restaurant_course_card.dart';

class VoteLikesDislikes extends StatefulWidget {
  const VoteLikesDislikes({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  _VoteLikesDislikesState createState() => _VoteLikesDislikesState();
}

class _VoteLikesDislikesState extends State<VoteLikesDislikes> {
  UserSavedVotesService service = new UserSavedVotesService();
  late List<UserSavedVote> savedVotes;

  @override
  void initState() {
    super.initState();

    LoadUserSavedVotes();
  }

  void LoadUserSavedVotes() async {
    var loaded = await service.readAllFromFile();
    if (loaded is List<UserSavedVote>) {
      savedVotes = loaded;
    } else {
      // ERROR
    }
  }

  Course getRandomCourse(List<Course> courses) {
    Random random = new Random();
    return courses[random.nextInt(courses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Mitä mieltä olet tästä ruokalajista?",
              style: TextStyle(fontSize: 24),
            ),
            RestaurantCourseCard(
              course: getRandomCourse(widget.courses),
              showVoteButtons: false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.thumb_up_outlined,
                        size: 48,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.red), borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.thumb_down_outlined,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
