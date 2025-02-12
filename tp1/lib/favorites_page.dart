import 'dart:convert';
import 'package:flutter/material.dart';
import 'recette_model.dart';

class FavorisPage extends StatefulWidget {
  final List<Recette> favoris;  // Recevoir la liste des favoris

  // Constructeur
  FavorisPage({Key? key, required this.favoris}) : super(key: key);

  @override
  FavorisPageState createState() => FavorisPageState();
}

class FavorisPageState extends State<FavorisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des Recettes Favoris")),
      body: widget.favoris.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader en attendant
          : ListView.builder(
              itemCount: widget.favoris.length,
              itemBuilder: (context, index) {
                final recette = widget.favoris[index];
                return Card(
                  child: ListTile(
                    title: Text(recette.nom),
                    leading: Image.asset(recette.image),
                    trailing: IconButton(
                      icon: Icon(
                        recette.favori ? Icons.favorite : Icons.favorite_border,
                        color: recette.favori ? Color(0xFFC97B63): Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          recette.favori = !recette.favori;
                          if (!recette.favori) {
                            widget.favoris.remove(recette);  // Retirer des favoris
                          }
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
