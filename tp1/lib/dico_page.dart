import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get_storage/get_storage.dart';
import 'gestion_fav.dart'; 
import 'recette_model.dart';

class GeneratorPage extends StatefulWidget {
  @override
  GeneratorPageState createState() => GeneratorPageState();
}

class GeneratorPageState extends State<GeneratorPage> {
  List<Recette> recettes = [];
  //List<Recette> favoris =[];
  GetStorage box = GetStorage(); // Crée une instance de stockage
  @override
  void initState() {
    super.initState();
    _chargerDepuisFichier();
  }

  Future<void> _chargerDepuisFichier() async {
    try {
      // Lire le fichier JSON depuis les assets
      String jsonString = await rootBundle.loadString('assets/recettes.json');

      // Décoder le JSON en un Map
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Vérifier si la clé "recettes" existe
      if (!jsonData.containsKey('recettes')) {
        print('Erreur : Clé "recettes" introuvable dans le JSON');
        return;
      }

      // Accéder à la clé "recettes" et récupérer la liste des recettes
      List<dynamic> recettesData = jsonData['recettes'];

      // Convertir chaque élément en une instance de Recette
      List<Recette> liste = recettesData.map((item) => Recette.fromJson(item)).toList();

      // Mettre à jour la liste dans l’état pour afficher les données
      setState(() {
        recettes = liste;
      });
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
    }
  }

  void _toggleFavori(Recette recette) async {
    //bool action; 
    print(Favoris.favoris.indexOf(recette)); 
    setState((){
      Favoris.ajoutRecette(recette); 
    });
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
                Recette recette = recettes[index];
                return Card(
                  elevation: 3, // Ombre pour un meilleur effet visuel
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(recette.nom, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("${recette.type} - ${recette.regime}" ),
                    leading: Image.asset(recette.image,
                      width: 50, // Ajuste la taille
                      height: 50,
                      fit: BoxFit.cover, // Évite la distorsion
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Favoris.favoris.contains(recette) ? Icons.favorite : Icons.favorite_border, // Icône rouge si favori
                        color: Favoris.favoris.contains(recette) ? Color(0xFFC97B63) : Colors.grey,
                      ),
                      onPressed: () => _toggleFavori(recette),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
