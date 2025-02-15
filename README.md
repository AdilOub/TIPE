# TIPE
Un langage adapté à la création de jeu de plateau. 
Projet écrit dans le cadre du TIPE 2024

Ce projet contient le compilateur écrit en OCaml d'un language personalisé
Voici la grammaire du langage:

```
E -> if C then E else E | while C do E done E | get E| set E <- E ; E | I 
I -> entier avec un CAS basique (IA, IS, IT, IF)
C -> true | false | eq( E , E ) | nand( C , C )
```

Le but de ce language est d'être utilisé dans des fichiers de descriptions personalisés pour les jeux de plateaux.
Un jeu de plateau est entièrement déterminé par:
- Un ensemble de configuration Plateau qui peut être reprenster par un ensemble de tableau 2D
- Un ensemble de joueur Joueurs qui peut être representé par une ensemble d'eniter
- Un type 'Coups' qui represente l'ensemble des coups que les joueurs peuvent donner en entré
- une fonction 'est_legal': Coups -> {0,1}
- une fonction 'jouer_coup': Coups, Plateaux -> Plateaux
- une fonction 'joueur_suivant': Joueurs, Plateau -> Joueurs

  Ainsi si l'utilisateur écrit les fonctions 'est_legal', 'jouer_coup' et 'joueur_suivant', on peut automatiquement générer l'entièreté du code pour l'execution d'une partie.
  Pour faire écrire à l'utilisateur ces fonctions, qui sont généralement assez simples, on utilisera notre langage personalisé.

  
