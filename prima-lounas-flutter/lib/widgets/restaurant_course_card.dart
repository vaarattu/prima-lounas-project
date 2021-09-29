import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/restaurant_day_item.dart';
import 'package:priima_lounas_flutter/utils/icons.dart';
import 'package:priima_lounas_flutter/widgets/allergy_icon.dart';

class RestaurantCourseCard extends StatelessWidget {
  const RestaurantCourseCard({
    required this.course,
  });

  final Course course;

  Icon getCourseIcon(Course course) {
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
                            height: course.tags.length == 0 ? 0 : 8,
                          ),
                          SizedBox(
                            height: course.tags.length == 0 ? 0 : 30,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: course.tags.length,
                              itemBuilder: (context, index) {
                                String flag = course.tags[index];
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
