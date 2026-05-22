# Lab 3 - PostGIS

Skripty su v `3/sql/`, vystupy su v `3/outputs/`.

## Skripty

- `00_inspect.sql` - zakladna kontrola tabuliek, SRID a pouzitych objektov
- `01_fmfi_to_station.sql` - vzdialenost FMFI UK od hlavnej stanice
- `02_karlova_ves_neighbours.sql` - susedia Karlovej Vsi
- `03_danube_bridges.sql` - mosty cez Dunaj
- `04_dlhe_diely_streets.sql` - ulice v Dlhych dieloch
- `05_distance_vs_dwithin.sql` - rozdiel medzi `ST_Distance` a `ST_DWithin`
- `06_dlhe_diely_leisure_optional.sql` - optional leisure plocha
- `07_restaurants_near_danube_optional.sql` - optional restauracie pri Dunaji

## 00 - Inspect

OSM tabulky:

| Tabulka | Riadky | SRID |
| --- | ---: | ---: |
| `planet_osm_point` | 26462 | 4326 |
| `planet_osm_line` | 29566 | 4326 |
| `planet_osm_polygon` | 49606 | 4326 |
| `planet_osm_roads` | 2756 | 4326 |

SRID 4326 znamena, ze geometrie su v zemepisnych suradniciach. Pre vzdialenost v metroch som pouzil pretypovanie na `geography`.

## 01 - Vzdialenost FMFI UK od hlavnej stanice

Skript: `sql/01_fmfi_to_station.sql`  
Vystup: `outputs/01_fmfi_to_station.txt`

Pouzite objekty:

- `Fakulta matematiky, fyziky a informatiky Univerzity Komenského v Bratislave`
- `Bratislava hlavná stanica`

Vysledok:

| Vzdialenost | Hodnota |
| --- | ---: |
| vzdusna vzdialenost | 2769 m |

Dotaz pouziva `ST_Distance(fmfi.way::geography, station.way::geography)`, aby vysledok bol v metroch.

## 02 - Susedia Karlovej Vsi

Skript: `sql/02_karlova_ves_neighbours.sql`  
Vystup: `outputs/02_karlova_ves_neighbours.txt`

Pouzil som administrativne hranice s `admin_level = '9'` a priestorovy predikat `ST_Touches`.

Priami susedia:

- Bratislava - mestská časť Staré Mesto
- Devín
- Dúbravka

## 03 - Mosty cez Dunaj

Skript: `sql/03_danube_bridges.sql`  
Vystup: `outputs/03_danube_bridges.txt`

Pouzil som rieku z `planet_osm_line`, kde `waterway = 'river'` a nazov je `Dunaj` alebo `Donau - Dunaj`. Mosty su linie, kde `bridge IS NOT NULL`. Prienik som overil cez `ST_Intersects`.

Najdene mosty:

- Most Apollo
- Most Lafranconi
- Most SNP
- Petržalská električka - 1. časť
- Prístavný most

## 04 - Ulice v Dlhych dieloch

Skript: `sql/04_dlhe_diely_streets.sql`  
Vystup: `outputs/04_dlhe_diely_streets.txt`

Dotaz hlada linie s `highway IS NOT NULL`, ktore pretinaju polygon `Dlhé diely`.

Naslo sa 31 ulic:

Albína Brunovského, Beniakova, Blyskáčová, Cikkerova, Dlhé diely I, Dlhé diely II, Dlhé diely III, Ferdiša Kostku, Hany Meličkovej, Hlaváčikova, Iskerníková, Jamnického, Jána Stanislava, Kolískova, Komonicová, Kresánkova, Kuklovská, Ľudovíta Fullu, Majerníkova, Matejkova, Nad lúčkami, Nad Sihoťou, Na Kampárke, Pribišova, Stoklasová, Sumbalova, Svíbová, Tománkova, Veternicová, Vincenta Hložníka, Vyhliadka.

## 05 - `ST_Distance` vs `ST_DWithin`

Skript: `sql/05_distance_vs_dwithin.sql`  
Vystup: `outputs/05_distance_vs_dwithin.txt`

Porovnal som hladanie bodov pri hlavnej stanici do vzdialenosti `0.01` stupna. Tu nejde o metre, ale o jednoduche porovnanie planov nad geometriou.

| Predikat | Plan | Execution time |
| --- | --- | ---: |
| `ST_Distance(p.way, s.way) < 0.01` | `Seq Scan` | 45.187 ms |
| `ST_DWithin(p.way, s.way, 0.01)` | `Bitmap Index Scan` + `Bitmap Heap Scan` | 3.258 ms |

Rozdiel: `ST_Distance` najprv rata vzdialenost a az potom filtruje. `ST_DWithin` je napisany ako priestorovy predikat a vie pouzit GiST index `planet_osm_point_index`. Vo vystupe je vidiet `Index Cond: (way && st_expand(...))`.

## 06 - Optional: leisure plocha v Dlhych dieloch

Skript: `sql/06_dlhe_diely_leisure_optional.sql`  
Vystup: `outputs/06_dlhe_diely_leisure_optional.txt`

Vysledok:

| Plocha Dlhych dielov | Leisure plocha | Podiel |
| ---: | ---: | ---: |
| 1104276.88 m2 | 24811.38 m2 | 2.25 % |

Do leisure plochy som zaratal polygony, kde `leisure IS NOT NULL`, a pouzil som ich prienik s polygonom `Dlhé diely`.

## 07 - Optional: restauracie do 300 m od Dunaja

Skript: `sql/07_restaurants_near_danube_optional.sql`  
Vystup: `outputs/07_restaurants_near_danube_optional.txt`

Pouzil som restauracie z bodov aj polygonov, teda `planet_osm_point` aj `planet_osm_polygon`, kde `amenity = 'restaurant'`.

| Restauracia | Vzdialenost |
| --- | ---: |
| Krishna | 94 m |
| Tanker | 111 m |
| UFO | 160 m |
| Au Café | 170 m |
| Kolkovna River Park | 174 m |
| MS Danubius | 181 m |
| Auspic | 182 m |
| Leberfinger | 183 m |
| Il Gusto | 195 m |
| Francúzska reštaurácia | 199 m |
| Volej | 205 m |
| mercado | 209 m |
| primi | 217 m |
| Kolkovna Eurovea | 225 m |
| BeAbout | 235 m |
| Prazdroj | 261 m |
| Mýtny domček | 273 m |
| Portus restaurant | 278 m |

## Zaver

Lab 3 ukazal zakladne pouzitie PostGIS nad OSM datami: meranie vzdialenosti cez `geography`, hladanie susednych polygonov cez `ST_Touches`, prieniky cez `ST_Intersects` a efektivne hladanie objektov v okoli cez `ST_DWithin`.
