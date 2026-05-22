# Lab 6 - Fulltext

Skripty su v `6/sql/`, vystupy su v `6/outputs/`.

## Skripty

- `00_inspect.sql` - zakladna kontrola tabulky `contracts`
- `01_setup.sql` - fulltext konfiguracia, `tsvector` stlpec a indexy
- `02_search_oracle_socialna.sql` - fulltext vyhladavanie s boostom novsich zmluv
- `03_search_accent_case.sql` - kontrola case/accent insensitive vyhladavania
- `04_search_identifier.sql` - substring hladanie v contract code cez trigram index
- `05_search_supplier_ico.sql` - substring hladanie v ICO cez trigram index
- `06_limitations.sql` - jednoduche priklady limitacii

## 00 - Inspect

Tabulka `contracts` ma 475066 riadkov.

Pouzite stlpce:

- `name`
- `department`
- `customer`
- `supplier`
- `supplier_ico`
- `identifier`
- `published_on`

Stlpec `identifier` je contract code zo zadania.

## 01 - Setup

Skript `01_setup.sql` vytvoril:

- extension `unaccent`
- extension `pg_trgm`
- text search konfiguraciu `sk`
- stlpec `search_vector`
- GIN index nad `search_vector`
- trigram index nad `supplier_ico::text`
- trigram index nad `identifier::text`

Do `search_vector` sa ukladaju tieto textove polia:

- `name`
- `department`
- `customer`
- `supplier`

Vystup:

| Hodnota | Pocet |
| --- | ---: |
| zmluvy so `search_vector` | 475066 |

## 02 - Fulltext hladanie a boost novsich zmluv

Skript: `sql/02_search_oracle_socialna.sql`  
Vystup: `outputs/02_search_oracle_socialna.txt`

Dotaz hladal:

```text
oracle socialna poistovna
```

Nasli sa 2 vysledky. Prvy vysledok:

| id | name | supplier | published_on | text_rank | boosted_rank |
| ---: | --- | --- | --- | ---: | ---: |
| 101340 | Zmluva o poskytovaní štandardných služieb Oracle "Software Update License & Support" | Oracle Slovensko, spol. s r.o. | 2011-05-02 | 0.070000 | 0.070013 |

Boost je vypocitany ako fulltext rank nasobeny malou hodnotou podla staroby zmluvy. Novsie zmluvy teda dostanu mierne vyssi rank, ale stale rozhoduje hlavne fulltext zhoda.

## 03 - Case/accent insensitive hladanie

Skript: `sql/03_search_accent_case.sql`  
Vystup: `outputs/03_search_accent_case.txt`

Dotaz hladal bez diakritiky:

```text
socialna poistovna
```

Vo vysledkoch su zmluvy s textom `Sociálna poisťovňa`, cize vyhladavanie je case insensitive aj accent insensitive.

## 04 - Contract code

Skript: `sql/04_search_identifier.sql`  
Vystup: `outputs/04_search_identifier.txt`

Dotaz:

```sql
identifier::text ILIKE '%OIaMIS%'
```

Vysledok:

| Hodnota | Pocet |
| --- | ---: |
| najdene zmluvy | 3 |

Plan pouzil trigram index:

```text
Bitmap Index Scan on contracts_identifier_trgm_idx
```

Execution time bol 10.523 ms.

## 05 - Supplier ICO

Skript: `sql/05_search_supplier_ico.sql`  
Vystup: `outputs/05_search_supplier_ico.txt`

Dotaz:

```sql
supplier_ico::text ILIKE '%31364381%'
```

Vysledok:

| Hodnota | Pocet vo vystupe |
| --- | ---: |
| najdene zmluvy | 10 |

Plan pouzil trigram index:

```text
Bitmap Index Scan on contracts_supplier_ico_trgm_idx
```

Execution time bol 17.685 ms.

## 06 - Limitacie

Skript: `sql/06_limitations.sql`  
Vystup: `outputs/06_limitations.txt`

Priklad 1:

| Query | Pocet vysledkov |
| --- | ---: |
| `zmluva` | 265102 |

Slovo `zmluva` je v tychto datach prilis vseobecne. Fulltext ho sice najde, ale vysledkov je velmi vela a samotne slovo nema velku informacnu hodnotu. Riesenim by bolo pridat vlastny stopword slovnik alebo znizit vahu castych slov.

Priklad 2:

| Query | Pocet vysledkov |
| --- | ---: |
| `OIaMIS` cez fulltext | 0 |

Contract code sa nesprava ako bezny prirodzeny text. Preto ho neriesim cez fulltext, ale cez `ILIKE '%...%'` s trigram indexom.

## Zaver

Fulltext cast vyhladava v `name`, `department`, `customer` a `supplier`. Diakritika sa riesi cez `unaccent` a konfiguraciu `sk`. Novsie zmluvy su mierne boostnute vo vyslednom ranku.

Pre `supplier_ico` a `identifier` je vhodnejsi trigram index, pretoze zadanie vyzaduje hladanie podretazca hocikde vo vnutri hodnoty.
