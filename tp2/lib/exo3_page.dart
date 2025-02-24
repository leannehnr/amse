import 'dart:math';

import 'package:flutter/material.dart';


class Exo3Page extends StatefulWidget {
  @override
  Exo3PageState createState() => Exo3PageState();
}

class Exo3PageState extends State<Exo3Page> {
  double currentvalueX = 0; 
  double currentvalueZ = 0; 
  bool checked = false; 
  double scale = 1; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exo 3"),
        centerTitle: true,
      ),
      body: Column(
        children: [
              Transform(alignment: Alignment.center,
              transform: Matrix4.identity()
              ..rotateX(currentvalueZ)
              ..rotateZ(currentvalueX)
              ..rotateY(checked == false ? 0 : pi)
              ..scale(scale), 
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
              Text("Mirror"), 
              Checkbox(value: checked, onChanged: 
              (bool? value) {setState(() {
                checked = !checked; 
              });}
              ),
              SizedBox(height: 15),
              Text("Scale"), 
              Slider(value: scale,
                min: 0,
                max: 10,
                onChanged: (value){
                setState(() {
                scale = value;
              });
            },),
        ],
      ), 
      
    );
  }
}