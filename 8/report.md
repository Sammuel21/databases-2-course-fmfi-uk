# Lab 8 - Redis

Skripty su v `8/src/`.

## Setup

Redis kontajner:

```powershell
docker run -d --name db2-lab8-redis -p 6379:6379 redis
```

Python dependency:

```powershell
python -m pip install -r requirements.txt
```

## Producer

Producer vklada joby do Redis listu `jobs`.

```powershell
python src/producer.py --count 5
```

## Polling consumer

Polling consumer pravidelne skusa `RPOP`.

```powershell
python src/consumer_polling.py --limit 5
```

Nevyhoda: ked je queue prazdna, consumer stale opakuje dotaz a musi cakat cez `sleep`.

## Blocking consumer

Blocking consumer pouziva `BRPOP`.

```powershell
python src/consumer_blocking.py --limit 5
```

Vyhoda: consumer necaka aktivnym pollingom. Redis ho zobudi az ked pride sprava alebo ked vyprsi timeout.

## Simulacia zlyhania

Jednoduchy `RPOP` alebo `BRPOP` job z queue hned odstrani. Ak consumer spadne po vytiahnuti jobu, ale pred spracovanim, sprava je stratena.

Reliable varianta pouziva `BRPOPLPUSH`. Job sa najprv presunie z `jobs` do `jobs:processing`. Po spracovani sa odstrani cez `LREM`.

```powershell
python src/producer.py --count 1
python src/consumer_reliable.py --fail-after-pop
python src/recover_processing.py
python src/consumer_reliable.py --limit 1
```

Po simulovanom pade job ostane v `jobs:processing`. Recovery skript ho presunie spat do `jobs`.

## Zaver

Redis list vie sluzit ako jednoducha queue. Pre jednoduche pripady staci `LPUSH` + `BRPOP`. Ak nechceme stratit job pri pade consumera, je lepsie pouzit reliable queue vzor s processing listom, napriklad `BRPOPLPUSH` + `LREM`.
