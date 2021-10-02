import 'dart:io';

import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import "package:http/http.dart" as http;
import 'package:priima_lounas_flutter/utils/constants.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class RestaurantHistoryPage extends StatefulWidget {
  @override
  _RestaurantHistoryPageState createState() => _RestaurantHistoryPageState();
}

class _RestaurantHistoryPageState extends State<RestaurantHistoryPage> {
  late List<RestaurantWeekMenuItem> items;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getRestaurantWeekMenu();
  }

  Future getRestaurantWeekMenu() async {
    try {
      http.Response response = await http.get(Uri.parse(dropletUrl + "/api/v1/all"),
          headers: {HttpHeaders.acceptHeader: "application/json; charset=UTF-8"}).timeout(
        const Duration(seconds: 10),
      );
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        String json = response.body;
        setState(() {
          items = restaurantWeekMenuItemFromJson(json);
          items.sort((a, b) => b.id.compareTo(a.id));
          loading = false;
        });
      }
    } catch (e) {
      String s = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (loading) {
        return Text("Loading");
      } else {
        return Container(
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              RestaurantWeekMenuItem week = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                child: Card(
                  child: ExpansionTileCard(
                    title: Text(week.weekName, style: TextStyle(fontSize: 20)),
                    subtitle: Text(week.days[0].day + " - " + week.days[week.days.length - 1].day),
                    baseColor: Theme.of(context).cardColor,
                    expandedTextColor: Colors.white,
                    shadowColor: Colors.transparent,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: week.days.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Day day = week.days[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day.day,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: day.courses.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Course course = day.courses[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                        child: Text(
                                          course.name,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
