import 'dart:io';

import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/utils/constants.dart';
import "package:http/http.dart" as http;
import 'package:priima_lounas_flutter/utils/icons.dart';
import 'package:priima_lounas_flutter/utils/trophy_icons.dart';

class RestaurantListsPage extends StatefulWidget {
  @override
  _RestaurantListsPageState createState() => _RestaurantListsPageState();
}

class _RestaurantListsPageState extends State<RestaurantListsPage> {
  late List<FrequentCourseItem> items;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getRestaurantWeekMenu();
  }

  Future getRestaurantWeekMenu() async {
    try {
      http.Response response = await http.get(Uri.parse(dropletUrl + "/api/v1/frequent"),
          headers: {HttpHeaders.acceptHeader: "application/json; charset=UTF-8"}).timeout(
        const Duration(seconds: 10),
      );
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String json = response.body;
        setState(() {
          items = frequentCourseItemFromJson(json);
          loading = false;
        });
      }
    } catch (e) {
      String s = e.toString();
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
        return Text("Loading");
      } else {
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
    });
  }
}
