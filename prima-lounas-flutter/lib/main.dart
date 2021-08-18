import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prima_lounas_flutter/utils/constants.dart';
import 'package:prima_lounas_flutter/utils/icons.dart';

import 'model/restaurant_day_item.dart';
import "package:http/http.dart" as http;

void main() {
  runApp(PrimaLounasApp());
}

class PrimaLounasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Prima Lounas",
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool isError = false;
  List<RestaurantDayItem> items = [];

  @override
  void initState() {
    super.initState();
    getRestaurantMenu();
  }

  Future getRestaurantMenu() async {
    String errorText;
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      http.Response response = await http
          .get(
            Uri.parse(herokuURL),
          )
          .timeout(
            const Duration(seconds: 5),
          );
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String json = response.body;
        setState(() {
          items = restaurantDayItemFromJson(json);
        });
      } else {
        errorText = response.body;
        isError = true;
      }
    } catch (e) {
      errorText = e.toString();
      isError = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  RestaurantDayItem getToday() {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;

    for (RestaurantDayItem item in items) {
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
    return RestaurantDayItem(day: "ERROR", courses: [
      RestaurantCourseItem(name: "ERROR", price: "ERROR", type: "ERROR", flags: []),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => getRestaurantMenu(),
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
                          "Prima Lounas Ky",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Tänään, ${getToday().day}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: getToday().courses.length,
                          itemBuilder: (context, index) {
                            RestaurantCourseItem course = getToday().courses[index];
                            return RestaurantCourseCard(course: course);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36),
                    child: Text(
                      "Ruokalista viikko 25",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      RestaurantDayItem item = items[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                            child: Text(
                              item.day,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: item.courses.length,
                            itemBuilder: (context, index) {
                              RestaurantCourseItem course = item.courses[index];
                              return RestaurantCourseCard(course: course);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantCourseCard extends StatelessWidget {
  const RestaurantCourseCard({
    required this.course,
  });

  final RestaurantCourseItem course;

  Icon getCourseIcon(RestaurantCourseItem course) {
    // default
    IconData data = PrimaLounasIcons.dish;
    Color color = Colors.teal;
    if (course.type == "salad") {
      data = PrimaLounasIcons.salad;
      color = Colors.green;
    }
    if (course.type == "soup") {
      data = PrimaLounasIcons.soup;
      color = Colors.pink;
    }

    return Icon(
      data,
      size: 36,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: getCourseIcon(course),
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
                            height: course.flags.length == 0 ? 0 : 8,
                          ),
                          SizedBox(
                            height: course.flags.length == 0 ? 0 : 30,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: course.flags.length,
                              itemBuilder: (context, index) {
                                String flag = course.flags[index];
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
              Text(
                course.price,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllergyIcon extends StatelessWidget {
  final String allergyFlag;

  AllergyIcon({required this.allergyFlag});

  MaterialColor getColor() {
    if (allergyFlag == "G") {
      return Colors.yellow;
    }
    if (allergyFlag == "L") {
      return Colors.blue;
    }
    return Colors.red;
  }

  Icon getCourseIcon() {
    // default
    IconData data = Icons.error;
    Color color = getColor().shade100;

    if (allergyFlag == "G") {
      data = PrimaLounasIcons.no_wheat;
    }
    if (allergyFlag == "L") {
      data = PrimaLounasIcons.no_milk;
    }

    return Icon(
      data,
      size: 20,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColor().shade900,
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: getCourseIcon(),
      ),
    );
  }
}
