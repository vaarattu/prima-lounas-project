import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prima_lounas_flutter/model/allergy_enum.dart';
import 'package:prima_lounas_flutter/model/restaurant_course_item.dart';
import 'package:prima_lounas_flutter/model/restaurant_day_item.dart';
import 'package:prima_lounas_flutter/utils/icons.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    items.clear();

    List<RestaurantCourseItem> courses = [
      RestaurantCourseItem("Salaattipöytä", []),
      RestaurantCourseItem("Uunimakkaraa, perunamuusia", ["L", "G"]),
      RestaurantCourseItem("Juustoista kukkakaalikeittoa", ["L", "G"]),
    ];
    items.add(RestaurantDayItem("Ma 21.6", courses));

    courses = [
      RestaurantCourseItem("Salaattipöytä", []),
      RestaurantCourseItem("Parmesan broilerpihviä, riisiä", ["L", "G"]),
      RestaurantCourseItem("Jauhelihakeittoa", ["L", "G"]),
    ];
    items.add(RestaurantDayItem("Ti 22.6", courses));

    courses = [
      RestaurantCourseItem("Antipastopöytä", []),
      RestaurantCourseItem("Janssoninkiusausta", ["L", "G"]),
      RestaurantCourseItem("Herkkusienikeittoa", ["L", "G"]),
    ];
    items.add(RestaurantDayItem("Ke 23.6", courses));

    courses = [
      RestaurantCourseItem("Salaattipöytä", []),
      RestaurantCourseItem("Uunipossua, paistinkastiketta", []),
      RestaurantCourseItem("Hernekeittoa", []),
    ];
    items.add(RestaurantDayItem("To 24.6", courses));

    courses = [RestaurantCourseItem("Hyvää Juhannusta !", [])];
    items.add(RestaurantDayItem("Pe 25.6", courses));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  RestaurantDayItem item = items[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.day,
                            style: TextStyle(fontSize: 24),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: item.courses.length,
                            itemBuilder: (context, index) {
                              RestaurantCourseItem course = item.courses[index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    course.course,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: course.flags.length,
                                    itemBuilder: (context, index) {
                                      String flag = course.flags[index];
                                      return AllergyIcon(
                                        allergyType: flag == "G" ? AllergyType.Wheat : AllergyType.Lactose,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
    return allergyType == AllergyType.Wheat ? PrimaLounasIcons.wheatwip : PrimaLounasIcons.milkwip;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColor().shade100,
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          getIcon(),
          size: 24,
          color: getColor().shade900,
        ),
      ),
    );
  }
}
