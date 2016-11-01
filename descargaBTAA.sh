#!/bin/bash
# 
# Descarga hojas de la Base Topográfica Armonizada de Aragón
# 
# Santiago Crespo 2016 WTFL http://www.wtfpl.net/txt/copying/

######## CONFIGURACIÓN ####################
# ¿Dónde quieres guardar el BTN25?
DIRECTORIO_BTAA=/home/`whoami`/BTAA
######## FIN DE LA CONFIGURACIÓN ##########


mkdir -p $DIRECTORIO_BTAA

echo "117;Ochagavía
118;Zuriza
143;Navascués
144;Ansó
145;Sallent
146;Bujaruelo
147;Liena
148;Busost
174;Sangüesa
175;Sigües
176;Jaca
177;Sabiñánigo
178;Broto
179;Bielsa
180;Benasque
207;Sos del Rey Católico
208;Uncastillo
209;Agüero
210;Yebra de Basa
211;Boltaña
212;Campo
213;Pont de Suert
245;Sádaba
246;Luna
247;Ayerbe
248;Apiés
249;Alquézar
250;Graus
251;Arén
281;Cervera del Río Alhama
282;Tudela
283;Fustiñana
284;Ejea de los Caballeros
285;Almudévar
286;Huesca
287;Barbastro
288;Fonz
289;Benabarre
319;Ágreda
320;Tarazona de Aragón
321;Tauste
322;Remolinos
323;Zuera
324;Grañén
325;Peralta de Alcofea
326;Monzón
327;Os de Balaguer
351;Olvega
352;Tabuenca
353;Pedrola
354;Alagón
355;Leciñena
356;Lanaja
357;Sariñena
358;Almacellas
359;Balaguer
380;Borobia
381;Illueca
382;Épila
383;Zaragoza
384;Fuentes de Ebro
385;Castejón de Monegros
386;Peñalba
387;Fraga
408;Torrijo de la Cañada
409;Calatayud
410;La Almunia de Doña Godina
411;Longares
412;Pina de Ebro
413;Gelsa
414;Bujaraloz
415;Mequinenza
436;Alhama de Aragón
437;Ateca
438;Paniza
439;Azuara
440;Belchite
441;Híjar
442;Caspe
443;Fabara
463;Milmarcos
464;Used
465;Daroca
466;Moyuela
467;Muniesa
468;Albalate del Arzobispo
469;Alcañiz
470;Gandesa
490;Odón
491;Calamocha
492;Segura de los Baños
493;Oliete
494;Calanda
495;Castelserás
496;Horte de Sant Joan
515;El Pobo de Dueñas
516;Monreal del Campo
517;Argente
518;Montalbán
519;Aguaviva
520;Peñarroya de Tastavins
521;Beceite
540;Checa
541;Santa Eulalia
542;Alfambra
543;Villarluengo
544;Forcall
565;Tragacete
566;Cella
567;Teruel
568;Alcalá de la Selva
569;Villafranca del Cid
588;Zafrilla
589;Terriente
590;La Puebla de Valverde
591;Mora de Rubielos
592;Villahermosa del Río
612;Ademuz
613;Camarena de la Sierra
614;Manzanera
638;Alpuente
639;Jérica" > /tmp/municipios.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo $line > /tmp/l
    NUMERO_MUNICIPIO=`awk -F ';' '{print $1}' /tmp/l`
    NOMBRE_MUNICIPIO=`awk -F ';' '{print $2}' /tmp/l | perl -pe 's/ /_/g'`
    echo "## Intentando descargar hojas de $NOMBRE_MUNICIPIO"

    for i in $(seq -f "%02g" 01 99)
    do
      mkdir -p $DIRECTORIO_BTAA/$NOMBRE_MUNICIPIO
      cd $DIRECTORIO_BTAA/$NOMBRE_MUNICIPIO
#      wget "http://idearagon.aragon.es/datosdescarga/descarga.php?file=BTA5/$NUMERO_MUNICIPIO/$NUMERO_MUNICIPIO$i.shp.zip" -O $NUMERO_MUNICIPIO$i.shp.zip && echo "DESCARGADO $NUMERO_MUNICIPIO$i.shp.zip en `pwd`"
#      if grep --quiet "no se ha publicado" $NUMERO_MUNICIPIO$i.shp.zip; then
#        rm $NUMERO_MUNICIPIO$i.shp.zip
        break
#      fi
    done
done < /tmp/municipios.txt

echo "## Borrando directorios vacíos..."
rmdir $DIRECTORIO_BTAA/* 2> /dev/null

echo "## Descomprimiendo..."
cd $DIRECTORIO_BTAA
for d in *; do cd $d && unzip -o \*zip && cd ..; done;

echo "## Borrando zips..."
rm */*zip && rmdir * 2> /dev/null ; echo "OK, FIN" && exit 0
