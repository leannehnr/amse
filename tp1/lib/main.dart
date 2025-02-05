import 'package:flutter/material.dart';
import 'home_page.dart'; // Page d'accueil
import 'dico_page.dart'; // Page de génération de recettes
import 'favorites_page.dart'; // Page des favoris

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Index de la page active

  final List<Widget> _pages = [
    HomePage(),       // Page Accueil
    GeneratorPage(),  // Page Générateur
    FavoritesPage(),  // Page Favoris
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Affiche la page sélectionnée

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFFD8C3A5), // Beige
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen), // Icône pour le générateur de recettes
            label: "Générateur",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoris",
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD8C3A5),
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // Action pour ajouter une recette
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
