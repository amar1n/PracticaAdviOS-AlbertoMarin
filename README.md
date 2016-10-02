# PracticaAdviOS-AlbertoMarin

Cosas obligatorias que no se han desarrollado:

1. Versión iPad, a pesar de que si se desarrolló la gestión de almacenar y recordar el último libro leído
2. Mostrar las notaa en el mapa, a pesar de que si se desarrolló la parte de geolocaclización de la nota.
3. Evitar un pico de memoria al tomar una foto en la nota.

No se desarrolló ningún extra.

Cosas detectadas que fallan:

1. El cancelar la creación de una nota falla aleatoriamente. El error generado es el siguiente...

>Serious application error.  An exception was caught from the delegate of NSFetchedResultsController during a call to -controllerDidChangeContent:.  attempt to delete item 0 from section 0 which only contains 0 items before the update with userInfo (null)

