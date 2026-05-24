# Databases (2)

Laby obsahuju nasledovnu strukturu:

```text
lab/
  sql/        SQL skripty
  outputs/    výstupy zo spustenia
  report.md   krátky report
```

Vzhľadom nato že som pracoval cez CLI tools tak jednotlive runy SQL skriptov su rozdelene tak aby sa dali spuštať samostatne s menšími modifikáciami, každý sql sript má ku sebe korešpondujúci output daní indexom prefixu.

napr.

```
01_skript.sql -> 01_output.txt
```


Pri písaní jednotlivých reportov som si pomohol s GPT modelmi pri parsovaní outputov, tvorbe tabuliek a formulovaní niektorých častí reportov.