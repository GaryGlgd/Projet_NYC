
#Quel est l’aéroport de départ le plus emprunté ? Quelles sont les 10 destinations les plus (moins) prisées ? Quelle sont les 10 avions qui ont le plus (moins) décollé ? 

	SELECT origin, COUNT(origin) FROM flights
	GROUP BY origin
	ORDER BY COUNT(origin) DESC;
	# Tri les départs du plus emprunté au moins emprunté


	SELECT dest, COUNT(dest) FROM flights
	GROUP BY dest
	ORDER BY COUNT(dest) DESC
	LIMIT 10;
	# Tri les destinations les plus prisées. 

	SELECT dest, COUNT(dest) FROM flights
	GROUP BY dest
	ORDER BY COUNT(dest) 
	LIMIT 10;
	# Sans le DESC, ce sont les destinations les moins prisées

	SELECT tailnum, COUNT(tailnum) FROM flights
	GROUP BY tailnum
	ORDER BY COUNT(tailnum) 
	LIMIT 11;
	# Tri les avions qui ont le moins décollés. On met limit 11 car il prend en compte le NULL.

	SELECT tailnum, COUNT(tailnum) FROM flights
	GROUP BY tailnum
	ORDER BY COUNT(tailnum) DESC 
	LIMIT 10;
	# Tri les avions qui ont le plus décollés.


# Trouver combien chaque compagnie a desservi de destination ; combien chaque compagnie a desservie de destination par aéroport d’origine et réaliser les graphiques adéquats qui synthétise ces informations ? 


	# Tri combien chaque compagnie à desservi de destination.

	SELECT origin, carrier, COUNT(distinct dest) AS destinations_différentes FROM flights
	GROUP BY carrier
	ORDER BY COUNT(distinct dest) DESC;

	# Tri de combien chaque compagnie a desservie de destination par aeroport d'origine

	SELECT origin, carrier, COUNT(distinct dest) AS destinations_différentes FROM flights
	GROUP BY carrier
	ORDER BY origin;

	# Pour réaliser le graphique on va sur R



# Trier les vols suivant l’aéroport d’origine, la compagnie et la destination dans un ordre alphabétique croissant (en réalisant les jointures nécessaires pour indiquer les noms des explicites des aéroports) ? 

	SELECT origin, dep.name AS departure_airport, carrier, dest, arr.name AS arrival_airport
	FROM flights
	INNER JOIN airports AS dep
	ON origin = dep.faa
	INNER JOIN airports AS arr
	ON dest = arr.faa
	ORDER BY dep.name, arr.name
	LIMIT 10;


#Quelles sont les compagnies qui n'opèrent pas sur tous les aéroports d’origine ? Quelles sont les compagnies qui desservent l’ensemble de destinations ?
	
	

	SELECT COUNT(distinct origin), flights.carrier, airlines.name FROM flights
	INNER JOIN airlines
	ON flights.carrier = airlines.carrier
	GROUP BY flights.carrier
	HAVING COUNT(distinct origin) < 3
	ORDER BY airlines.name, COUNT(distinct origin);
	

	SELECT COUNT(distinct dest) AS nb_dest, flights.carrier, airlines.name FROM flights
	INNER JOIN airlines
	ON flights.carrier = airlines.carrier
	INNER JOIN airports
	ON flights.dest = airports.faa
	GROUP BY flights.carrier
	-- HAVING nb_dest = 105
	ORDER BY  nb_dest DESC, airlines.name;


	-- Mix des 2 requêtes

	SELECT COUNT(distinct origin) AS nb_origin, flights.carrier, airlines.name, COUNT(distinct dest) AS nb_dest  FROM flights
	INNER JOIN airlines
	ON flights.carrier = airlines.carrier
	INNER JOIN airports
	ON flights.dest = airports.faa
	GROUP BY flights.carrier
	-- HAVING nb_dest = 105
	ORDER BY  nb_dest DESC, airlines.name;
	
	


#Quelles sont les destinations qui sont exclusives à certaines compagnies (à certains aéroports) ?

	SELECT distinct dest, airports.name, COUNT(distinct flights.carrier) AS nb_dest, airlines.name FROM flights
	INNER JOIN airports
	ON flights.dest = airports.faa
	INNER JOIN airlines
	ON flights.carrier = airlines.carrier
	GROUP BY dest
	HAVING nb_dest = 1
	ORDER BY airlines.name, airports.name;




#Filtrer le vols pour trouver ceux exploités par United, American ou Delta ?

	SELECT COUNT(*) FROM flights
	WHERE carrier = 'UA' OR carrier = 'AA' OR carrier = 'DL'
	LIMIT 10;
	
	


#Trouver tous les vols ayant atterri à Houston (IAH ou HOU). Combien de vols partent de NYC airports vers Seattle (indice : 3913 vols), combien de compagnies desservent cette destination (indice : 5 compagnies) et combien d’avions “uniques” (indice : 936 avions) ? 


	SELECT * FROM flights
	WHERE dest = 'IAH' OR dest = 'HOU'
	LIMIT 10;

	SELECT COUNT(*) FROM flights
	WHERE dest = 'SEA';

	SELECT COUNT(distinct carrier) FROM flights
	WHERE dest = 'SEA';

	SELECT COUNT(distinct tailnum) FROM flights
	WHERE dest = 'SEA';
