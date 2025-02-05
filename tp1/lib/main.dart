import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:math';
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
        title: 'TP1',
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
class MyHomePage extends StatelessWidget {
  final List<String> recettes = [
    "Spaghetti Carbonara",
    "Salade César",
    "Tiramisu",
    "Soupe de légumes",
    "Poulet rôti"
  ];
  @override
  Widget build(BuildContext context) {
    final random = Random();
    String recetteAleatoire = recettes[random.nextInt(recettes.length)];
    return Scaffold(
      appBar: AppBar(title: Text("Nos suggestions")),
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
              child: Text("Accèder à la recette"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GeneratorPage(),
    );

    
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
}

// Page avec tout le contenu trié
class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No content yet.'),
    );
     
  }
}


class GeneratorPage extends StatefulWidget {

  GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  var selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MyHomePage(); 
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
    

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
              
            });
          },
          
          backgroundColor: Colors.black, // Couleur de la barre
          selectedItemColor: Color.fromRGBO(216,195,165, 1.0), // Couleur des icônes sélectionnées
          unselectedItemColor: Color.fromRGBO(245,237,225, 1.0),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: "Recettes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoris",
            ),
          ],
        ),
    );
  }
}