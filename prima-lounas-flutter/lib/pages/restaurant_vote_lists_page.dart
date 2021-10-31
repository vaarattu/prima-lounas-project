import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';
import 'package:priima_lounas_flutter/widgets/cards/likes_dislikes_courses_summary_card.dart';
import 'package:priima_lounas_flutter/widgets/error_display.dart';
import 'package:priima_lounas_flutter/widgets/cards/frequent_courses_summary_card.dart';

class RestaurantVoteListsPage extends StatefulWidget {
  RestaurantVoteListsPage({Key? key, required this.callback}) : super(key: key);
  final VoidCallback callback;
  @override
  _RestaurantVoteListsPageState createState() => _RestaurantVoteListsPageState();
}

class _RestaurantVoteListsPageState extends State<RestaurantVoteListsPage> {
  final RestaurantMenuService service = RestaurantMenuService();
  late List<FrequentCourseItem> frequentCourses;
  late List<Course> allCourses;

  bool loading = true;
  bool error = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    widget.callback();
    setState(() {
      loading = true;
      error = false;
      errorText = "";
    });

    await getAllCourses();
    await getFrequentCourses();

    setState(() {
      loading = false;
      error = errorText != "";
    });
  }

  int sortByLikes(Course a, Course b) {
    final ratioA = a.courseVote.calculateLikeDislikeRatio();
    final ratioB = b.courseVote.calculateLikeDislikeRatio();

    final likesA = a.courseVote.likes;
    final likesB = b.courseVote.likes;

    final votesA = a.courseVote.likes + a.courseVote.dislikes;
    final votesB = b.courseVote.likes + b.courseVote.dislikes;

// if ratio is same compare by likes count
    if (ratioA == ratioB) {
      // if likes count is same compare by votes count
      if (likesA == likesB) {
        if (votesA < votesB) {
          return -1;
        } else if (votesA > votesB) {
          return 1;
        }
      }

      if (likesA < likesB) {
        return -1;
      } else if (likesA > likesB) {
        return 1;
      }
    }

    if (ratioA < ratioB) {
      return -1;
    } else if (ratioA > ratioB) {
      return 1;
    }

    return 0;
  }

  getAllCourses() async {
    var data = await service.getFromApi(RestApiType.allCourses);
    if (data is String) {
      errorText = data;
    } else {
      allCourses = data;
      allCourses.sort(sortByLikes);
      allCourses = allCourses.reversed.toList();
    }
  }

  getFrequentCourses() async {
    var data = await service.getFromApi(RestApiType.frequentCourses);
    if (data is String) {
      errorText = data;
    } else {
      frequentCourses = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (loading) {
        return Center(child: CircularProgressIndicator());
      }
      if (error) {
        return ErrorDisplayWidget(
          errorText: errorText,
          callback: getData,
        );
      }
      if (!loading && !error) {
        return RefreshIndicator(
          onRefresh: () => getData(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: LikesDislikesCoursesSummaryCard(
                      courses: allCourses,
                      callback: () => getData(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: FrequentCoursesSummaryCard(frequentCourses: frequentCourses),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Text("ERROR");
    });
  }
}
