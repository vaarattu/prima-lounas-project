import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';
import 'package:priima_lounas_flutter/widgets/error_display.dart';
import 'package:priima_lounas_flutter/widgets/frequent_courses_summary_card.dart';

class RestaurantVoteListsPage extends StatefulWidget {
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

  vote() async {
    List<CourseVote> votes = [];
    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.postToApi(RestApiType.votes, votes);
    if (data is String) {
      //TODO ERROR
    } else {
      List<CourseVote> updatedVotes = data;
    }
  }

  getData() async {
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

  getAllCourses() async {
    var data = await service.getFromApi(RestApiType.allCourses);
    if (data is String) {
      errorText = data;
    } else {
      allCourses = data;
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
          callback: getFrequentCourses,
        );
      }
      if (!loading && !error) {
        return FrequentCoursesSummaryCard(frequentCourses: frequentCourses);
      }
      return Text("ERROR");
    });
  }
}
