-- ========================================
-- Bölüm 1: Tablo Oluşturma (DDL) - CASCADE ile
-- ========================================

-- 1. Developers Tablosu
CREATE TABLE developers (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    founded_year INT
);

-- 2. Games Tablosu
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    release_date DATE,
    rating NUMERIC(3,1),
    developer_id INT NOT NULL,
    CONSTRAINT fk_developer
        FOREIGN KEY(developer_id) REFERENCES developers(id)
        ON DELETE CASCADE
);

-- 3. Genres Tablosu
CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- 4. Games_Genres Ara Tablosu (Many-to-Many) - CASCADE ile
CREATE TABLE games_genres (
    id SERIAL PRIMARY KEY,
    game_id INT NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT fk_game
        FOREIGN KEY(game_id) REFERENCES games(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_genre
        FOREIGN KEY(genre_id) REFERENCES genres(id)
        ON DELETE CASCADE,
    CONSTRAINT unique_game_genre UNIQUE(game_id, genre_id)
);

-- ========================================
-- Bölüm 2: Veri Ekleme (DML - INSERT)
-- ========================================

-- 2.1 Developers Ekleme
INSERT INTO developers (company_name, country, founded_year) VALUES
('CD Projekt Red', 'Poland', 1994),
('Rockstar Games', 'USA', 1998),
('Bethesda Softworks', 'USA', 1986),
('Valve', 'USA', 1996),
('Ubisoft', 'France', 1986);

-- 2.2 Genres Ekleme
INSERT INTO genres (name, description) VALUES
('RPG', 'Role-playing game'),
('Open World', 'Games with a large, open environment'),
('Horror', 'Scary games with suspense elements'),
('FPS', 'First-person shooter'),
('Sports', 'Sports simulation games');

-- 2.3 Games Ekleme
INSERT INTO games (title, price, release_date, rating, developer_id) VALUES
('The Witcher 3', 299.99, '2015-05-19', 9.5, 1),
('Cyberpunk 2077', 399.99, '2020-12-10', 7.5, 1),
('Grand Theft Auto V', 499.99, '2013-09-17', 9.7, 2),
('Red Dead Redemption 2', 599.99, '2018-10-26', 9.8, 2),
('Skyrim', 249.99, '2011-11-11', 9.2, 3),
('Fallout 4', 299.99, '2015-11-10', 8.8, 3),
('Half-Life: Alyx', 399.99, '2020-03-23', 9.4, 4),
('Portal 2', 199.99, '2011-04-19', 9.6, 4),
('Assassin''s Creed Valhalla', 549.99, '2020-11-10', 8.9, 5),
('Far Cry 6', 499.99, '2021-10-07', 8.7, 5);

-- 2.4 Games_Genres Ekleme (Many-to-Many)
INSERT INTO games_genres (game_id, genre_id) VALUES
-- The Witcher 3
(1,1),(1,2),
-- Cyberpunk 2077
(2,1),(2,2),
-- GTA V
(3,2),(3,4),
-- Red Dead Redemption 2
(4,2),
-- Skyrim
(5,1),(5,2),
-- Fallout 4
(6,1),(6,2),
-- Half-Life: Alyx
(7,4),(7,3),
-- Portal 2
(8,4),
-- Assassin's Creed Valhalla
(9,1),(9,2),
-- Far Cry 6
(10,2),(10,4);

-- ========================================
-- Bölüm 3: Güncelleme ve Silme (UPDATE / DELETE) - CASCADE ile
-- ========================================

-- 3.1 İndirim Zamanı: Tüm oyunların fiyatını %10 düşür
UPDATE games
SET price = price * 0.90;

-- 3.2 Hata Düzeltme: Cyberpunk 2077 puanını 7.5 -> 9.0 yap
UPDATE games
SET rating = 9.0
WHERE title = 'Cyberpunk 2077';

-- 3.3 Kaldırma: 'Portal 2' oyununu CASCADE ile tamamen sil
DELETE FROM games
WHERE title = 'Portal 2';
-- Artık games_genres tablosundaki ilgili satırlar otomatik silinecek

-- ========================================
-- Bölüm 4: Raporlama (SELECT & JOIN)
-- ========================================

-- 4.1 Tüm Oyunlar Listesi: Oyunun adı, Fiyatı, Geliştirici
SELECT g.title AS "Oyun Adı",
       g.price AS "Fiyat",
       d.company_name AS "Geliştirici Firmanın Adı"
FROM games g
JOIN developers d ON g.developer_id = d.id
ORDER BY g.title;

-- 4.2 Kategori Filtresi: Sadece RPG türündeki oyunlar
SELECT g.title AS "Oyun Adı",
       g.rating AS "Puan"
FROM games g
JOIN games_genres gg ON g.id = gg.game_id
JOIN genres gr ON gg.genre_id = gr.id
WHERE gr.name = 'RPG';

-- 4.3 Fiyat Analizi: 500 TL üzerinde oyunlar pahalıdan ucuza sıralama
SELECT title AS "Oyun Adı",
       price AS "Fiyat"
FROM games
WHERE price > 500
ORDER BY price DESC;

-- 4.4 Arama: İçinde 'War' kelimesi geçen oyunlar
SELECT title AS "Oyun Adı",
       price AS "Fiyat"
FROM games
WHERE title LIKE '%War%';

