import 'dart:math';

import 'package:flutter/material.dart';


class Exo2Page extends StatefulWidget {
  @override
  Exo2PageState createState() => Exo2PageState();
}

class Exo2PageState extends State<Exo2Page> {
  double currentvalueX = 0; 
  double currentvalueZ = 0; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exo 2"),
        centerTitle: true,
      ),
      body: Column(
        children: [
              Transform(alignment: Alignment.center,
              transform: Matrix4.identity()
              ..rotateX(currentvalueZ)
              ..rotateZ(currentvalueX), 
              child: Image(image: NetworkImage("https://picsum.photos/1024/512"))),
              SizedBox(height: 15),
              Text("Rotation x"), 
              Slider(value: currentvalueX,
                max: 2*pi,
                onChanged: (value){
                setState(() {
                currentvalueX = value;
              });
            },),
              Text("Rotation z"), 
                Slider(value: currentvalueZ,
                  max: 2*pi,
                  onChanged: (value){
                  setState(() {
                  currentvalueZ = value;
                });
              },),
        ],
      ), 
      
    );
  }
}