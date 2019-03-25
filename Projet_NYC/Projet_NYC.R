require(nycflights13)
library(readr)
library(magrittr)

#Convertir les fichiers rda en csv

#Dans flights et weather, la colonne time_hour est au format POSIXct, non lisible sur SQL.
#Il faut donc la transformer au format Char.

df_time_char <- flights %>% mutate(new_time_hour = as.character(flights$time_hour))
#View(df_time_char)

df_time_char$time_hour <- NULL
#View(df_time_char)
str(df_time_char)

flights_chr <- df_time_char %>% rename(time_hour = new_time_hour)
#View(flights_chr)
#tmp <- tempfile()
#write_csv(flights_chr, tmp, na = 'NULL')

#Même chose pour Weather

df_time_char <- weather %>% mutate(new_time_hour = as.character(weather$time_hour)) 
df_time_char$time_hour <- NULL
weather_chr <- df_time_char %>% rename(time_hour = new_time_hour)
#write_csv(weather_chr, tmp, na = 'NULL')

#On le fait pour les autres sans qu'il n'y ai besoin de faire de modification

#write_csv(airlines, tmp, na = 'NULL')
#write_csv(airports, tmp, na = 'NULL')
#write_csv(planes, tmp, na = 'NULL')

#Il faut ensuite aller chercher les fichiers dans le dossier temporaire,
#les traiter et les enregistrer au format csv lisible par SQL.

# On vient de convertir les fichiers rda en fichier csv

#On peut également faire une boucle:

mes_rda <- ls()
rep_cible <- "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Projet_NYC/"
paste0(rep_cible, "flights", ".csv")

#test
for (df in mes_rda) { print(paste0(rep_cible, df, ".csv")) }

#commande
for (df in mes_rda) { write_csv(get(df), paste0(rep_cible, df, '.csv'), na = 'NULL')}

#get permet d'enlever les quotes et de considérer df comme dataframe


#Pour transformer la colonne en factor (permeet de réduire la capacité du fichier)
planes$type <- factor(planes$type)
planes$manufacturer <- factor(planes$manufacturer)
planes$model <- factor(planes$model)
planes$engine <- factor(planes$engine)


# vérifier les clés primaires:
planes %>% count(tailnum) %>% 
  +     dplyr::filter(n > 1) %>% 
  +     nrow()
# Si = 0 alors tailnum est clé primaire de planes. Ici c 'est le cas.
airports %>% count(faa) %>% dplyr::filter(n > 1) %>% nrow() # = 0, donc faa PK de airports 
airlines %>% count(carrier) %>% dplyr::filter(n > 1) %>% nrow()  # = 0, donc carrier PK de airlines
weather_chr %>% count(year, month, day, hour, origin) %>% dplyr::filter(n > 1) %>% nrow() # = 0, donc weather_chr à une clé composite: year, month, day, hour, origin)
flights_chr %>% count(year, month, day, hour, flight, origin, dest, carrier) %>% dplyr::filter(n > 1) %>% nrow()
# = 0, year, month, day, hour, flight, origin, dest, carrier est une clé composite de flights_chr. tailnum ne rentre pas car il y a des valeur NA.

