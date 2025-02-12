import 'package:get_storage/get_storage.dart';

import 'dart:convert';
import 'recette_model.dart'; 

class FavorisService {
  final GetStorage box = GetStorage();

  // Méthode pour charger les favoris depuis GetStorage
  Future<List<Recette>> chargerFavoris() async {
    try {
      // Lire les données depuis GetStorage
      List<dynamic>? favorisList = box.read<List<dynamic>>('favoris');

      if (favorisList == null || favorisList.isEmpty) {
        return [];
      }

      List<String> favorisListString = favorisList.map((item) => item.toString()).toList();

// Convertir chaque élément JSON en objet Recette
      List<Recette> recettes = favorisListString.map((item) {
        return Recette.fromJson(jsonDecode(item));
      }).toList();

      return recettes;
    } catch (e) {
      print("Erreur lors du chargement des favoris : $e");
      return [];
    }
  }

  // Méthode pour ajouter ou retirer un favori
  Future<void>ajouterFavoris(Recette recette) async {
    try {
      // Lire les favoris existants
      List<String> favorisList = box.read<List<String>>('favoris') ?? [];

      // Modifier l'état du favori dans l'objet Recette
      recette.favori = !recette.favori;

      // Convertir la recette en JSON
      String recetteJson = jsonEncode(recette.toJson());

      if (recette.favori) {
        // Ajouter la recette si elle est marquée comme favori
        favorisList.add(recetteJson);
      } else {
        // Retirer la recette si elle est retirée des favoris
        favorisList.removeWhere((item) => item == recetteJson);
      }

      // Sauvegarder la nouvelle liste de favoris dans GetStorage
      await box.write('favori', favorisList);

    } catch (e) {
      print("Erreur lors de l'ajout/retrait d'un favori : $e");

    }
  }
}