import 'package:flutter/material.dart';
import 'dico_page.dart'; 


class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choisissez un type de recette")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectionButton(context, "Entrée", "Entrée"),
            _buildSelectionButton(context, "Plat", "Plat"),
            _buildSelectionButton(context, "Dessert", "Dessert"),
            _buildSelectionButton(context, "Tous", "All"),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String label, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GeneratorPage(typeSelectionne: type),
            ),
          );
        },
        child: Text(label),
      ),
    );
  }
}
