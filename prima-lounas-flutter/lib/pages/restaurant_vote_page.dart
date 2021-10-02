import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/utils/constants.dart';

class RestaurantVotePage extends StatefulWidget {
  @override
  _RestaurantVotePageState createState() => _RestaurantVotePageState();
}

class _RestaurantVotePageState extends State<RestaurantVotePage> {
  @override
  void initState() {
    super.initState();
    vote();
  }

  Future vote() async {
    List<CourseVote> votes = [];
    votes.add(new CourseVote(id: 1, likes: 10, dislikes: -2, votes: 20, ranked: 4));
    votes.add(new CourseVote(id: 2, likes: 5, dislikes: -3, votes: 50, ranked: 0));
    http.Response response = await http.post(Uri.parse(localhostUrl + "/api/v1/vote"),
        body: courseVoteListToJson(votes),
        headers: {HttpHeaders.acceptHeader: "application/json; charset=UTF-8"}).timeout(
      const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
