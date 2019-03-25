COMMANDE SQL QUESTION

Quel est l’aéroport de départ le plus emprunté ? Quelles sont les 10 destinations les plus (moins) prisées ? Quelle sont les 10 avions qui ont le plus (moins) décollé ? 

	SELECT MAX(origin) FROM flights
	GROUP BY origin;

	SELECT MAX(dest) FROM flights
	GROUP BY dest
	LIMIT 10;

	SELECT MIN(dest) FROM flights
	GROUP BY dest
	LIMIT 10;

	SELECT MAX(tailnum) FROM flights
	GROUP BY tailnum
	LIMIT 10;