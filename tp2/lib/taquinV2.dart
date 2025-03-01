
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Tile {
  Image image;
  Alignment alignment;
  double factor;
  int id; 


  Tile({required this.image, required this.alignment, required this.factor, required this.id});

  Widget croppedImageTile() {
        return FittedBox(
        fit: BoxFit.fill,
        child: ClipRect(
            child: Container(
            child: Align(
                alignment: alignment,
                widthFactor: factor,
                heightFactor: factor,
                child: image,
            ),
            ),
        ),
        );
    }
  }


class Taquinv2 extends StatefulWidget {
  final String typeSelectionne;

  Taquinv2({required this.typeSelectionne});
  @override
  Taquinv2State createState() => Taquinv2State();
}

class Taquinv2State extends State<Taquinv2> {
    FocusNode _focusNode = FocusNode(); //affichage clavier
    List<Tile> tiles = [];
    double size = 3; // Taille de la grille
    late int emptyTileIndex; // Index de la case vide
    List<Tile> initTiles = [];
    int move = 0; // Nombre de mouvements pour mélanger (par défaut : 0)
    int nbCoups = 0;
    final TextEditingController _moveController = TextEditingController(); // Contrôleur pour le TextField
    final Random random = Random(); // Générateur aléatoire
    File? _image;
    final ImagePicker _picker = ImagePicker();


    @override
    void dispose() {
        _moveController.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    void _shuffleTiles(int moves) {
        int sizeInt = size.toInt();
        List<List<int>> directions = [
        [-1, 0], // Haut
        [1, 0], // Bas
        [0, -1], // Gauche
        [0, 1] // Droite
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
            filteredMoves = possibleMoves;
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
        int cmp = 1;
        nbCoups=0;
        Image image; 
        if(widget.typeSelectionne == "Aléatoire"){
            image=Image.network('https://picsum.photos/512');
        } else if (widget.typeSelectionne == "Photo" && _image != null) {
            image = Image.file(_image!);
        } else if (widget.typeSelectionne == "Image"){
            image = Image.asset('../assets/creme.jpg');
        }  else {
            image = Image.network('https://st4.depositphotos.com/5654532/25554/i/450/depositphotos_255540166-stock-illustration-snake-leather-white-paper-texture.jpg');
            print("ERREUR IMAGE NULLE");
        }
        for (int i = 0; i < size.toInt(); i++) {
        for (int j = 0; j < size.toInt(); j++) {
            double alignX = (j / (size - 1)) * 2 - 1;
            double alignY = (i / (size - 1)) * 2 - 1;
            tiles.add(Tile(
                image: image,
                alignment: Alignment(alignX, alignY),
                factor: (1 / size), id : cmp));
                cmp++; 
        }
        }
        emptyTileIndex = tiles.length - 1;
        tiles[emptyTileIndex] = Tile(
            image: Image.network('https://st4.depositphotos.com/5654532/25554/i/450/depositphotos_255540166-stock-illustration-snake-leather-white-paper-texture.jpg'),
            alignment: Alignment(1, 1),
            factor: (1 / size), id: (size*size).truncate());
        initTiles = tiles; 
        _shuffleTiles(move);
    }

    Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
        setState(() {
        _image = File(pickedFile.path);
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
        int cols = size as int;
        int emptyRow = emptyTileIndex ~/ cols;
        int emptyCol = emptyTileIndex % cols;
        int tappedRow = tappedIndex ~/ cols;
        int tappedCol = tappedIndex % cols;

        if ((tappedRow == emptyRow && (tappedCol - emptyCol).abs() == 1) ||
            (tappedCol == emptyCol && (tappedRow - emptyRow).abs() == 1)) {
        swapTiles(emptyRow, emptyCol, tappedRow, tappedCol);
        nbCoups+=1; 
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

    void _updateMove() {
        int? newMove = int.tryParse(_moveController.text);
        if (newMove != null && newMove > 0) {
        setState(() {
            move = newMove;
            _initializeTiles();
        });
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Entrez un nombre valide supérieur à 0")),
        );
        }
    }

    bool gagner(){
        if(nbCoups==0){
        return false; 
        }
        for (int i = 0; i < tiles.length; i++) {
        if (tiles[i].id != i + 1) { // Vérifie si chaque tuile est bien placée
            return false;
        }
        } 
        return true; 
    }

    @override
    Widget build(BuildContext context) {
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
                style : TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 30,), 
                ElevatedButton.icon(onPressed: (){
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
                        _focusNode.requestFocus(); // Force l'affichage du clavier --> ça ne s'affichera pas avec chrome, il suppose qu'on utilise un clavier physique
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
            if (widget.typeSelectionne == "Photo" && _image == null) 
            ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: Icon(Icons.camera),
                label: Text("Prendre une photo"),
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
            Text("Taille du taquin"),
            Slider(
                value: size,
                min: 3,
                max: 7,
                divisions: 4,
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

