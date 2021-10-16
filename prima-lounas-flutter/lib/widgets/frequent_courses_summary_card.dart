import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';

import 'course_data_row.dart';

class FrequentCoursesSummaryCard extends StatelessWidget {
  const FrequentCoursesSummaryCard({Key? key, required this.frequentCourses}) : super(key: key);

  final List<FrequentCourseItem> frequentCourses;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            onPressed: () => {},
            child: Text("Näytä kaikki"),
          ),
        ],
      ),
    );
  }
}
