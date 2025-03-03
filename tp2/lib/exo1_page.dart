import 'package:flutter/material.dart';


class Exo1Page extends StatefulWidget {
  const Exo1Page({super.key});

  @override
  Exo1PageState createState() => Exo1PageState();
}

class Exo1PageState extends State<Exo1Page> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exo 1"),
        centerTitle: true,
      ),
      body: Image(image: NetworkImage("https://picsum.photos/1024/512")), // Affiche la page sélectionnée
    );
  }
}