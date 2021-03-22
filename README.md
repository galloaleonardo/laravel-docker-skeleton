<img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="300"> <img src="https://www.mundodocker.com.br/wp-content/uploads/2015/06/docker_facebook_share.png" width="150">

##### Docker Compose Files
- docker-compose.prod.yml (Production)
- docker-compose.yml (Development)

---

##### Services

- Nginx + Redis
```bash
docker-compose up -d nginx
```

- Composer
```bash
docker-compose run --rm composer --version
```

- NPM
```bash
docker-compose run --rm npm -v
```

- Laravel Artisan
```bash
docker-compose run --rm artisan --version
```

- Laravel Scheduler
```bash
docker-compose run -d scheduler
```

- Laravel Horizon
```bash
docker-compose run -d horizon
```

- Laravel Echo Server
```bash
docker-compose run -d laravel-echo-server
```

---
##### Environment Usage

- Development
```bash
docker-compose up -d nginx
```

- Production
```bash
docker-compose -f docker-compose.prod.yml up -d nginx
```

---

##### Services information

- PHP:
    - Version 7.4.
    - SQL Server Drivers.
    - WkHTMLToPDF.
    - .INI Changes Option.
- Nginx:
    - Latest Version.
    - SSL/Certificate Configuration (Production).
- Composer:
    - Latest Version.
- NPM:
    - Version 13.7.
- Redis:
    - Latest Version.
    
