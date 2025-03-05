import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Tile {
  Image image;
  Alignment alignment;
  double factor;
  int id;
  bool showNumbers;

  Tile(
      {required this.image,
      required this.alignment,
      required this.factor,
      required this.id,
      required this.showNumbers});

  Widget croppedImageTile() {
    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: factor,
              heightFactor: factor,
              child: image,
            ),
          ),
        ),
        if (showNumbers) // Affiche le numéro uniquement si showNumbers est true
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class Taquinv2 extends StatefulWidget {
  final String typeSelectionne;

  const Taquinv2({super.key, required this.typeSelectionne});
  @override
  Taquinv2State createState() => Taquinv2State();
}

class Taquinv2State extends State<Taquinv2> {
  bool _showNumbers = false;
  int nbMovesRest = 0;
  List<List<int>> moveHistory =
      []; // Liste des mouvements effectués pendant le mélange
  final FocusNode _focusNode = FocusNode(); //affichage clavier
  List<Tile> tiles = [];
  double size = 3; // Taille de la grille
  late int emptyTileIndex; // Index de la case vide
  List<Tile> initTiles = [];
  int move = 0; // Nombre de mouvements pour mélanger (par défaut : 0)
  int nbCoups = 0;
  final TextEditingController _moveController =
      TextEditingController(); // Contrôleur pour le TextField
  final Random random = Random(); // Générateur aléatoire
  File? _image;
  late Image image_alea;
  final ImagePicker _picker = ImagePicker();

  //directions possibles de mouvements
  List<List<int>> directions = [
    [-1, 0], // Haut
    [1, 0], // Bas
    [0, -1], // Gauche
    [0, 1] // Droite
  ];

