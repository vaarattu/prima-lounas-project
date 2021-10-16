import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/services/restaurant_menu_service.dart';
import 'package:priima_lounas_flutter/widgets/error_display.dart';
import 'package:priima_lounas_flutter/widgets/restaurant_course_card.dart';

class RestaurantMenuPage extends StatefulWidget {
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  bool loading = true;
  bool error = false;
  String errorText = "";
  late RestaurantWeekMenuItem weekMenu;

  @override
  void initState() {
    super.initState();
    getWeekMenu();
  }

  getWeekMenu() async {
    setState(() {
      error = false;
      loading = true;
    });

    RestaurantMenuService service = RestaurantMenuService();
    var data = await service.getFromApi(RestApiType.weekMenu);
    if (data is String) {
      setState(() {
        error = true;
        loading = false;
        errorText = data;
      });
    } else {
      if (data.length == 0) {
        setState(() {
          error = true;
          loading = false;
          errorText = "Tämän viikon ruokalista ei ole vielä saatavilla.";
        });
      } else {
        setState(() {
          error = false;
          loading = false;
          weekMenu = data[0];
        });
      }
    }
  }

  String fixDayName(String dayName) {
    dayName = dayName.replaceAll("Ma", "Maanantaina");
    dayName = dayName.replaceAll("Ti", "Tiistaina");
    dayName = dayName.replaceAll("Ke", "Keskiviikkona");
    dayName = dayName.replaceAll("To", "Torstaina");
    dayName = dayName.replaceAll("Pe", "Perjantaina");

    return dayName + ".";
  }

  Day getToday() {
    DateTime now = DateTime.now();
    int weekDay = now.weekday;

    // is weekend
    if (weekDay == 6 || weekDay == 7) {
      int id = -1;
      if (getTomorrow().id != -1) {
        id = -2;
      }
      return Day(id: id, day: "ERROR", courses: [
        Course(
            id: -1,
            name: "ERROR",
            price: "ERROR",
            type: "ERROR",
            tags: [],
            courseVote: new CourseVote(id: -1, likes: 0, dislikes: 0, votes: 0, ranked: 0)),
      ]);
    }

    int day = now.day;
    int month = now.month;

    for (Day item in weekMenu.days) {
      List<String> split = item.day.split(".");
      RegExp regExp = new RegExp(
        r"\d+",
        caseSensitive: false,
        multiLine: false,
      );
      String first = regExp.stringMatch(split.first).toString();
      String last = regExp.stringMatch(split.last).toString();
      if (int.parse(first) == day && int.parse(last) == month) {
        return item;
      }
    }

    // current day not found
    return Day(id: 0, day: "ERROR", courses: [
      Course(
          id: 0,
          name: "ERROR",
          price: "ERROR",
          type: "ERROR",
          tags: [],
          courseVote: new CourseVote(id: 0, likes: 0, dislikes: 0, votes: 0, ranked: 0)),
    ]);
  }

  Day getTomorrow() {
    DateTime now = DateTime.now();
    now = now.add(new Duration(days: 1));
    int weekDay = now.weekday;

    // is weekend
    if (weekDay == 6 || weekDay == 7) {
      return Day(id: -1, day: "ERROR", courses: [
        Course(
            id: -1,
            name: "ERROR",
            price: "ERROR",
            type: "ERROR",
            tags: [],
            courseVote: new CourseVote(id: -1, likes: 0, dislikes: 0, votes: 0, ranked: 0)),
      ]);
    }

    int day = now.day;
    int month = now.month;

    for (Day item in weekMenu.days) {
      List<String> split = item.day.split(".");
      RegExp regExp = new RegExp(
        r"\d+",
        caseSensitive: false,
        multiLine: false,
      );
      String first = regExp.stringMatch(split.first).toString();
      String last = regExp.stringMatch(split.last).toString();
      if (int.parse(first) == day && int.parse(last) == month) {
        return item;
      }
    }

    // current day not found
    return Day(id: -1, day: "ERROR", courses: [
      Course(
          id: 0,
          name: "ERROR",
          price: "ERROR",
          type: "ERROR",
          tags: [],
          courseVote: new CourseVote(id: 0, likes: 0, dislikes: 0, votes: 0, ranked: 0)),
    ]);
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
          callback: getWeekMenu,
        );
      }
      if (!loading && !error) {
        return RefreshIndicator(
          onRefresh: () => getWeekMenu(),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Priima Lounas Ky",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lounas",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                            Icon(
                              Icons.access_time,
                              size: 20,
                            ),
                            Text(
                              "10:30-13:00",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Salaatti: 4,70€",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Keitto: 6,00€",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Kotiruoka: 7,00€",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    if (getToday().id == -1) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Ensi viikon ruokalista on yleensä saatavilla sunnuntai-illasta tai maanantaiaamusta.",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                    if (getToday().id == -2) {
                      return Container();
                    }
                    return Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Tänään, ${fixDayName(getToday().day)}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: getToday().courses.length,
                            itemBuilder: (context, index) {
                              Course course = getToday().courses[index];
                              return RestaurantCourseCard(
                                course: course,
                                showVoteButtons: true,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  getTomorrow().id == -1
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Huomenna, ${fixDayName(getTomorrow().day)}",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: getTomorrow().courses.length,
                                  itemBuilder: (context, index) {
                                    Course course = getTomorrow().courses[index];
                                    return RestaurantCourseCard(
                                      course: course,
                                      showVoteButtons: false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      "KOKO " + weekMenu.weekName,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: weekMenu.days.length,
                    itemBuilder: (context, index) {
                      Day item = weekMenu.days[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                            child: Text(
                              fixDayName(item.day),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: item.courses.length,
                            itemBuilder: (context, index) {
                              Course course = item.courses[index];
                              return RestaurantCourseCard(
                                course: course,
                                showVoteButtons: false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      }
      return Text("ERROR");
    });
  }
}
