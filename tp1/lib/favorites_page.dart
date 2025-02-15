import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tp1/gestion_fav.dart';
import 'gestion_fav.dart';
import 'recette_model.dart';

class FavorisPage extends StatefulWidget {
  @override
  FavorisPageState createState() => FavorisPageState();
}

class FavorisPageState extends State<FavorisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des Recettes Favoris")),
      body: Favoris.favoris.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader en attendant
          : ListView.builder(
              itemCount: Favoris.favoris.length,
              itemBuilder: (context, index) {
                final recette = Favoris.favoris[index];
                return Card(
                  child: ListTile(
                    title: Text(recette.nom),
                    leading: Image.asset(recette.image),
                    trailing: IconButton(
                      icon: Icon(
                        Favoris.favoris.contains(recette) ? Icons.favorite : Icons.favorite_border,
                        color: Favoris.favoris.contains(recette) ? Color(0xFFC97B63): Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          Favoris.ajoutRecette(recette);  // Retirer des favoris
                          Favoris.favoris; 
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
