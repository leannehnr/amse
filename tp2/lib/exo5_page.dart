import 'package:flutter/material.dart';
import 'exo4_page.dart'; 

class Exo5Page extends StatefulWidget {
  const Exo5Page({super.key});

  @override
  Exo5PageState createState() => Exo5PageState();
}

class Exo5PageState extends State<Exo5Page> {
  List<Tile> tiles = []; 
  double size = 3;  // Le nombre de colonnes par défaut

  @override
  void initState(){
    tiles.clear(); 
    for (int i = 0; i < size.toInt(); i++) {
        for (int j = 0; j < size.toInt(); j++) {
          double alignX = (j / (size - 1)) * 2 - 1; // Entre -1 et 1
          double alignY = (i / (size - 1)) * 2 - 1;
          tiles.add(Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(alignX, alignY), factor:(1/size)));
        }
      }
  }

  void createGrid() {
    tiles.clear(); 
    setState(() {
      for (int i = 0; i < size.toInt(); i++) {
        for (int j = 0; j < size.toInt(); j++) {
          double alignX = (j / (size - 1)) * 2 - 1; // Entre -1 et 1
          double alignY = (i / (size - 1)) * 2 - 1;
          tiles.add(Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(alignX, alignY), factor: 1/size));
        }
      }
    });
  }
  
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
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.toInt(),
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 512/size,
                  height: 512/size,
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tiles[index]),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Text("Scale"), 
          Slider(
            value: size,
            min: 3,
            max: 7,
            onChanged: (value) {
              setState(() {
                size = value.roundToDouble();
                createGrid(); 
              });
            },
          ),
        ],
      ),
    );
  }
}
