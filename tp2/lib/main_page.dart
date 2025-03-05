import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2/exo1_page.dart';
import 'package:tp2/exo2_page.dart';
import 'package:tp2/exo3_page.dart';
import 'package:tp2/exo4_page.dart';
import 'package:tp2/exo5_page.dart';
import 'package:tp2/exo6_page.dart';
import 'package:tp2/exo6b_page.dart';
import 'package:tp2/taquin.dart';
import 'package:tp2/taquinV2_select.dart';
import 'package:tp2/settings_page.dart';
import 'package:tp2/theme_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> exercises = [
    {"title": "Exo 1", "page": Exo1Page()},
    {"title": "Exo 2", "page": Exo2Page()},
    {"title": "Exo 3", "page": Exo3Page()},
    {"title": "Exo 4", "page": DisplayTileWidget()},
    {"title": "Exo 5", "page": Exo5Page()},
    {"title": "Exo 6", "page": PositionedTiles()},
    {"title": "Exo 6b", "page": Exo6bPage()},
    {"title": "Taquin", "page": Taquin()},
    {"title": "Taquin 2", "page": TaquinV2Select()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Menu des Exercices"),
              centerTitle: true,
              background: Container(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.black54
                      : const Color.fromARGB(255, 202, 167, 235)),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => exercises[index]["page"]),
                      );
                    },
                    child: Text(exercises[index]["title"]),
                  ),
                );
              },
              childCount: exercises.length,
            ),
          ),
        ],
      ),
    );
  }
}
