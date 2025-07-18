# Домашнее задание №6: Проектирование базы данных для кинотеатра

Этот проект реализует систему управления кинотеатром на базе PostgreSQL с администрированием через pgAdmin и полностью автоматизирован через Docker Compose.

---

## 🎯 Цели проекта

* Спроектировать реляционную базу данных для кинотеатра
* Освоить построение логической модели и реализацию схемы на SQL (DDL)
* Закрепить навыки нормализации и документирования связей
* Освоить развертывание среды через Docker и Makefile

---

## 📋 Описание системы

Система поддерживает:

* Управление несколькими залами с индивидуальными схемами мест
* Управление расписанием сеансов и продажей билетов на конкретные места
* Гибкое ценообразование (цена зависит от места, времени, типа билета)

---

## 🏗️ Структура проекта

```
otus-php-hw06/
├── docker-compose.yml              # Базовая конфигурация Docker
├── docker-compose.dev.yml          # Настройки для разработки
├── docker-compose.prod.yml         # Настройки для продакшена
├── Makefile                        # Автоматизация команд
├── ddl/
│   ├── schema.sql                  # Схема таблиц
│   └── seed.sql                    # Тестовые данные
├── env/
│   ├── .env.dev.example            # Пример переменных для dev
│   └── .env.prod.example           # Пример переменных для prod
├── doc/
│   └── cinema_schema.md            # Описание модели
└── queries/
    └── most_profitable_movie.sql   # Запрос на прибыльный фильм
```

---

## 🚀 Быстрый старт

### Предварительные требования

* [Docker](https://www.docker.com/) 20.10+
* [Docker Compose](https://docs.docker.com/compose/) 2.0+
* Make (опционально)

### Установка и запуск

1. Клонируйте репозиторий:

   ```bash
   git clone <repo-url>
   cd otus-php-hw06
   ```
2. Настройте переменные окружения:

   ```bash
   # Для разработки
   cp env/.env.dev.example env/.env.dev
   # Для продакшена
   cp env/.env.prod.example env/.env.prod
   ```
3. Запустите окружение разработки:

   ```bash
   make up
   ```
4. Проверьте доступность:

    * PostgreSQL: localhost:5432
    * pgAdmin: [http://localhost:8080](http://localhost:8080)

---

## 🛠️ Управление окружением

### Основные команды

| Команда        | Описание                    |
|----------------|-----------------------------|
| `make up`      | Запуск окружения разработки |
| `make down`    | Остановка окружения         |
| `make logs`    | Просмотр логов              |
| `make ps`      | Статус контейнеров          |
| `make clean`   | Очистка volume (сброс БД)   |
| `make rebuild` | Полная пересборка окружения |

### Продакшен-режим

| Команда            | Описание                           |
|--------------------|------------------------------------|
| `make prod-up`     | Запуск окружения для продакшена    |
| `make prod-down`   | Остановка продакшена               |
| `make prod-logs`   | Просмотр логов продакшена          |
| `make prod-clean`  | Очистка volume продакшена          |
| `make prod-update` | Обновление схемы и миграция данных |

Справка по всем командам: `make help`

---

## 🗄️ Структура базы данных

### Основные сущности

* **movies** — каталог фильмов
* **halls** — залы кинотеатра
* **seats** — схема мест в каждом зале
* **sessions** — расписание показов
* **tickets** — билеты на сеансы
* **customers** — данные покупателей

### Принципы нормализации

* **1NF**: все поля атомарны
* **2NF**: устранены частичные зависимости
* **3NF**: устранены транзитивные зависимости

---

## 💾 Работа с базой данных

### Подключение к PostgreSQL

```bash
psql -h localhost -p 5432 -U cinema_user -d cinema
# или через Docker
docker exec -it postgres-hw06 psql -U cinema_user -d cinema
```

### Доступ к pgAdmin

1. Откройте [http://localhost:8080](http://localhost:8080)
2. Логин/пароль — из env/.env.dev
3. Сервер — host: `db`, port: `5432`, пользователь: из env

---

## 📊 Основные запросы

### Самый прибыльный фильм

```sql
SELECT m.title, SUM(t.price) AS total_income
FROM tickets t
JOIN sessions s ON t.session_id = s.id
JOIN movies m ON s.movie_id = m.id
GROUP BY m.title
ORDER BY total_income DESC
LIMIT 1;
```

### Расписание сеансов

```sql
SELECT m.title, h.name AS hall_name, s.start_time, s.end_time, s.base_price
FROM sessions s
JOIN movies m ON s.movie_id = m.id
JOIN halls h ON s.hall_id = h.id
ORDER BY s.start_time;
```

---

## 🧪 Тестирование

### Автоматическая инициализация

* `schema.sql` — создаёт структуру
* `seed.sql` — наполняет тестовыми данными

### Проверка работы

```bash
make up
make logs
# или откройте схему в pgAdmin (Tools → ERD Tool)
```

---

## 🔧 Настройки окружения

### Для разработки

* Порты: 5432 (Postgres), 8080 (pgAdmin)
* Аутентификация: упрощённая (trust)
* Монтирование ddl/

### Для продакшена

* Порт pgAdmin: 8003, Postgres не пробрасывается наружу
* Аутентификация по паролю
* Изолированная сеть Docker

---

## 📚 Документация

### После выполнения:

* doc/cinema\_schema.md — логическая модель
* queries/most\_profitable\_movie.sql — итоговый запрос
* ER-диаграмма — экспорт из pgAdmin или через внешний сервис

### Критерии проверки

* Корректность сущностей и связей
* Соблюдение нормализации
* Полнота DDL-скриптов
* Корректный SQL-запрос на прибыльный фильм
* Краткое текстовое описание архитектуры

---

## 🚨 Устранение неполадок

### Если не запускается:

```bash
make ps
make logs
make down && make up
```

### Если проблемы с БД:

```bash
make clean
make up
# Для продакшена:
make prod-clean
make prod-up
```

### Если заняты порты:

```bash
lsof -i :5432
lsof -i :8080
# Или смените порты в docker-compose.dev.yml
```

---

## 📄 Лицензия

Проект создан для обучения на курсе OTUS "Разработчик PHP"
