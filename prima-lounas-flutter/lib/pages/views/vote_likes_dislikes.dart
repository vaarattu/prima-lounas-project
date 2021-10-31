import 'dart:math';

import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu.dart';
import 'package:priima_lounas_flutter/model/user_saved_vote.dart';
import 'package:priima_lounas_flutter/pages/views/vote_likes_dislikes_all_list.dart';
import 'package:priima_lounas_flutter/services/local_data_service.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';
import 'package:priima_lounas_flutter/utils/helpers.dart';
import 'package:priima_lounas_flutter/widgets/cards/restaurant_course_card.dart';

class VoteLikesDislikes extends StatefulWidget {
  const VoteLikesDislikes({Key? key, required this.courses}) : super(key: key);

  final List<Course> courses;

  @override
  _VoteLikesDislikesState createState() => _VoteLikesDislikesState(courses);
}

class _VoteLikesDislikesState extends State<VoteLikesDislikes> {
  bool loading = true;
  bool processingVote = false;
  final List<Course> courses;
  List<Course> coursesToVote = [];

  UserSavedVotesService service = new UserSavedVotesService();
  late List<UserSavedVote> savedVotes;

  Course currentCourse = new Course(
      id: 0,
      name: "name",
      type: "type",
      tags: [],
      courseVote: new CourseVote(id: 0, likes: 0, dislikes: 0, votes: 0, ranked: 0));

  _VoteLikesDislikesState(this.courses) {
    courses.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  void initState() {
    super.initState();
    loadUserSavedVotes();
  }

  Future loadUserSavedVotes() async {
    var loaded = await service.readAllFromFile();
    if (loaded is List<UserSavedVote>) {
      savedVotes = loaded;
      getCoursesWithoutVotes();
    } else {
      // ERROR
    }
    setState(() {
      loading = false;
    });
  }

  void getCoursesWithoutVotes() {
    List<Course> list = [];
    for (var course in courses) {
      var saved = Helpers.findById(savedVotes, course.id);
      if (saved is UserSavedVote) {
        if (!saved.disliked && !saved.liked) {
          list.add(course);
        }
      } else {
        list.add(course);
      }
    }
    setState(() {
      coursesToVote = list;
      if (coursesToVote.isNotEmpty) {
        currentCourse = getRandomCourse();
      }
    });
  }

  Future<List<Course>> getCoursesWithVotes() async {
    await loadUserSavedVotes();
    List<Course> list = [];
    for (var course in courses) {
      for (var saved in savedVotes) {
        if (course.id == saved.id && (saved.disliked || saved.liked)) {
          list.add(course);
        }
      }
    }
    return list;
  }

  void navigateChangeVotes() async {
    List<Course> votedCourses = await getCoursesWithVotes();
    if (votedCourses.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoteLikesDislikesAllList(
            courses: votedCourses,
          ),
        ),
      ).then((value) => loadUserSavedVotes());
    }
  }

  Course getRandomCourse() {
    Random random = new Random();
    return coursesToVote[random.nextInt(coursesToVote.length)];
  }

  void skip() {
    setState(() {
      currentCourse = getRandomCourse();
    });
  }

  void vote(bool liked) async {
    if (processingVote) {
      SnackBar snackBar = new SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          "⚠ Odota hetki ääntä prosessoidaan ⚠",
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.yellow,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar)
          .closed
          .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
      return;
    }
    processingVote = true;
    int likes = 0;
    int dislikes = 0;
    if (liked) {
      likes++;
    } else {
      dislikes++;
    }

    CourseVote courseVote = new CourseVote(id: currentCourse.id, likes: likes, dislikes: dislikes, votes: 0, ranked: 0);
    var localResult = await service.addToFile(
      new UserSavedVote(id: currentCourse.id, liked: liked, disliked: !liked),
    );

    bool failed = false;

    // succesfully saved to device
    if (localResult) {
      var backendResult = await postVote(courseVote);
      // succesfully saved to backend
      if (backendResult is List<CourseVote>) {
        failed = false;
      }
      // backend save failed so revert device save
      else {
        await service.addToFile(
          new UserSavedVote(id: currentCourse.id, liked: false, disliked: false),
        );
        failed = true;
      }
    } else {
      failed = true;
    }
    if (!failed) {
      setState(() {
        coursesToVote.remove(currentCourse);
        if (coursesToVote.isNotEmpty) {
          currentCourse = getRandomCourse();
        }
      });
    } else {
      SnackBar snackBar = new SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          "🆘 Äänestäminen epäonnistui 🆘",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    processingVote = false;
  }

  dynamic postVote(CourseVote vote) async {
    List<CourseVote> votes = [];
    votes.add(vote);
    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.postToApi(RestApiType.vote, votes);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          if (loading) {
            return CircularProgressIndicator();
          }
          if (coursesToVote.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Olet äänestänyt kaikkiin ruokalajeihin. Kiitos äänistä!",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => navigateChangeVotes(),
                    child: Text("Muuta ääniä"),
                  ),
                ],
              ),
            );
          }
          return Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Mitä mieltä olet tästä ruokalajista?",
                  style: TextStyle(fontSize: 24),
                ),
                RestaurantCourseCard(
                  course: currentCourse,
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
                        onTap: () => vote(true),
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
                          border: Border.all(width: 4, color: Colors.yellow), borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () => skip(),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.skip_next,
                            size: 48,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.red), borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () => vote(false),
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
                Text(
                  "Sinulla on vielä ${coursesToVote.length.toString()} ruokalajia äänestämättä.",
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => navigateChangeVotes(),
                  child: Text("Muuta ääniä"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
