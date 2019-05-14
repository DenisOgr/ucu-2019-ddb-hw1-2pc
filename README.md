## UCU-2019-DB-HW1-2PC
Для роботи з розподіленими (двофазними) транзакціями пропонується використовувати СКБД PostgreSQL(http://www.postgresql.org/download).
Для зручності роботи з СКБД PostgreSQL можна використовувати pgAdmin (http://www.pgadmin.org/) або аналогічний графічний додаток.

Для виконання розподіленої транзакції Вам необхідно реалізувати свій Менеджер (координатор) розподілених транзакцій (TM). TM відправлятиме СКБД команди SQL (або використовувати API для 2PC з якоїсь з бібліотек) за допомогою яких і буде здійснюватись керування розподіленої транзакцією, на основі протоколу двофазної фіксації (Two-PhaseCommit Protocol).

Install (using conda):

```{bash}

docker-compose up -d

```

To run (from host machine):
```{bash}
docker-compose exec app-2pc /app/services/app
```

To run from inside container
```{bash}
docker-compose exec app-2pc bash
```

Experiment:
```{bash}
root@63ef0d36917b:/app# ./services/app
User before transaction:  (1, 'Denys Porplenko', 100, None)
Book hotel
Book flight
Charge money (50$)
Commit
User after transaction:  (1, 'Denys Porplenko', 50, None)

root@63ef0d36917b:/app# ./services/app
User before transaction:  (1, 'Denys Porplenko', 50, None)
Book hotel
Book flight
Charge money (50$)
Commit
User after transaction:  (1, 'Denys Porplenko', 0, None)

root@63ef0d36917b:/app# ./services/app
User before transaction:  (1, 'Denys Porplenko', 0, None)
Book hotel
Book flight
new row for relation "account_table" violates check constraint "account_table_amount_check"
DETAIL:  Failing row contains (1, Denys Porplenko, -50, null).

Rollback
User after transaction:  (1, 'Denys Porplenko', 0, None)
root@63ef0d36917b:/app#

```