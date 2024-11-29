# Yes, No, Toaster
Venorrak

## Description

Ce jeu est un jeu de curling où, au lieu de lancer une pierre sur de la glace, on doit lancer des toasts sur du beurre afin de les faire arriver le plus près du centre de la cible. Ce jeu se joue à deux joueurs, chaque joueur lance leurs toasts à succession, ils en ont chacun trois. À chaque tour, avant de lancer la toast, le joueur doit décider de la direction et de la vitesse avec laquelle la toast sera lancée. Le terrain est parsemé de collectibles de beurre (accélération) et de confiture (ralentissement), il faut aussi faire attention à la pourriture pour ne pas perdre sa toast.

## Conception

### QTE (Quick Time Events) mini-jeu
![QTE demo](README/qte.mp4)

Après avoir choisi la quantité de puissance qu'il veut appliquer à la toast, le joueur doit jouer au mini-jeu pour déterminer l'incertitude de la puissance de son lancer. Le mini-jeu consiste à appuyer sur les bonnes touches (directions, A & B) au bon moment (vis-à-vis de leur cible correspondante). Ensuite, en fonction du nombre de qte réussis, le joueur se verra attribuer une incertitude à la puissance. Par exemple, dans le cas où le joueur manque 5 qte et que l'incertitude maximale est de 20%, l'incertitude sera de plus ou moins 10%.

#### Comment ?

Pour commencer, je crée le nombre de qte que je veux et lui donne un type aléatoire (4 directions, A ou B) et les places aux bonnes places correspondant à leur type. Quand tout est prêt, un qte apparaît et commence à descendre vers le bas à chaque 0,5 s.

À chaque boucle :
- Si tout les qte ont disparu, le jeu se termine, commence son animation et envoie un signal de fin à son "parent"
- Pour chaque qte :
    - s'il est dans la zone où il est valide d'appuyer sur le bon bouton, changer la couleur du qte au jaune
    - s'il est trop tard pour appuyer sur la bonne touche, afficher que le joueur a manqué le qte en allumant la cible en rouge
- Si un bouton a été appuyé:
    - Si le bouton était le bon et que le qte était dans une zone valide, ajouter 1 au compte de qte réussis
    - Montrer si le joueur a bien appuyé en illuminant la cible en rouge ou en vert

### Trace de beurre

![Trace de beurre demo](README/trace.mp4)

Quand une toast est lancée, elle laisse une trace de beurre derrière elle qui retrecit plus elle va loin. Quand la toast n'a plus de beurre, elle ralentit drastiquement. Quand la toast passe sur du beurre (collectible), cela rallonge la distance qu'elle peut parcourir avant de manquer de beurre.

#### Comment ?

Pour commencer, je crée le premier segment.

À chaque boucle :
- Si la toaste n'a plus de beurre et qu'elle n'a pas déjà été ralentie, on ralentit la toaste
- Si la toaste fait encore partie du jeu et qu'elle est à une certaine distance du dernier segment
    - créer un nouveau segment qui part du dernier vers la position de la toaste
    - donner des paramètres de base à la toaste
    - donner une largeur à la toaste en fonction de la longueur totale de la trace

Quand la trace reçoit le signal que la toaste est passée sur du beurre, elle rallonge la distance totale avant de ralentir

#### Pourquoi ?

##### Pourquoi ne pas juste créer une seule Line2d pour chaque toast au lieu d'une Line2d par segment ?

Avec une seule Line2d, la largeur est fixe à moins d'y ajouter une "curve". Dans le cas où cette "curve" est utilisée, nous pouvons seulement décider de la largeur de la trace en nous basant sur sa distance entre le point de départ et de fin de la ligne (0 à 1). Dans ce cas, si la trace devient plus longue, les segments déjà tracés deviendront de plus en plus minces. Je fus donc contraint d'utiliser une série de Line2d avec des largeurs différentes.