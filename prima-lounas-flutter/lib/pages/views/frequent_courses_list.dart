import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/model/frequent_course_item.dart';
import 'package:priima_lounas_flutter/widgets/course_data_row.dart';

class FrequentCoursesList extends StatelessWidget {
  const FrequentCoursesList({Key? key, required this.frequentCourses}) : super(key: key);

  final List<FrequentCourseItem> frequentCourses;

  @override
  Widget build(BuildContext context) {
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
                itemCount: frequentCourses.length,
                itemBuilder: (context, index) {
                  FrequentCourseItem course = frequentCourses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Card(child: CourseDataRow(courseName: course.name, index: index, count: course.count)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
