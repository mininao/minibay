# minibay
Databases 101 Assignment

## Initilatisation de la bdd
Les scripts à lancer (avec sqlplus par exemple) pour initialier la bdd sont dans l'ordre :

1. init.sql
2. user_logic.sql
3. money_logic.sql
4. auction_logic.sql
5. users.sql

## Tests

Vous pouvez éxécuter une série de tests quasi-exhaustifs en lançant le script `tester.sql`  
Attention : il modifie la base et ne doit être lancé qu'après une initialisation

## MCD
Les contraintes "NOT NULL" ne sont pas à jour dans le fichier minibay.mcd  
Vous pouvez les voir ici : https://github.com/mininao/minibay/blob/dba/init.sql#L50
