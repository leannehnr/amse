import 'package:flutter/material.dart';
import 'exo4_page.dart'; 

class Exo5Page extends StatefulWidget {
  @override
  Exo5PageState createState() => Exo5PageState();
}

class Exo5PageState extends State<Exo5Page> {
  List<Tile> tiles = []; 
  double size = 4;  // Le nombre de colonnes par défaut

  @override
  void initState(){
    tiles.clear(); 
    for (int i = -(size/2).toInt(); i < (size/2).toInt(); i++) {
      for(int j =-(size/2).toInt(); j < (size/2).toInt(); j++){
        tiles.add(Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(j.toDouble(), i.toDouble())));
      }
    }
    print(tiles.length);
  }

  /*void createGrid() {
    tiles.clear; 
    setState(() {
      for (int i = -(size/2).toInt(); i <= (size/2).toInt(); i++) {
        for(int j =-(size/2).toInt(); j <= (size/2).toInt(); j++){
          tiles.add(Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(j.toDouble(), i.toDouble())));
        }
      }
    });
    
    print(tiles.length); 
  }
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
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.toInt(),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
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
            min: 1,
            max: 10,
            onChanged: (value) {
              setState(() {
                size = value;
                initState(); 
              });
            },
          ),
        ],
      ),
    );
  }
}
