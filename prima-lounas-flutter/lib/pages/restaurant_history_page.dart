import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prima_lounas_flutter/model/restaurant_day_item.dart';
import "package:http/http.dart" as http;
import 'package:prima_lounas_flutter/utils/constants.dart';

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
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              RestaurantWeekMenuItem week = items[index];
              return Card(
                child: Text(week.weekName),
              );
            },
          ),
        );
      }
    });
  }
}
