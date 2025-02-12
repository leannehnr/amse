import 'dart:convert';

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
  bool favori;

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
    required this.favori,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'type' : type, 
      'regime' : regime, 
      'tempsPreparation' : tempsPreparation,
      'tempsCuisson' : tempsCuisson, 
      'ingredients' : ingredients, 
      'etapes' : etapes,
      'imagePath': image,
      'favori': favori,
    };
  }
  factory Recette.fromJson(Map<String, dynamic> json) {
    return Recette(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      regime: json['regime'],
      tempsPreparation: json['temps_preparation'],
      tempsCuisson: json['temps_cuisson'],
      ingredients: List<String>.from(json['ingredients']),
      etapes: List<String>.from(json['etapes']),
      image: json['image'],
      favori: json['favori'],
    );
  }
}