import 'package:flutter/material.dart';
import 'exo4_page.dart'; 

class Exo5Page extends StatefulWidget {
  @override
  Exo5PageState createState() => Exo5PageState();
}

class Exo5PageState extends State<Exo5Page> {
  List<Tile> tile = []; 
  double size = 1; 
  /*
  Tile tile1 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(-1, -1));
  Tile tile2 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(0, -1));
  Tile tile3 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(1, -1));
  Tile tile4 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(-1, 0));
  Tile tile5 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(0, 0));
  Tile tile6 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(1, 0));
  Tile tile7 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(-1, 1));
  Tile tile8 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(0, 1));
  Tile tile9 = Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(1, 1));  
  */
  
  Widget createTileWidgetFrom(Tile tile) {
  
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exo 5'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GridView.count(crossAxisCount: size.toInt(), 
          children: <Widget>[
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile1))), 
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile2))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile3))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile4))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile5))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile6))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile7))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile8))),
            SizedBox(
                width: 128.0,
                height: 128.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tile9))),
          ],),
          SizedBox(height: 15),
      Text("Scale"), 
      Slider(value: size,
        min: 1,
        max: 10,
        onChanged: (value){
          setState(() {
            size = value;
            });
        },),
        ],
      ),
      
    ); 
  }
}

  
