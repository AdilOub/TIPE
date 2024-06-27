# TIPE
Un langage adapté à la création de jeu.

Ce projet ne contient que le compilateur écrit en OCaml d'un language personalisé
Voici la grammaire du langage:

```
E -> if C then E else E | while C do E done E | U; E | P(E) | I 
I -> entier avec un CAS basique (IA, IS, IT, IF)
C -> true | false | eq( E , E ) | nand( C , C )
```

Le but de ce language est d'être utiliser dans des fichiers de descriptions personalisé pour les jeux de plateaux.
