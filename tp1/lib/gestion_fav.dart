import 'dart:convert';
import 'recette_model.dart';

class Favoris {
  static List<Recette> favoris = []; 

  static void ajoutRecette(Recette enCours){
    print(Favoris.favoris.contains(enCours)); 
    if(Favoris.favoris.contains(enCours)){
      favoris.remove(enCours); 
    } else {
      favoris.add(enCours);
    }
  }
}