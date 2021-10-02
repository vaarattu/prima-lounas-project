import 'dart:io';

import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import "package:http/http.dart" as http;
import 'package:priima_lounas_flutter/utils/constants.dart';
import 'package:priima_lounas_flutter/widgets/restaurant_course_card.dart';

class RestaurantMenuPage extends StatefulWidget {
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  bool isLoading = true;
  bool isError = false;
  String customErrorText = "";
  String originalErrorText = "";
  late RestaurantWeekMenuItem weekMenu;

  @override
  void initState() {
    super.initState();
    getRestaurantWeekMenu();
  }

  Future getRestaurantWeekMenu() async {
    setState(() {
      isError = false;
      isLoading = true;
    });

    try {
      http.Response response = await http.get(Uri.parse(dropletUrl + "/api/v1/menu"),
          headers: {HttpHeaders.acceptHeader: "application/json; charset=UTF-8"}).timeout(
        const Duration(seconds: 10),
      );
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String json = response.body;
        setState(() {
          weekMenu = restaurantWeekMenuItemFromJson(json)[0];
        });
      } else {
        isError = true;
        originalErrorText = response.body;
      }
    } catch (e) {
      isError = true;
      originalErrorText = e.toString();
      if (originalErrorText.contains("RangeError")) {
        customErrorText = "Tämän viikon ruokalista ei ole vielä saatavilla.";
      }
      if (originalErrorText.contains("Connection failed") || originalErrorText.contains("SocketException")) {
        originalErrorText = originalErrorText.replaceAll("165.22.81.146", "*");
        customErrorText = "Yhteys epäonnistui. \nPalvelin on alhaalla tai et ole yhteydessä Internettiin.";
      }
      if (originalErrorText.contains("TimeoutException")) {
        customErrorText =
            "Palvelin ei vastannut ajoissa. \nJoko palvelin on alhaalla tai Internetyhteytesi käy hitaalla.";
      }
    }

    setState(() {
      isLoading = false;
      isError = isError;
    });
  }

  Day getToday() {
    DateTime now = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (isError) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Tapahtui virhe: \n\n" + originalErrorText + "\n\n\nTulkinta: \n\n" + customErrorText + "\n\n",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => getRestaurantWeekMenu(),
              child: Text("Yritä uudelleen"),
            ),
          ],
        );
      }
      if (!isLoading && !isError) {
        return RefreshIndicator(
          onRefresh: () => getRestaurantWeekMenu(),
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
                  getToday().id == -1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Ensi viikon ruokalista on yleensä saatavilla sunnuntai-illasta tai maanantaiaamusta.",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(
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
                                  Course course = getToday().courses[index];
                                  return RestaurantCourseCard(course: course);
                                },
                              ),
                            ],
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: 36),
                    child: Text(
                      weekMenu.weekName,
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
                              item.day,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: item.courses.length,
                            itemBuilder: (context, index) {
                              Course course = item.courses[index];
                              return RestaurantCourseCard(course: course);
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
