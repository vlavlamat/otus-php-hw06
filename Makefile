# Makefile для управления окружением проекта "Кинотеатр"
# Использует docker-compose.yml + dev/prod override файлы

# ──────────────────────────────────────
# Dev окружение (локальная разработка arm64)
# ──────────────────────────────────────

up:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

logs:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

ps:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml ps

# Очистка volume (данные БД будут удалены!)
clean:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v

# Быстрое восстановление после чистки (для dev)
rebuild: clean up

# ────────────────────────────────
# Production окружение (сервер)
# ────────────────────────────────

prod-up:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

prod-down:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

prod-logs:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f

prod-ps:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps

# Остановка и удаление volume в продакшене (ОСТОРОЖНО: удаляются все данные!)
prod-clean:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml down -v

# Пересоздание прод-окружения с нуля (чистая база, актуальная схема)
prod-update: prod-clean prod-up
	@echo "Production database has been reinitialized using latest schema.sql"

# Справка по командам
help:
	@echo "Основные команды:"
	@echo "  make up         # Запуск dev-окружения (PostgreSQL, pgAdmin)"
	@echo "  make down       # Остановить dev-окружение"
	@echo "  make logs       # Логи dev-окружения"
	@echo "  make ps         # Список контейнеров (dev)"
	@echo "  make prod-up    # Запуск production-окружения"
	@echo "  make prod-down  # Остановить production-окружение"
	@echo "  make prod-logs  # Логи production-окружения"
	@echo "  make prod-ps    # Список контейнеров (prod)"
	@echo "  make clean      # Остановить и удалить volume (dev!)"
	@echo "  make prod-clean # Остановить и удалить volume (prod!)"
	@echo "  make rebuild    # Очистить и пересоздать dev-окружение"
	@echo "  make help       # Справка"

.DEFAULT_GOAL := help