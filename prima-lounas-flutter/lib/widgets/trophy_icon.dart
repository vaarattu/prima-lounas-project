import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/utils/trophy_icons.dart';

class TrophyIcon extends StatelessWidget {
  const TrophyIcon({Key? key, required this.index}) : super(key: key);

  final int index;

  Widget getTrophyIcon() {
    // default
    IconData data = PriimaLounasTrophies.trophy_alt;
    Color color = Colors.red;
    double size = 36;

    if (index == 0) {
      data = PriimaLounasTrophies.trophy;
      color = Colors.yellow;
    }
    if (index == 1) {
      data = PriimaLounasTrophies.trophy_alt;
      color = Colors.grey;
    }
    if (index == 2) {
      data = PriimaLounasTrophies.trophy_alt;
      color = Colors.brown;
    }

    return Icon(
      data,
      size: size,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getTrophyIcon();
  }
}
