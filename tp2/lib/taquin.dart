import 'package:flutter/material.dart';
import 'package:tp2/exo6_page.dart';

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
  double size = 3;          // Taille de la grille (doit rester en double)
  late int emptyTileIndex;  // Stocke l'index de la case blanche
  int move = 0;             // Nombre de mouvements pour mélanger

  void _shuffleTiles(int moves) {
    int sizeInt = size.toInt();
    List<List<int>> directions = [
      [-1, 0], // Haut
      [1, 0],  // Bas
      [0, -1], // Gauche
      [0, 1]   // Droite
    ];

    int prevRow = -1, prevCol = -1;

    for (int i = 0; i < moves; i++) {
      int emptyRow = emptyTileIndex ~/ sizeInt;
      int emptyCol = emptyTileIndex % sizeInt;

      // Déterminer les mouvements possibles
      List<List<int>> possibleMoves = directions.where((d) {
        int newRow = emptyRow + d[0];
        int newCol = emptyCol + d[1];
        return newRow >= 0 && newRow < sizeInt && newCol >= 0 && newCol < sizeInt;
      }).toList();

      // Éviter d'annuler le mouvement précédent
      List<List<int>> filteredMoves = possibleMoves.where((d) {
        int newRow = emptyRow + d[0];
        int newCol = emptyCol + d[1];
        return !(newRow == prevRow && newCol == prevCol);
      }).toList();

      if (filteredMoves.isEmpty) {
        filteredMoves = possibleMoves; // Si tous les mouvements annulent, on prend quand même un
      }

      var move = filteredMoves[random.nextInt(filteredMoves.length)];
      int newRow = emptyRow + move[0];
      int newCol = emptyCol + move[1];

      // Effectuer l'échange
      swapTiles(emptyRow, emptyCol, newRow, newCol);

      // Mettre à jour les positions
      prevRow = emptyRow;
      prevCol = emptyCol;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTiles();
  }

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
    tiles[emptyTileIndex] = Tile(imageURL: 'https://st4.depositphotos.com/5654532/25554/i/450/depositphotos_255540166-stock-illustration-snake-leather-white-paper-texture.jpg', alignment: Alignment(1, 1), factor:(1/size));
    _shuffleTiles(move); 
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
      emptyTileIndex = idx2; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taquin'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(children: [
            Text("Niveau de mélange : "),
            ElevatedButton( onPressed: () {
              setState(() {
                move = 5; 
                _initializeTiles();
              });
            }, 
            child: Text('5'),
            ), 
            ElevatedButton( onPressed: () {
              setState(() {
                move = 10; 
                _initializeTiles();
              });
            }, 
            child: Text('10'),
            ), 
            ElevatedButton( onPressed: () {
              setState(() {
                move = 15; 
                _initializeTiles();
              });
            }, 
            child: Text('15'),
            ), 
            ElevatedButton( onPressed: () {
              setState(() {
                move = 20; 
                _initializeTiles();
              });
            }, 
            child: Text('20'),
            )
          ],), 
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
