# Lab 7 - ACID

Skripty su v `7/bench/`, vystupy su v `7/outputs/`.

## Ciel

Porovnat rychlost INSERT operacii v PostgreSQL:

- so standardnym nastavenim `synchronous_commit`
- s `synchronous_commit=off`

Ako benchmark som pouzil `pgbench` s vlastnym INSERT skriptom.

## Benchmark

Benchmark vklada riadky do tabulky `documents`:

```sql
INSERT INTO documents(name, type, created_at, department, contracted_amount)
VALUES (...);
```

Spustenie benchmarku:

```powershell
docker exec db2-lab7-sync pgbench -U postgres -n -T 10 -f /tmp/insert.sql oz
docker exec db2-lab7-async pgbench -U postgres -n -T 10 -f /tmp/insert.sql oz
```

## Vysledky

| Nastavenie | Kontajner | Transactions | TPS |
| --- | --- | ---: | ---: |
| default `synchronous_commit` | `db2-lab7-sync` | 12157 | 1215.93 |
| `synchronous_commit=off` | `db2-lab7-async` | 84489 | 8451.15 |

TPS je hodnota `excluding connections establishing`, teda bez casu na vytvorenie spojenia.

## Zaver

Po vypnuti `synchronous_commit` bol INSERT benchmark priblizne 6.95x rychlejsi.

Vysvetlenie: pri zapnutom `synchronous_commit` PostgreSQL pri commite caka, kym sa WAL zapis potvrdi na disk. Pri `synchronous_commit=off` commit nemusi cakat na fyzicke potvrdenie zapisu, preto je rychlejsi. Cena za to je nizsia odolnost voci padu systemu: pri havarii sa mozu stratit nedavno potvrdene transakcie.