  @override
  void dispose() {
    _moveController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _shuffleTiles(int moves) {
    int sizeInt = size.toInt();
    moveHistory.clear();
    nbMovesRest = 0;
    int prevRow = -1, prevCol = -1;

    for (int i = 0; i < moves; i++) {
      int emptyRow = emptyTileIndex ~/ sizeInt;
      int emptyCol = emptyTileIndex % sizeInt;

      // mouvements possibles
      List<List<int>> possibleMoves = directions.where((d) {
        int newRow = emptyRow + d[0];
        int newCol = emptyCol + d[1];
        return newRow >= 0 &&
            newRow < sizeInt &&
            newCol >= 0 &&
            newCol < sizeInt;
      }).toList();

      // Éviter d'annuler le mouvement d'avant
      List<List<int>> filteredMoves = possibleMoves.where((d) {
        int newRow = emptyRow + d[0];
        int newCol = emptyCol + d[1];
        return !(newRow == prevRow && newCol == prevCol);
      }).toList();

      if (filteredMoves.isEmpty) {
        filteredMoves = possibleMoves;
      }

      var move = filteredMoves[random.nextInt(filteredMoves.length)];
      int newRow = emptyRow + move[0];
      int newCol = emptyCol + move[1];
      moveHistory.add(move);

      swapTiles(emptyRow, emptyCol, newRow, newCol);

      // Mettre à jour les positions
      prevRow = emptyRow;
      prevCol = emptyCol;
    }
    print("Move history : $moveHistory");
  }

  @override
  void initState() {
    super.initState();
    _generateRandomImage();
    _initializeTiles();
  }

  void _generateRandomImage() {
    setState(() {
      image_alea = Image.network(
        'https://picsum.photos/512?random=${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  void _initializeTiles() {
    tiles.clear();
    int cmp = 1;
    nbCoups = 0;
    Image image;
    if (widget.typeSelectionne == "Aléatoire") {
      image = image_alea;
    } else if (widget.typeSelectionne == "Photo" && _image != null) {
      image = Image.file(_image!);
    } else if (widget.typeSelectionne == "Image" && _image != null) {
      image = Image.file(_image!);
    } else {
      image = Image.network('');
      print("ERREUR IMAGE NULLE");
    }
    for (int i = 0; i < size.toInt(); i++) {
      for (int j = 0; j < size.toInt(); j++) {
        double alignX = (j / (size - 1)) * 2 - 1;
        double alignY = (i / (size - 1)) * 2 - 1;
        tiles.add(Tile(
            image: image,
            alignment: Alignment(alignX, alignY),
            factor: (1 / size),
            id: cmp,
            showNumbers: _showNumbers));
        cmp++;
      }
    }
    emptyTileIndex = tiles.length - 1;
    tiles[emptyTileIndex] = Tile(
      image: Image.network(''),
      alignment: Alignment(1, 1),
      factor: (1 / size),
      id: (size * size).toInt(),
      showNumbers: _showNumbers,
    );
    initTiles = tiles;
    _shuffleTiles(move);
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _initializeTiles();
      });
    }
  }

  Future<void> _pickPhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _initializeTiles();
      });
    }
  }

  Widget createTileWidgetFrom(Tile tile, int index) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () => _onTileTap(index),
    );
  }

  void _onTileTap(int tappedIndex) {
    int cols = size.toInt();
    int emptyRow = (emptyTileIndex ~/ cols).toInt();
    int emptyCol = (emptyTileIndex % cols).toInt();
    int tappedRow = (tappedIndex ~/ cols).toInt();
    int tappedCol = (tappedIndex % cols).toInt();

    if ((tappedRow == emptyRow && (tappedCol - emptyCol).abs() == 1) ||
        (tappedCol == emptyCol && (tappedRow - emptyRow).abs() == 1)) {
      swapTiles(emptyRow, emptyCol, tappedRow, tappedCol);
      moveHistory.add([tappedRow - emptyRow, tappedCol - emptyCol]);
      nbCoups += 1;
      solver();
    }
  }

  void swapTiles(int i1, int j1, int i2, int j2) {
    int idx1 = (i1 * size + j1).toInt();
    int idx2 = (i2 * size + j2).toInt();

    setState(() {
      Tile tmp = tiles[idx1];
      tiles[idx1] = tiles[idx2];
      tiles[idx2] = tmp;
      emptyTileIndex = idx2;
    });
  }

  void _updateMove() {
    int? newMove = int.tryParse(_moveController.text);
    if (newMove != null && newMove > 0) {
      setState(() {
        move = newMove;
        _initializeTiles();
        solver();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entrez un nombre valide supérieur à 0")),
      );
    }
  }

  bool gagner() {
    if (nbCoups == 0) {
      return false;
    }
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].id != i + 1) {
        // Vérifie si chaque tuile est bien placée
        return false;
      }
    }
    return true;
  }

  int solver() {
    if (moveHistory.length == move && nbCoups == 0) {
      nbMovesRest = move;
      return nbMovesRest;
    } else {
      // si le dernier mouvement est le mouvement opposé de l'avant dernier mouvement
      if (moveHistory.length > 1 &&
          moveHistory[moveHistory.length - 1][0] ==
              -moveHistory[moveHistory.length - 2][0] &&
          moveHistory[moveHistory.length - 1][1] ==
              -moveHistory[moveHistory.length - 2][1]) {
        moveHistory.removeLast();
        moveHistory.removeLast();
        nbMovesRest = moveHistory.length;
        return nbMovesRest;
      }
      return nbMovesRest + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double tileSize = screenWidth / (size + 1);
    return Scaffold(
      appBar: AppBar(
        title: Text('Taquin'),
        centerTitle: true,
      ),
      body: gagner()
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vous avez gagné en $nbCoups coups",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        move = 0;
                        _initializeTiles();
                      });
                    },
                    label: Text("Recommencer"),
                    icon: Icon(Icons.refresh),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Text("Niveau de mélange : "),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode, // Ajout du FocusNode
                        controller: _moveController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nombre de coups",
                        ),
                        onTap: () {
                          _focusNode
                              .requestFocus(); // Force l'affichage du clavier --> ça ne s'affichera pas avec chrome, il suppose qu'on utilise un clavier physique
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _focusNode.unfocus(); // Ferme le clavier
                        _updateMove();
                      },
                      child: Text("Appliquer"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Afficher les numéros"),
                      Switch(
                        value: _showNumbers,
                        onChanged: (value) {
                          setState(() {
                            _showNumbers = value;
                            for (int i = 0; i < tiles.length; i++) {
                              tiles[i].showNumbers = value;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.typeSelectionne == "Photo")
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: Icon(Icons.camera),
                    label: Text("Prendre une photo"),
                  ),
                if (widget.typeSelectionne == "Image")
                  ElevatedButton.icon(
                    onPressed: _pickPhoto,
                    icon: Icon(Icons.camera),
                    label: Text("Choisir une photo"),
                  ),
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
                        width: screenWidth / size,
                        height: screenHeight / size,
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: createTileWidgetFrom(tiles[index], index),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Text("Nombre de coups avant la fin : $nbMovesRest"),
                SizedBox(height: 15),
                Text("Taille du taquin"),
                Slider(
                  value: size,
                  min: 2,
                  max: 7,
                  divisions: 5,
                  label: size.round().toString(),
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
