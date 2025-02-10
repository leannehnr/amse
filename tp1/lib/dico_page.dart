import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'recette_model.dart';

class GeneratorPage extends StatefulWidget {
  @override
  GeneratorPageState createState() => GeneratorPageState();
}

class GeneratorPageState extends State<GeneratorPage> {
  List<Recette> recettes = [];

  @override
  void initState() {
    super.initState();
    chargerDepuisFichier();
  }

  Future<void> chargerDepuisFichier() async {
  try {
    // Lire le fichier JSON depuis les assets
    String jsonString = await rootBundle.loadString('assets/recettes.json');

    // Décoder le JSON en un Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Accéder à la clé "recettes" et récupérer la liste des recettes
    List<dynamic> recettesData = jsonData['recettes'];

    // Convertir chaque élément en une instance de Recette
    List<Recette> liste = recettesData.map((item) => Recette.fromJson(item)).toList();

    // Charger les favoris depuis SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var recette in liste) {
      bool isFavori = prefs.getBool('favori_${recette.id}') ?? false;
      recette.favori = isFavori;
    }

    setState(() {
      recettes = liste;
    });
  } catch (e) {
    print('Erreur lors du chargement des données : $e');
  }
}

  
  Future<void> sauvegarderFavori(Recette recette) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favori_${recette.id}', recette.favori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Utilisation de Scaffold pour une meilleure structure
      appBar: AppBar(title: Text("Liste des Recettes")), // Optionnel : une barre d'app
      body: recettes.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader en attendant le chargement
          : ListView.builder(
              padding: EdgeInsets.all(10), // Ajout d'un padding pour l'esthétique
              itemCount: recettes.length, // Nombre d'éléments
              itemBuilder: (context, index) {
                final recette = recettes[index];
                return Card(
                  elevation: 3, // Ombre pour un meilleur effet visuel
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text('${recette.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(recette.nom),
                    leading: Image.asset(recette.image,
                      width: 50, // Ajuste la taille
                      height: 50,
                      fit: BoxFit.cover, // Évite la distorsion
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        recette.favori ? Icons.favorite : Icons.favorite_border, // Icône rouge si favori
                        color: recette.favori ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          recette.favori = !recette.favori; // Change l'état favori
                        });
                        sauvegarderFavori(recette);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
