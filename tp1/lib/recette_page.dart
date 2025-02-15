import 'package:flutter/material.dart';
import 'recette_model.dart';


class RecetteDetailPage extends StatefulWidget {
  final Recette recette;

  RecetteDetailPage({required this.recette});

  @override
  RecetteDetailPageState createState() => RecetteDetailPageState();
}

class RecetteDetailPageState extends State<RecetteDetailPage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recette.nom),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.recette.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.recette.nom,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.orange),
                  SizedBox(width: 5),
                  Text(
                    "Type: ${widget.recette.type}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.health_and_safety, color: Colors.green),
                  SizedBox(width: 5),
                  Text(
                    "Régime: ${widget.recette.regime}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Ingrédients",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ...widget.recette.ingredients.map((ingredient) => Text("• $ingredient")).toList(),
              SizedBox(height: 20),
              Text(
                "Préparation",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ...widget.recette.etapes.map((etapes) => Text("• $etapes")).toList(),  
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
