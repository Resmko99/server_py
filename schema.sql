-- 1. Должности
CREATE TABLE IF NOT EXISTS position (
    position_id SERIAL PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL UNIQUE
);

-- 2. Пользователи
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    user_login VARCHAR(255) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    position_id INTEGER REFERENCES position(position_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    block BOOLEAN DEFAULT FALSE,
    failed_attempts INTEGER DEFAULT 0
);

-- 3. Клиенты
CREATE TABLE IF NOT EXISTS clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Категории
CREATE TABLE IF NOT EXISTS category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

-- 5. Номера
CREATE TABLE IF NOT EXISTS rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    category_id INTEGER REFERENCES category(category_id) ON DELETE SET NULL,
    floor INTEGER,
    capacity INTEGER,
    price_per_night NUMERIC(10,2)
);

-- 6. Уборка
CREATE TABLE IF NOT EXISTS cleaning (
    cleaning_id SERIAL PRIMARY KEY,
    room_id INTEGER REFERENCES rooms(room_id) ON DELETE CASCADE,
    cleaning_date TIMESTAMP NOT NULL,
    cleaned_by VARCHAR(255),
    status VARCHAR(50) DEFAULT 'в ожидании'
);

-- 7. Статусы бронирования
CREATE TABLE IF NOT EXISTS booking_status (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(100) NOT NULL UNIQUE
);

-- 8. Бронирования
CREATE TABLE IF NOT EXISTS bookings (
    booking_id SERIAL PRIMARY KEY,
    client_id INTEGER REFERENCES clients(client_id) ON DELETE CASCADE,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status_id INTEGER REFERENCES booking_status(status_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Связь бронирований и номеров
CREATE TABLE IF NOT EXISTS booking_rooms (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    room_id INTEGER REFERENCES rooms(room_id) ON DELETE CASCADE
);

-- 10. Способы оплаты
CREATE TABLE IF NOT EXISTS payment_method (
    method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL UNIQUE
);

-- 11. Платежи
CREATE TABLE IF NOT EXISTS payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    amount NUMERIC(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    method_id INTEGER REFERENCES payment_method(method_id) ON DELETE SET NULL
);

-- 12. Дополнительные услуги
CREATE TABLE IF NOT EXISTS additional_services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

-- 13. Использование услуг
CREATE TABLE IF NOT EXISTS service_usage (
    usage_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES additional_services(service_id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1
);

-- 14. Документы
CREATE TABLE IF NOT EXISTS documents (
    document_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(booking_id) ON DELETE CASCADE,
    document_name VARCHAR(255),
    document_path VARCHAR(500),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Анализ продаж
CREATE TABLE IF NOT EXISTS sales_analysis (
    id SERIAL PRIMARY KEY,
    analysis_date DATE NOT NULL,
    total_income NUMERIC(12, 2),
    total_bookings INTEGER,
    total_clients INTEGER
);

-- 16. Журнал аудита
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
