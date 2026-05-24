# Lab 9 - Elasticsearch

Skripty su v `9/src/`, query su v `9/queries/`, vystupy su v `9/outputs/`.

## Dataset

Pouzil som Palmer Penguins dataset.

Zdroj:

```text
https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv
```

Dataset obsahuje merania tucniakov z Palmer Archipelago. Polia su napriklad:

- `species`
- `island`
- `bill_length_mm`
- `bill_depth_mm`
- `flipper_length_mm`
- `body_mass_g`
- `sex`
- `year`

## Import

Elasticsearch kontajner:

```powershell
docker run -d --name db2-lab9-es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.9
```

Import cez Python:

```powershell
python src/import_penguins.py
```

Import vytvori index `penguins`, mapping a nahra dokumenty cez `_bulk` API.

Overeny import:

| Index | Pocet dokumentov |
| --- | ---: |
| `penguins` | 344 |

## Query 1 - textove hladanie

Subor:

```text
queries/01_search_text.json
```

Dotaz hlada text:

```text
Gentoo Biscoe
```

Pouziva `multi_match` nad polami:

- `species`
- `island`
- `description`

Vystup je v `outputs/01_search_text.txt`.

Vysledok:

| Hodnota | Vysledok |
| --- | ---: |
| pocet najdenych dokumentov | 168 |
| prvy druh vo vysledkoch | Gentoo |
| prvy ostrov vo vysledkoch | Biscoe |

## Query 2 - agregacia

Subor:

```text
queries/02_aggregation_species_body_mass.json
```

Agregacia zoskupi dokumenty podla druhu tucniaka a spocita:

- priemernu hmotnost
- priemernu dlzku plutvy

Vystup je v `outputs/02_aggregation_species_body_mass.txt`.

| Species | Pocet | Priemerna hmotnost | Priemerna dlzka plutvy |
| --- | ---: | ---: | ---: |
| Adelie | 152 | 3700.66 g | 189.95 mm |
| Gentoo | 124 | 5076.02 g | 217.19 mm |
| Chinstrap | 68 | 3733.09 g | 195.82 mm |

## Query 3 - doplnkova agregacia

Subor:

```text
queries/03_aggregation_islands.json
```

Agregacia spocita, kolko zaznamov je z kazdeho ostrova.

Vystup je v `outputs/03_aggregation_islands.txt`.

| Island | Pocet |
| --- | ---: |
| Biscoe | 168 |
| Dream | 124 |
| Torgersen | 52 |

## Zaver

Elasticsearch index `penguins` umoznuje textovo hladat v poliach ako `species` a `island`. Agregacie sa robia nad `keyword` alebo numerickymi poliami. V tomto labe je textove hladanie ukazane cez `multi_match` a agregacia cez `terms` + `avg`.
