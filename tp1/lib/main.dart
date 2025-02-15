import 'package:flutter/material.dart';
import 'main_page.dart'; // Page d'accueil

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
    title: 'Gestion de recettes', 
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFD8C3A5)),),
    home: MainPage(),
    );
  }
}
