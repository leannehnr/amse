import 'dart:convert';
import 'recette_model.dart';

class Favoris {
  static List<Recette> favoris = []; 

  static List<Recette> ajoutRecette(Recette enCours, bool action){
    if (action){
      favoris.add(enCours); 
    } else {
      favoris.remove(enCours); 
    }
    return favoris; 
  }
}