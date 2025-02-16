import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recette_model.dart';
import 'recette_page.dart';
import 'gestion_fav.dart'; 

class HomePage extends StatefulWidget {  // 🔥 Remplace ici par le vrai nom de ta page d'accueil
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Recette> recettes = [];
  List<Recette> recettesAleatoires = [];

  @override
  void initState() {
    super.initState();
    _chargerRecettes();
  }

  Future<void> _chargerRecettes() async {
    try {
      String jsonString = await rootBundle.loadString('assets/recettes.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      if (!jsonData.containsKey('recettes')) {
        print('Erreur : Clé "recettes" introuvable dans le JSON');
        return;
      }

      List<dynamic> recettesData = jsonData['recettes'];
      List<Recette> liste = recettesData.map((item) => Recette.fromJson(item)).toList();

      setState(() {
        recettes = liste;
        _choisirRecettesAleatoires();
      });
    } catch (e) {
      print('Erreur lors du chargement des recettes : $e');
    }
  }

  void _toggleFavori(Recette recette) async {
    print(Favoris.favoris.indexOf(recette)); 
    setState((){
      Favoris.ajoutRecette(recette); 
    });
  }

  void _choisirRecettesAleatoires() {
    if (recettes.isNotEmpty) {
      recettes.shuffle(); // Mélange la liste des recettes
      setState(() {
        recettesAleatoires = recettes.take(5).toList(); // Prend les 5 premières après mélange
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil des Recettes")),
      body: SingleChildScrollView(  // 🔥 Permet le défilement vertical
        child: Column(
          children: [
            // 🔥 Liste verticale des recettes aléatoires
            recettesAleatoires.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: recettesAleatoires.map((recette) => _buildRecetteCard(recette)).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  // 🔥 Carte pour afficher une recette (PLEINE LARGEUR)
  Widget _buildRecetteCard(Recette recette) {
    return GestureDetector(
      onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecetteDetailPage(recette: recette),
                        ),
                      );
                    },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5), // Marge autour de la carte
        elevation: 3,
        child: Container(
          width: double.infinity, // 🔥 Fait la largeur complète de l'écran
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                recette.image,
                width: double.infinity, // 🔥 Largeur complète
                height: 200, // Taille fixe
                fit: BoxFit.cover, // Ajuste bien l'image
              ),
              SizedBox(height: 10),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🔥 Espace entre le texte et l'icône
              children: [
                Expanded(
                  child: Text(
                    recette.nom,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // 🔥 Coupe le texte si trop long
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Favoris.favoris.contains(recette) ? Icons.favorite : Icons.favorite_border, // Icône rouge si favori
                    color: Favoris.favoris.contains(recette) ? Color(0xFFC97B63) : Colors.grey,
                  ),
                  onPressed: () => _toggleFavori(recette),
                ),
              ],
            ),
              Text("Type : ${recette.type}"),
              Text("Régime : ${recette.regime}"),
              Text("Prépa : ${recette.tempsPreparation}"),
              Text("Cuisson : ${recette.tempsCuisson}"),
            ],
          ),
        ),
        
      ),
    );
  }
}
