# humhub
HumHub in Docker container

Use the following docker-compose.yaml to run HumHub in Docker:
```yaml
version: '3.1'
services:
  humhub:
    image: adrianharabula/humhub:latest
    restart: always
    volumes:
      - "./humhub/www:/var/www/html"
    ports:
      - "80:80"
  humhub-queue:
    image: adrianharabula/humhub:latest
    command: bash -c "/usr/local/bin/php /var/www/html/protected/yii queue/listen"
    restart: always
    volumes:
      - "./humhub/www:/var/www/html"
  humhub-cron:
    image: adrianharabula/humhub:latest
    command: bash -c "cron -f"
    restart: always
    volumes:
      - "./humhub/www:/var/www/html"
  db:
    image: mariadb:10.2
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    volumes:
      - "./humhub/www/sql:/docker-entrypoint-initdb.d"
    environment:
      MYSQL_ROOT_PASSWORD: changeme
      MYSQL_DATABASE: humhubdb
```

When configuring HumHub for the first time, MYSQL HOST is `db`.

Additionally:
 * in `humhub/www` folder you need to put the [HumHub files](https://www.humhub.com/en/download) on first install
 * in `humhub/www/sql` if there is any mysqldump it will be automatically imported when stack is run
 
## Warning!
Database volume is not yet backed. It is wiped when stack is stopped with `docker-compose down`.
