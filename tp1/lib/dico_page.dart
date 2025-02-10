import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour rootBundle
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
    String jsonString = await rootBundle.loadString('assets/recettes.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString); // Décodage en Map

    // Vérifier si la clé "recettes" existe et est bien une liste
    if (jsonData.containsKey('recettes') && jsonData['recettes'] is List) {
      List<dynamic> recettesJson = jsonData['recettes']; // Extraire la liste
      
      List<Recette> liste = recettesJson.map((item) => Recette.fromJson(item)).toList();

      setState(() {
        recettes = liste;
      });
    } else {
      throw Exception("Le JSON ne contient pas de liste 'recettes'");
    }
  } catch (e) {
    print('Erreur lors du chargement des données : $e');
  }
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
                  ),
                );
              },
            ),
    );
  }
}
