# TP2

Application jeu de taquin. 
Réalisé dans le cadre de l'UV AMSE à l'IMT Nord Europe, développée par Léanne HENRY. 

## Execution du code 
```bash
git clone https://github.com/leannehnr/amse.git
cd /amse/tp2
flutter clean
flutter pub get
flutter run
```

## Fonctionnalités
Navigation sur les différents exercices du TP. 
Taquin basique dans 'Taquin' qui permet de régler la taquin et le nombre de coups pour mélanger. 

Si l'application est testée sur téléphone, la partie 'Taquin 2' permet de choisir une image dans sa galerie ou de prendre une photo en plus d'utiliser une image aléatoire (ne fonctionne pas si pas sur un appareil réel). Dans le 'Taquin 2', on trouve également un compteur de coups restants jusqu'à la réussite du puzzle (chemin inverse du mélange et des mauvais coups effectués) et une aide qui permet d'afficher les identifiants des cases. 

En haut à gauche de la page d'accueil, on trouve un bouton setting permettant de mettre l'application en mode clair/sombre. 

## Améliorations potentielles
Affichage tablette: je ne comprends pas pourquoi l'image ne prend pas toute la tuile (ça marche pour certaines tablettes - idem pour le format paysage). 
Améliorer l'UX quand on change de téléphone. 
