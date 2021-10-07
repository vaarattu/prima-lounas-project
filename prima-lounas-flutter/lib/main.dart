import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/pages/restaurant_history_page.dart';
import 'package:priima_lounas_flutter/pages/restaurant_more_page.dart';
import 'package:priima_lounas_flutter/pages/restaurant_vote_lists_page.dart';
import 'package:priima_lounas_flutter/pages/restaurant_menu_page.dart';
import 'package:priima_lounas_flutter/widgets/lazy_indexed_stack.dart';

void main() {
  runApp(PriimaLounasApp());
}

class PriimaLounasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Priima Lounas",
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomBarIndex = 0;

  final pages = [RestaurantMenuPage(), RestaurantVoteListsPage(), RestaurantHistoryPage(), RestaurantMorePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: bottomBarIndex,
        onTap: (index) => setState(() => bottomBarIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 25,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Ruokalista",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: "Äänestä",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historia",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label: "Muut",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      body: SafeArea(
          child: LazyIndexedStack(
        index: bottomBarIndex,
        children: pages,
      )),
    );
  }
}
