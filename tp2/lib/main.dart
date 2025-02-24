import 'package:flutter/material.dart';
import 'main_page.dart'; // Page d'accueil

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(debugShowCheckedModeBanner: false,
    title: 'Taquin', 
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0x00000000)),),
    home: MainPage(),
    );
  }
}