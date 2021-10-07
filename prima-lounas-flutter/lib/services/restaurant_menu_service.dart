import 'dart:io';

import 'package:priima_lounas_flutter/model/rest_type_enums.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/model/restaurant_week_menu_item.dart';
import 'package:priima_lounas_flutter/services/networking.dart';
import 'package:tuple/tuple.dart';

const apiWeekMenu = "/menu";
const apiAllWeeks = "/all";
const apiFrequentCourses = "/frequent";
const apiAllCourses = "/courses";
const apiVote = "/vote";

class RestaurantMenuService {
  Networking _networking = Networking();

  Future getFromApi(RestApiType type) async {
    String apiPath = _getFetchTypePath(type);
    var data = await _networking.getFromApiPath(apiPath);
    return _handleData(type, data);
  }

  Future postToApi(RestApiType type, dynamic body) async {
    String apiPath = _getFetchTypePath(type);
    String json = _getJsonFromObject(type, body);
    var data = await _networking.postToApiPath(apiPath, json);
    return _handleData(type, data);
  }

  dynamic _handleData(RestApiType type, dynamic data) {
    if (data is Tuple2) {
      int code = data.item1;
      String response = data.item2;
      if (code == HttpStatus.ok) {
        return _getObjectFromJson(type, response);
      } else {
        return response;
      }
    } else {
      return data;
    }
  }

  String _getFetchTypePath(RestApiType type) {
    switch (type) {
      case RestApiType.weekMenu:
        return apiWeekMenu;
      case RestApiType.allWeeks:
        return apiAllWeeks;
      case RestApiType.frequentCourses:
        return apiFrequentCourses;
      case RestApiType.allCourses:
        return apiAllCourses;
      case RestApiType.vote:
        return apiVote;
    }
  }

  dynamic _getObjectFromJson(RestApiType type, String json) {
    switch (type) {
      case RestApiType.weekMenu:
      case RestApiType.allWeeks:
        return restaurantWeekMenuItemFromJson(json);
      case RestApiType.frequentCourses:
        return frequentCourseItemFromJson(json);
      case RestApiType.allCourses:
        return courseFromJson(json);
      case RestApiType.vote:
        return courseVoteListFromJson(json);
    }
  }

  String _getJsonFromObject(RestApiType type, dynamic object) {
    switch (type) {
      case RestApiType.weekMenu:
      case RestApiType.allWeeks:
        return restaurantWeekMenuItemToJson(object);
      case RestApiType.frequentCourses:
        return frequentCourseItemToJson(object);
      case RestApiType.allCourses:
        return courseToJson(object);
      case RestApiType.vote:
        return courseVoteListToJson(object);
    }
  }
}
