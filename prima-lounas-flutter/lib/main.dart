import 'package:flutter/material.dart';
import 'package:priima_lounas_flutter/pages/restaurant_history_page.dart';
import 'package:priima_lounas_flutter/pages/restaurant_lists_page.dart';
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

  final pages = [RestaurantMenuPage(), RestaurantListsPage(), RestaurantHistoryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Listat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historia",
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
