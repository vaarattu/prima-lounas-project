import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prima_lounas_flutter/model/allergy_enum.dart';
import 'package:prima_lounas_flutter/utils/icons.dart';

import 'model/restaurant_menu_request.dart';
import 'services/networking.dart';

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
  List<RestaurantDayItem> items = [];

  @override
  void initState() {
    super.initState();
    getRestaurantMenu();
  }

  void getRestaurantMenu() async {
    NetworkHelper networkHelper = NetworkHelper("http://10.0.2.2:8888/api/v1/week");
    var restaurantData = await networkHelper.getData();
    final restaurantMenuRequest = restaurantMenuRequestFromJson(restaurantData);
    // succesful request and got items
    if (restaurantMenuRequest.responseCode == 1 && restaurantMenuRequest.items.length > 0) {
      items = restaurantMenuRequest.items;
    } else {
      // success but no items for some reason
      if (restaurantMenuRequest.responseCode == 2) {
        String errorText = "No items were returned";
      }
      // display error
      else {
        String errorText = restaurantMenuRequest.errorText;
      }
    }
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

    return RestaurantDayItem(day: "ERROR", courses: [
      RestaurantCourseItem(name: "ERROR", price: "ERROR", type: "ERROR", flags: []),
    ]);
  }

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
    return Scaffold(
      body: SafeArea(
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
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: getCourseIcon(course),
                                        ),
                                        Column(
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
                                                    child: AllergyIcon(
                                                        allergyType:
                                                            flag == "G" ? AllergyType.Wheat : AllergyType.Lactose),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: getCourseIcon(course),
                                          ),
                                          Column(
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
                                                height: course.flags.length == 0 ? 0 : 36,
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: course.flags.length,
                                                  itemBuilder: (context, index) {
                                                    String flag = course.flags[index];
                                                    return Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: AllergyIcon(
                                                          allergyType:
                                                              flag == "G" ? AllergyType.Wheat : AllergyType.Lactose),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
    );
  }
}

class AllergyIcon extends StatelessWidget {
  final AllergyType allergyType;

  AllergyIcon({required this.allergyType});

  MaterialColor getColor() {
    return allergyType == AllergyType.Wheat ? Colors.yellow : Colors.blue;
  }

  IconData getIcon() {
    return allergyType == AllergyType.Wheat ? PrimaLounasIcons.no_wheat : PrimaLounasIcons.no_milk;
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
        child: Icon(
          getIcon(),
          size: 20,
          color: getColor().shade100,
        ),
      ),
    );
  }
}
