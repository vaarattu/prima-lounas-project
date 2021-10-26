import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/pages/views/frequent_courses_list.dart';

import '../course_data_row.dart';

class FrequentCoursesSummaryCard extends StatelessWidget {
  const FrequentCoursesSummaryCard({Key? key, required this.frequentCourses}) : super(key: key);

  final List<FrequentCourseItem> frequentCourses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              "Yleisimmät",
              style: TextStyle(fontSize: 18),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CourseDataRow(
                    courseName: frequentCourses[index].name, index: index, count: frequentCourses[index].count);
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
    );
  }
}
