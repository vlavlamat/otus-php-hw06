-- Базовая схема для тестирования Docker окружения
-- Домашнее задание №6: Кинотеатр

-- Создаем таблицу фильмов для тестирования
CREATE TABLE IF NOT EXISTS movies (
                                      id SERIAL PRIMARY KEY,
                                      title VARCHAR(255) NOT NULL,
    duration INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Вставляем тестовые данные
INSERT INTO movies (title, duration) VALUES
                                         ('Тестовый фильм 1', 120),
                                         ('Тестовый фильм 2', 90)
    ON CONFLICT DO NOTHING;

-- Создаем пользователя для приложения (если нужно)
-- DO $$
-- BEGIN
--     IF NOT EXISTS (SELECT FROM pg_user WHERE usename = 'app_user') THEN
--         CREATE USER app_user WITH PASSWORD 'app_password';
--         GRANT CONNECT ON DATABASE cinema TO app_user;
--         GRANT USAGE ON SCHEMA public TO app_user;
--         GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
--         GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO app_user;
--     END IF;
-- END
-- $$;