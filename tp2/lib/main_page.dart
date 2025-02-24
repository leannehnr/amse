import 'package:flutter/material.dart';
import 'package:tp2/exo1_page.dart';
import 'package:tp2/exo2_page.dart';
import 'package:tp2/exo3_page.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Index de la page active

  final List<Widget> _pages = [
    Exo1Page(), 
    Exo2Page(), 
    Exo3Page()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Exo1Page(),
                ),
              );}, 
              child: Text("Exo 1")), 
              SizedBox(height: 15),
              ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Exo2Page(),
                ),
              );}, 
              child: Text("Exo 2")), 
              SizedBox(height: 15),
              ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Exo3Page(),
                ),
              );}, 
              child: Text("Exo 3"))
            ],
          ),
        ],
      )

      
    );
  }
}