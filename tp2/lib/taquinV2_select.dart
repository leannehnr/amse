import 'package:flutter/material.dart';
import 'taquinV2.dart'; 


class TaquinV2Select extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choisissez une image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectionButton(context, "Aléatoire", "Aléatoire"),
            _buildSelectionButton(context, "Image", "Image"),
            _buildSelectionButton(context, "Photo", "Photo"),
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
              builder: (context) => Taquinv2(typeSelectionne: type),
            ),
          );
        },
        child: Text(label),
      ),
    );
  }
}
