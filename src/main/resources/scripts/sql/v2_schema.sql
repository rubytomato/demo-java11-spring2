DROP TABLE IF EXISTS category;

CREATE TABLE category (
  id INT AUTO_INCREMENT                          COMMENT 'カテゴリID',
  name VARCHAR(60) NOT NULL                      COMMENT 'カテゴリ名',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = 'カテゴリマスター';

DROP TABLE IF EXISTS item;

CREATE TABLE item (
  id INT AUTO_INCREMENT                          COMMENT 'アイテムID',
  name VARCHAR(90) NOT NULL                      COMMENT 'アイテム名',
  price INT NOT NULL                             COMMENT '価格',
  sales_from DATE NOT NULL                       COMMENT '販売開始日',
  sales_to DATE NOT NULL                         COMMENT '販売終了日',
  standard_type INT NOT NULL                     COMMENT '規格タイプ',
  category_id INT NOT NULL                       COMMENT 'カテゴリID',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = 'アイテムマスター';

DROP TABLE IF EXISTS item_stock;

CREATE TABLE item_stock (
  id INT AUTO_INCREMENT                          COMMENT 'アイテム在庫ID',
  stock INT NOT NULL DEFAULT 0                   COMMENT '在庫数',
  item_id INT NOT NULL                           COMMENT 'アイテムID',
  location_id INT NULL                           COMMENT 'ロケーションID',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  UNIQUE KEY (item_id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = 'アイテム在庫テーブル';

DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
  id INT AUTO_INCREMENT                          COMMENT '顧客ID',
  nick_name VARCHAR(60) NOT NULL                 COMMENT 'ニックネーム',
  gender TINYINT(1) NOT NULL                     COMMENT '性別 0:男性 1:女性',
  prefecture_id TINYINT(2) NOT NULL DEFAULT 0    COMMENT '都道府県 0:不明 1:北海道-47:沖縄',
  email VARCHAR(120)                             COMMENT 'メールアドレス',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = '顧客テーブル';

DROP TABLE IF EXISTS customer_order;

CREATE TABLE customer_order (
  id INT AUTO_INCREMENT                          COMMENT '顧客注文ID',
  order_num TINYINT(1) NOT NULL                  COMMENT '注文数',
  order_at DATETIME NOT NULL                     COMMENT '注文日',
  order_type TINYINT(1) NOT NULL DEFAULT 0       COMMENT '0:店頭 1:オンライン',
  shipped_at DATETIME NULL                       COMMENT '配送日',
  cancel_flag TINYINT(1) NOT NULL DEFAULT 0      COMMENT '1:キャンセル',
  item_id INT NULL                               COMMENT 'アイテムID',
  customer_id INT NOT NULL                       COMMENT '顧客ID',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = '顧客注文テーブル';

DROP TABLE IF EXISTS customer_review;

CREATE TABLE customer_review (
  id INT AUTO_INCREMENT                          COMMENT 'レビューID',
  review_at DATETIME NOT NULL                    COMMENT 'レビュー日',
  review TEXT NOT NULL                           COMMENT 'レビュー',
  customer_order_id INT NULL                     COMMENT '顧客注文ID',
  customer_id INT NOT NULL                       COMMENT '顧客ID',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = '顧客レビューテーブル';

DROP TABLE IF EXISTS location;

CREATE TABLE location (
  id INT AUTO_INCREMENT                          COMMENT 'ロケーションID',
  prefecture_id INT NOT NULL                     COMMENT '都道府県ID',
  description VARCHAR(200) NULL                  COMMENT '備考',
  create_at DATETIME NOT NULL DEFAULT NOW(),
  update_at DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
)
ENGINE = INNODB
CHARACTER SET = utf8mb4
COLLATE utf8mb4_0900_ai_ci
COMMENT = 'ロケーションテーブル';
