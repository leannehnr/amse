import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;
  double factor; 

  Tile({required this.imageURL, required this.alignment, required this.factor});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: alignment,
            widthFactor: factor,
            heightFactor: factor,
            child: Image.network(imageURL),
          ),
        ),
      ),
    );
  }
}


class Taquin extends StatefulWidget {
  @override
  TaquinState createState() => TaquinState();
}

class TaquinState extends State<Taquin> {
  List<Tile> tiles = [];
  double size = 3; // Taille de la grille (doit rester en double)
  late int emptyTileIndex; // Stocke l'index de la case blanche

  @override
  void initState() {
    super.initState();
    _initializeTiles();
  }
/*
  void createGrid() {
    tiles.clear(); 
    setState(() {
      for (int i = 0; i < size.toInt(); i++) {
        for (int j = 0; j < size.toInt(); j++) {
          double alignX = (j / (size - 1)) * 2 - 1; // Entre -1 et 1
          double alignY = (i / (size - 1)) * 2 - 1;
          tiles.add(Tile(alignment: Alignment(alignX, alignY), factor: 1/size, color: Colors.blueGrey));
        }
      }
    });
  }
*/
  void _initializeTiles() {
    tiles.clear();
    for (int i = 0; i < size.toInt(); i++) {
      for (int j = 0; j < size.toInt(); j++) {
        double alignX = (j / (size - 1)) * 2 - 1;
        double alignY = (i / (size - 1)) * 2 - 1;
        tiles.add(Tile(imageURL: 'https://picsum.photos/512', alignment: Alignment(alignX, alignY), factor:(1/size)));
      }
    }
    emptyTileIndex = tiles.length - 1;
    tiles[emptyTileIndex] = Tile(imageURL: 'https://st3.depositphotos.com/13349494/18517/i/450/depositphotos_185170938-stock-photo-simple-light-gray-abstract-background.jpg', alignment: Alignment(1, 1), factor:(1/size));
  }

  Widget createTileWidgetFrom(Tile tile, int index) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () => _onTileTap(index),
    );
  }

  void _onTileTap(int tappedIndex) {
    int cols = size as int;
    int emptyRow = emptyTileIndex ~/ cols;
    int emptyCol = emptyTileIndex % cols;
    int tappedRow = tappedIndex ~/ cols;
    int tappedCol = tappedIndex % cols;

    if ((tappedRow == emptyRow && (tappedCol - emptyCol).abs() == 1) ||
        (tappedCol == emptyCol && (tappedRow - emptyRow).abs() == 1)) {
      swapTiles(emptyRow, emptyCol, tappedRow, tappedCol);
    }
  }

  void swapTiles(int i1, int j1, int i2, int j2) {
    int idx1 = (i1 * size + j1) as int;
    int idx2 = (i2 * size + j2) as int;

    setState(() {
      Tile tmp = tiles[idx1];
      tiles[idx1] = tiles[idx2];
      tiles[idx2] = tmp;
      emptyTileIndex = idx2; // Mise à jour de l'index de la case blanche
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving tile'),
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
                  width: 512 / size,
                  height: 512 / size,
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: createTileWidgetFrom(tiles[index], index),
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
                _initializeTiles(); 
              });
            },
          ),
        ],
      ),
    );
  }
}
