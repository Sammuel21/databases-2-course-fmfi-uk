# Lab 5 - Recursive SQL

Skripty su v `5/sql/`, vystupy su v `5/outputs/`.

## Skripty

- `00_inspect.sql` - zakladna kontrola tabuliek
- `01_factorial.sql` - faktorial cisel od 0 po 10
- `02_fibonacci.sql` - prvych 20 Fibonacciho cisel podla zadania
- `03_chair_parts.sql` - komponenty potrebne na zostavenie `chair`
- `04_line39_zochova_to_zoo.sql` - zastavky medzi `Zochova` a `Zoo` na linke 39

## 00 - Inspect

Databaza `pdt` obsahuje tri hlavne tabulky:

- `product_parts`
- `stops`
- `connections`

Pre produkty sa pouziva stromova struktura cez `part_of_id`. Pre MHD je kazde spojenie ulozene ako hrana medzi dvoma zastavkami.

## 01 - Faktorial

Skript: `sql/01_factorial.sql`  
Vystup: `outputs/01_factorial.txt`

Vysledok:

| n | factorial |
| ---: | ---: |
| 0 | 1 |
| 1 | 1 |
| 2 | 2 |
| 3 | 6 |
| 4 | 24 |
| 5 | 120 |
| 6 | 720 |
| 7 | 5040 |
| 8 | 40320 |
| 9 | 362880 |
| 10 | 3628800 |

Rekurzia zacina na `0! = 1` a v kazdom kroku vynasobi predchadzajucu hodnotu dalsim cislom.

## 02 - Fibonacci

Skript: `sql/02_fibonacci.sql`  
Vystup: `outputs/02_fibonacci.txt`

Zadanie berie postupnost ako `1, 2, 3, 5, 8, ...`, teda prve dve hodnoty su 1 a 2.

| position | fibonacci |
| ---: | ---: |
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 5 |
| 5 | 8 |
| 6 | 13 |
| 7 | 21 |
| 8 | 34 |
| 9 | 55 |
| 10 | 89 |
| 11 | 144 |
| 12 | 233 |
| 13 | 377 |
| 14 | 610 |
| 15 | 987 |
| 16 | 1597 |
| 17 | 2584 |
| 18 | 4181 |
| 19 | 6765 |
| 20 | 10946 |

## 03 - Komponenty pre `chair`

Skript: `sql/03_chair_parts.sql`  
Vystup: `outputs/03_chair_parts.txt`

Komponenty potrebne na zostavenie `chair`:

- armrest
- cushions
- red dye
- cotton
- metal leg
- metal rod

Dotaz ide rekurzivne z produktu `chair` na jeho casti a potom na casti tychto casti.

## 04 - Linka 39 zo `Zochova` na `Zoo`

Skript: `sql/04_line39_zochova_to_zoo.sql`  
Vystup: `outputs/04_line39_zochova_to_zoo.txt`

Zastavky medzi `Zochova` a `Zoo`:

| name | hop |
| --- | ---: |
| Chatam Sófer | 1 |
| Park kultúry | 2 |
| Lafranconi | 3 |

V datach je linka 39 ulozena v smere `Zoo -> Zochova`, preto dotaz postupuje po spojeniach opacnym smerom.

## Zaver

Lab 5 ukazal pouzitie `WITH RECURSIVE` na dva typy problemov: vypocet postupnosti a prechadzanie grafu alebo stromu. Faktorial a Fibonacci su jednoduche rekurzivne vypocty. `product_parts` je strom komponentov a `connections` je graf zastavok.
