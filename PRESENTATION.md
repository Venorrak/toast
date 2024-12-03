# Yes, No, Toaster
Par Justin Audet
## Presentation globale

C'est un jeu de curling de type arcade où la pierre est remplacée par une toast et la glace remplacée par du beurre. Le jeu se joue à deux joueurs et chaque joueur doit lancer 3 toasts chacun en essayant de les faire arriver le plus près de la cible. À chaque lancer, le joueur choisit la direction et la puissance avec laquelle il veut lancer sa toast. Aussi, après avoir choisi la puissance désirée, un mini-jeu se lance pour donner un malus d'incertitude au lancer du joueur. Plus une toast est proche du centre de la cible, moins elle accumule de points (comme au golf), le joueur avec le moins de points remporte la partie.

## Mecaniques

### Apparition de collectibles sur une grille
- Montrer le résultat de l'apparition du beurre, confiture et pourriture
- Montrer le grid.gd
- Montrer l'utilisation du script dans world.gd

### State Machine (game state)
- Décrire les différents états
- Mentionner le globalVars.gd

### QTE / mini-jeu / guitar-hero
- Demonstration
- Montrer qte.gd
    - qteObj.gd ?

### Camera
- Demonstration
- Mouvement de camera
- Tremblement de camera
    - regarder toast.gd rapidement ?
    - toast.gd -> world.gd -> camera.gd

### Camera secondaire
- Demonstration
- J'aime lerp
- vec2 == vec2 marche pas vraiment

### Trace de beurre
- Demonstration
- World.gd -> createTrail()
- Comment ça marche ?
- Parler de problème et solution pour changer la largeur de ligne


## Si on a le temps

### Ecran de fin (nouveau high score)
- Juste la montrer