import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'recette_model.dart';


Future<List<Recette>> loadRecettes() async {
  final String response = await rootBundle.loadString('assets/recettes.json');
  final data = json.decode(response);
  List<dynamic> recettesJson = data["recettes"];
  return recettesJson.map((json) => Recette.fromJson(json)).toList();
}

// Passer en stateful pour pouvoir intéragir avec les recettes ??
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Text("Page Générateur de Recettes", style: TextStyle(fontSize: 20)),
    );
  }
}
