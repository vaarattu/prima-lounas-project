import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';
import 'package:priima_lounas_flutter/utils/icons.dart';
import 'package:priima_lounas_flutter/utils/trophy_icons.dart';
import 'package:priima_lounas_flutter/widgets/error_display.dart';

class RestaurantVoteListsPage extends StatefulWidget {
  @override
  _RestaurantVoteListsPageState createState() => _RestaurantVoteListsPageState();
}

class _RestaurantVoteListsPageState extends State<RestaurantVoteListsPage> {
  late List<FrequentCourseItem> items;

  bool loading = true;
  bool error = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    getFrequentCourses();
  }

  vote() async {
    List<CourseVote> votes = [];
    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.postToApi(RestApiType.vote, votes);
    if (data is String) {
      //TODO ERROR
    } else {
      List<CourseVote> updatedVotes = data;
    }
  }

  getFrequentCourses() async {
    setState(() {
      loading = true;
      error = false;
    });

    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.getFromApi(RestApiType.frequentCourses);

    if (data is String) {
      setState(() {
        loading = false;
        error = true;
        errorText = data;
      });
    } else {
      setState(() {
        loading = false;
        error = false;
        items = data;
      });
    }
  }

  Widget getCourseIcon(String courseName, int index) {
    // default
    IconData data = PrimaLounasIcons.dish;
    Color color = Colors.teal;
    double size = 28;
    double paddingAmount = 6;
    if (courseName.contains("pöytä")) {
      data = PrimaLounasIcons.salad;
      color = Colors.green;
    }
    if (courseName.contains("keitto")) {
      data = PrimaLounasIcons.soup;
      color = Colors.pink;
    }

    if (index == 0) {
      data = PriimaLounasTrophies.trophy;
      color = Colors.yellow;
      size = 40;
      paddingAmount = 0;
    }
    if (index == 1) {
      data = PriimaLounasTrophies.trophy_alt;
      color = Colors.grey;
      size = 36;
      paddingAmount = 2;
    }
    if (index == 2) {
      data = PriimaLounasTrophies.trophy_alt;
      color = Colors.brown;
      size = 32;
      paddingAmount = 4;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingAmount),
      child: Icon(
        data,
        size: size,
        color: color,
      ),
    );
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
        return Container(
          width: double.infinity,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ruokalaji",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Esiintyvyys",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      FrequentCourseItem course = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      getCourseIcon(course.name, index),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 18),
                                              child: Text(
                                                course.name,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  course.count.toString(),
                                  style: TextStyle(fontSize: 18),
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
        );
      }
      return Text("ERROR");
    });
  }
}
