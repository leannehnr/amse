import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


void main() {
  runApp(MyApp());
}

Future<List<Recette>> chargerRecettes() async {
  final String response = await rootBundle.loadString('assets/recettes.json');
  final data = json.decode(response);
  return (data["recettes"] as List).map((json) => Recette.fromJson(json)).toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(245,237,225, 1.0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// Classe recette 
class Recette {
  final int id;
  final String nom;
  final String type;
  final String regime;
  final String tempsPreparation;
  final String tempsCuisson;
  final List<String> ingredients;
  final List<String> etapes;
  final String image;

  Recette({
    required this.id,
    required this.nom,
    required this.type,
    required this.regime,
    required this.tempsPreparation,
    required this.tempsCuisson,
    required this.ingredients,
    required this.etapes,
    required this.image,
  });

  factory Recette.fromJson(Map<String, dynamic> json) {
    return Recette(
      id: json["id"],
      nom: json["nom"],
      type: json["type"],
      regime: json["regime"],
      tempsPreparation: json["temps_preparation"],
      tempsCuisson: json["temps_cuisson"],
      ingredients: List<String>.from(json["ingredients"]),
      etapes: List<String>.from(json["etapes"]),
      image: json["image"],
    );
  }
}


// Page avec le contenu à découvrir
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => 
  _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 
  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = ContentPage();
        break;
      case 2: 
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: page, // Affiche la page correspondant à l'index actuel
          bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.black, // Couleur de la barre
          ItemColor: Colors.beige, // Couleur des icônes sélectionnées
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: "Médias",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoris",
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
      );
    }
  }
}

// Page avec tout le contenu liké
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Center(
    child: Text('No favorites yet.'),
  );
}


// Page avec tout le contenu trié
class ContentPage extends StatelessWidget {
  class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Center(
    child: Text('No content yet.'),
  );
}
}


class GeneratorPage extends StatelessWidget {
  final List<String> recettes = [
    "Spaghetti Carbonara",
    "Salade César",
    "Tiramisu",
    "Soupe de légumes",
    "Poulet rôti"
  ];

  GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    String recetteAleatoire = recettes[random.nextInt(recettes.length)];

    return Scaffold(
      appBar: AppBar(title: Text("Recette du Jour")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recetteAleatoire,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Recharger la page pour obtenir une nouvelle recette
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GeneratorPage()),
                );
              },
              child: Text("Nouvelle suggestion"),
            ),
          ],
        ),
      ),
    );
  }
}