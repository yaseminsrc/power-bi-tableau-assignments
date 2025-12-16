# 🎮 GameVault PostgreSQL Database

GameVault, Steam veya Epic Games benzeri bir **dijital oyun dağıtım platformu** için tasarlanmış bir **PostgreSQL veritabanı projesidir**.  
Bu proje; oyun geliştiricileri, oyunlar ve oyun türleri arasındaki ilişkileri modellemeyi amaçlar.

---

## 📌 Proje Amacı

- İlişkisel veritabanı tasarımı (Relational Database Design)
- One-to-Many ve Many-to-Many ilişkilerin doğru kurulması
- PostgreSQL üzerinde:
  - `PRIMARY KEY`
  - `FOREIGN KEY`
  - `ON DELETE CASCADE`
  - `JOIN`, `INSERT`, `UPDATE`, `DELETE` sorgularının uygulanması

---

## 🛠️ Kullanılan Teknolojiler

- **PostgreSQL**
- **SQL (DDL & DML)**
- **DrawSQL** (ER Diyagramı)

---

## 🗂️ Veritabanı Şeması

Veritabanı aşağıdaki tablolardan oluşur:

### 1️⃣ developers
| Alan | Açıklama |
|---|---|
| id | Geliştirici ID (Primary Key) |
| company_name | Firma adı |
| country | Ülke |
| founded_year | Kuruluş yılı |

---

### 2️⃣ games
| Alan | Açıklama |
|---|---|
| id | Oyun ID (Primary Key) |
| title | Oyun adı |
| price | Fiyat |
| release_date | Çıkış tarihi |
| rating | Puan |
| developer_id | Geliştirici ID (Foreign Key) |

📌 **İlişki:**  
- One-to-Many (Bir geliştirici → Birden fazla oyun)

---

### 3️⃣ genres
| Alan | Açıklama |
|---|---|
| id | Tür ID (Primary Key) |
| name | Tür adı |
| description | Tür açıklaması |

---

### 4️⃣ games_genres
| Alan | Açıklama |
|---|---|
| id | Ara tablo ID |
| game_id | Oyun ID (Foreign Key) |
| genre_id | Tür ID (Foreign Key) |

📌 **İlişki:**  
- Many-to-Many (Bir oyun → Birden fazla tür)

---

## 🔗 İlişkiler (ERD)

- `developers (1) → (N) games`
- `games (N) → (N) genres` (games_genres ara tablosu ile)
- Tüm ilişkiler **ON DELETE CASCADE** ile tanımlanmıştır.

📷 **ER Diyagramı:**  
> DrawSQL üzerinden oluşturulan diyagram, proje dosyaları içinde ekran görüntüsü olarak yer almaktadır.

---

## 🧱 Veritabanı Özellikleri

- Otomatik artan `SERIAL` primary key
- Veri bütünlüğü için `FOREIGN KEY`
- Güvenli silme için `ON DELETE CASCADE`
- Duplicate ilişkileri önlemek için `UNIQUE(game_id, genre_id)`

---

## 📝 Örnek SQL Sorguları

### 🎯 Tüm Oyunları ve Geliştiricilerini Listeleme
```sql
SELECT g.title, g.price, d.company_name
FROM games g
JOIN developers d ON g.developer_id = d.id;
