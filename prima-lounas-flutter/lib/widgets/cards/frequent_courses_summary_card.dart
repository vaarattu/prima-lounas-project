import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/pages/views/frequent_courses_list.dart';

import '../course_data_row.dart';

class FrequentCoursesSummaryCard extends StatelessWidget {
  const FrequentCoursesSummaryCard({Key? key, required this.frequentCourses}) : super(key: key);

  final List<FrequentCourseItem> frequentCourses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Yleisimmät",
          style: TextStyle(fontSize: 20),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CourseDataRow(
                          course: frequentCourses[index],
                          index: index,
                          count: frequentCourses[index].count,
                          showLikesDislikes: false,
                        ),
                        Divider(
                          height: 2,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FrequentCoursesList(
                          frequentCourses: this.frequentCourses,
                        ),
                      ),
                    );
                  },
                  child: Text("Näytä kaikki"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
