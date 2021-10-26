import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/utils/icons.dart';

class AllergyIcon extends StatelessWidget {
  final String allergyFlag;

  AllergyIcon({required this.allergyFlag});

  MaterialColor getColor() {
    if (allergyFlag == "G") {
      return Colors.yellow;
    }
    if (allergyFlag == "L") {
      return Colors.blue;
    }
    return Colors.red;
  }

  Icon getCourseIcon() {
    // default
    IconData data = Icons.error;
    Color color = getColor().shade100;

    if (allergyFlag == "G") {
      data = PrimaLounasIcons.no_wheat;
    }
    if (allergyFlag == "L") {
      data = PrimaLounasIcons.no_milk;
    }

    return Icon(
      data,
      size: 20,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getColor().shade900,
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: getCourseIcon(),
      ),
    );
  }
}
