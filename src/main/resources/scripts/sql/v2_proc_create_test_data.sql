DELIMITER //

/*******************************************************************************
 * ランダムで性別を返す関数
 * 割合は男性が60%、女性が40%という想定。
 *
 ******************************************************************************/
SELECT 'create function func_get_gender' as 'progress'//

DROP FUNCTION IF EXISTS func_get_gender//
SHOW WARNINGS//

CREATE FUNCTION func_get_gender() RETURNS TINYINT(1)
DETERMINISTIC NO SQL
BEGIN
  DECLARE n INT;
  DECLARE v_gender TINYINT(1);

  /* ランダムで性別を選択 (0-4) */
  SET n = FLOOR(RAND() * 5);

  CASE n
    WHEN 0 THEN
      SET v_gender = 0;
    WHEN 1 THEN
      SET v_gender = 1;
    WHEN 2 THEN
      SET v_gender = 0;
    WHEN 3 THEN
      SET v_gender = 1;
    ELSE
      SET v_gender = 0;
  END CASE;

  RETURN v_gender;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * ランダムでメールアドレスを返す関数
 *
 *******************************************************************************/
SELECT 'create function func_get_email' as 'progress'//

DROP FUNCTION IF EXISTS func_get_email//
SHOW WARNINGS//

CREATE FUNCTION func_get_email() RETURNS VARCHAR(120)
DETERMINISTIC NO SQL
BEGIN
  DECLARE n INT;
  DECLARE v_email VARCHAR(120);
  DECLARE v_domain VARCHAR(30);

  /* ランダムでドメインを選択 (0-6) */
  SET n = FLOOR(RAND() * 7);

  CASE n
    WHEN 0 THEN
      SET v_domain = 'example.jp';
    WHEN 1 THEN
      SET v_domain = 'example.co.jp';
    WHEN 2 THEN
      SET v_domain = 'example.ne.jp';
    WHEN 3 THEN
      SET v_domain = 'example.com';
    WHEN 4 THEN
      SET v_domain = 'example.net';
    WHEN 5 THEN
      SET v_domain = 'example.info';
    ELSE
      SET v_domain = 'example.biz';
  END CASE;

  SET v_email = CONCAT(SUBSTRING(MD5(RAND()), 1, 4), '.', SUBSTRING(MD5(RAND()), 1, 5), '@', v_domain);

  RETURN v_email;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * ランダムで都道府県コードを返す関数
 * 東京、愛知、大阪、福岡はユーザー数が多いという想定。
 * 
 ******************************************************************************/
SELECT 'create function func_get_prefecture' as 'progress'//

DROP FUNCTION IF EXISTS func_get_prefecture//
SHOW WARNINGS//

CREATE FUNCTION func_get_prefecture() RETURNS TINYINT(2)
DETERMINISTIC NO SQL
BEGIN
  DECLARE n INT;
  DECLARE v_prefecture_id TINYINT(2);

  /* 0-119 */
  SET n = FLOOR(RAND() * 120);

  IF n >= 0 AND n <= 47 THEN
    SET v_prefecture_id = n;

  ELSE

    IF n >= 48 AND n <= 89 THEN
      /* 東京 */
      SET v_prefecture_id = 13;

    ELSEIF n >= 90 AND n <= 99 THEN
      /* 愛知 */
      SET v_prefecture_id = 23;

    ELSEIF n >= 100 AND n <= 109 THEN
      /* 大阪 */
      SET v_prefecture_id = 27;

    ELSE
      /* 福岡 */
      SET v_prefecture_id = 40;
    END IF;

  END IF;

  RETURN v_prefecture_id;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * 時刻がランダムな注文日を返す
 * (注文日のカーディナリティーを高めるための細工です。)
 *
 ******************************************************************************/
SELECT 'create function func_get_order_at' as 'progress'//

DROP FUNCTION IF EXISTS func_get_order_at//
SHOW WARNINGS//

CREATE FUNCTION func_get_order_at(v_order_at DATE) RETURNS DATETIME
DETERMINISTIC NO SQL
BEGIN
  DECLARE v_time_h, v_time_m, v_time_s INT;
  DECLARE v_order_datetime DATETIME;

  /* 注文日の時刻をランダムで決定 */
  SET v_time_h = FLOOR(RAND() * 24);
  SET v_time_m = FLOOR(RAND() * 60);
  SET v_time_s = FLOOR(RAND() * 60);

  SET v_order_datetime = CAST(CONCAT(DATE_FORMAT(v_order_at, '%Y-%m-%d'), ' ',
    LPAD(v_time_h,2,'0'), ':',
    LPAD(v_time_m,2,'0'), ':',
    LPAD(v_time_s,2,'0')) AS DATETIME);

  RETURN v_order_datetime;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * 都道府県別に偏りがある注文数を返す
 * 
 ******************************************************************************/
SELECT 'create function func_get_max_order' as 'progress'//

DROP FUNCTION IF EXISTS func_get_max_order//
SHOW WARNINGS//

CREATE FUNCTION func_get_max_order(v_prefecture_id INT) RETURNS INT
DETERMINISTIC NO SQL
BEGIN
  DECLARE v_max_order INT;

  /* 注文するアイテム数をランダムで決定 */
  CASE v_prefecture_id
  WHEN 13 THEN
    /* 東京 2-9 */
    SET v_max_order = FLOOR(RAND() * 8) + 2;
  WHEN 23 THEN
    /* 愛知 1-7 */
    SET v_max_order = FLOOR(RAND() * 7) + 1;
  WHEN 27 THEN
    /* 大阪 1-8 */
    SET v_max_order = FLOOR(RAND() * 8) + 1;
  WHEN 40 THEN
    /* 福岡 1-7 */
    SET v_max_order = FLOOR(RAND() * 7) + 1;
  ELSE
    /* そのほか 1-5 */
    SET v_max_order = FLOOR(RAND() * 5) + 1;
  END CASE;

  RETURN v_max_order;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * 配送日をランダムで返す
 *
 ******************************************************************************/
SELECT 'create function func_get_shipped_at' as 'progress'//

DROP FUNCTION IF EXISTS func_get_shipped_at//
SHOW WARNINGS//

CREATE FUNCTION func_get_shipped_at(v_order_at DATETIME, v_current DATETIME) RETURNS DATETIME
DETERMINISTIC NO SQL
BEGIN
  DECLARE v_shipped_datetime DATETIME;

  /* 過去の注文は配送日は確定しているという想定 */
  IF v_order_at < v_current THEN

    SET v_shipped_datetime = v_order_at + INTERVAL FLOOR(RAND() * 3) + 1 DAY;

  /* 今日以降はランダムで配送日を確定  */
  ELSE

    IF FLOOR(RAND() * 10) < 3 THEN

      SET v_shipped_datetime = v_order_at + INTERVAL FLOOR(RAND() * 3) + 1 DAY;

    ELSE

      /* 未確定 */
      SET v_shipped_datetime = NULL;

    END IF;

  END IF;


  RETURN v_shipped_datetime;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * レビューテキスト文をランダムで生成する
 *
 ******************************************************************************/
SELECT 'create function func_get_review_text' as 'progress'//

DROP FUNCTION IF EXISTS func_get_review_text//
SHOW WARNINGS//

CREATE FUNCTION func_get_review_text() RETURNS TEXT
DETERMINISTIC NO SQL
BEGIN
  DECLARE v_rand_num_lines, v_cnt_lines INT;
  DECLARE n INT;

  DECLARE v_review_text TEXT;

  # SELECT MD5(RAND());
  # SELECT SHA(RAND());
  # SELECT SHA2(RAND(), 256);
  # SELECT SHA2(RAND(), 512);
  # SELECT SUBSTRING('あいうえおかきくけこさしすせそ', 10, 1);

  /* レビューの行数 3-5 */
  SET v_rand_num_lines = FLOOR(RAND() * 3) + 3;
  SET v_cnt_lines = 0;

  SET v_review_text = '';

  WHILE v_rand_num_lines > v_cnt_lines DO

    /* ダミー文字列を選択 */
    SET n = FLOOR(RAND() * 10);

    CASE n
      WHEN 0 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'あいうえおかきくけこさしすせそたちつてとなにぬねの', '\n');
      WHEN 1 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'ハヒフヘホマミムメモヤユヨワヲン', '\n');
      WHEN 2 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'１２３４５６７８９０一二三四五六七八九零', '\n');
      WHEN 3 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'亜哀挨愛曖悪握圧扱宛嵐安案暗以衣位囲医依委威為畏', '\n');
      WHEN 4 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'1234567890-+*%#$&=()@[]', '\n');
      WHEN 5 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'ABC DEF GHI JKL MNO PQR STU VWX YZ', '\n');
      WHEN 6 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'弌丐丕个丱丶丼丿乂乖乘亂亅豫亊舒弍于亞亟亠亢亰亳', '\n');
      WHEN 7 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'─┌┐│└┘├┤┬┴〒', '\n');
      WHEN 8 THEN
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'丑丞乃之乎也云亘亙些亦亥亨亮仔伊伍伽佃佑伶侃侑俄', '\n');
      ELSE
        SET v_review_text = CONCAT(v_review_text, _utf8mb4'俱㐂丨丯丰亍仡份仿伃伋你佈佉佖佟佪佬佾侊侔侗侮俉', '\n');
    END CASE;

    SET v_cnt_lines = v_cnt_lines + 1;
  END WHILE;

  RETURN v_review_text;

END;
//
SHOW WARNINGS//


/*******************************************************************************
 * テストデータを生成するプロシージャ
 *
 * call proc_create_test_data();
 *
 ******************************************************************************/
SELECT 'create procedure proc_create_test_data' as 'progress'//

DROP PROCEDURE IF EXISTS proc_create_test_data//
SHOW WARNINGS//

CREATE PROCEDURE proc_create_test_data()
BEGIN
  DECLARE done INT DEFAULT 0;

  /* category_cur用の変数 */
  DECLARE category_id_rec INT;
  DECLARE category_name_rec VARCHAR(60);

  /* customer_cur用の変数 */
  DECLARE customer_id_rec INT;
  DECLARE customer_nick_name_rec VARCHAR(60);
  DECLARE customer_prefecture_id_rec TINYINT(2);

  /* customer_order_cur用の変数 */
  DECLARE customer_order_id_rec INT;
  DECLARE customer_order_customer_id_rec INT;
  DECLARE customer_order_shipped_at_rec DATETIME;

  DECLARE rand_num_order_customers INT DEFAULT 5000;
  DECLARE rand_num_review_customers INT DEFAULT 1000;

  DECLARE category_cur CURSOR FOR
    SELECT c.id
         , c.name
      FROM category c
     ORDER BY
           c.id ASC
         ;

  /* 注文するユーザーをランダムでrand_num_order_customers件数、選択するカーソル */
  DECLARE customer_cur CURSOR FOR
    SELECT c.id
         , c.nick_name
         , c.prefecture_id
      FROM customer c
     ORDER BY
           RAND()
     LIMIT rand_num_order_customers
         ;

  /* レビューする注文データをランダムでrand_num_review_customers件数、選択するカーソル */
  DECLARE customer_order_cur CURSOR FOR
    SELECT co.id
         , co.customer_id
         , co.shipped_at
      FROM customer_order co
     WHERE co.cancel_flag = 0
       AND co.shipped_at IS NOT NULL
     ORDER BY
           RAND()
     LIMIT rand_num_review_customers
         ;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  /**
   * テストデータ初期化
   */
  BEGIN
    SET foreign_key_checks = 0;
    TRUNCATE TABLE category;
    TRUNCATE TABLE location;
    TRUNCATE TABLE item;
    TRUNCATE TABLE item_stock;
    TRUNCATE TABLE customer;
    TRUNCATE TABLE customer_order;
    TRUNCATE TABLE customer_review;
    SET foreign_key_checks = 1;
  END;


  SELECT NOW() AS "START CREATE CATEGORY";

  /**
   * アイテムのカテゴリを作成
   */
  create_category: BEGIN

    START TRANSACTION;

    INSERT INTO category (name) VALUES
      ('Kitchen & Dining'),
      ('FURNITURE'),
      ('BEDDING & BATH'),
      ('Appliances'),
      ('PATIO,LAWN & GARDEN'),
      ('ART'),
      ('PET SUPPLIES'),
      ('Wedding Registry'),
      ('Home Improvement'),
      ('Power and Hand Tools'),

      ('Lighting & Ceiling Fans'),
      ('Kitchen & Bath Fixtures'),
      ('Hardware'),
      ('SMART HOME'),
      ('Luxury-Beauty'),
      ('Mens-Grooming'),
      ('Health, Household and Baby Care'),
      ('Vitamins & Dietary Supplements'),
      ('Food & Beverages'),
      ('Specialty Diets'),

      ('Wine'),
      ('Subscribe & Save'),
      ('Prime Pantry'),
      ('Toys & Games'),
      ('DIGITAL MUSIC'),
      ('Musical Instruments'),
      ('HEADPHONES'),
      ('Video Games'),
      ('Digital Video Games'),
      ('Entertainment Collectibles')
      ;

    COMMIT;

  END create_category;

  SELECT NOW() AS "END CREATE CATEGORY";

  SELECT NOW() AS "START CREATE LOCATION";

  create_location: BEGIN

    START TRANSACTION;

    INSERT INTO location (prefecture_id, description) VALUES
        ( 1, _utf8mb4'北海道'),
        ( 2, _utf8mb4'青森県'),
        ( 3, _utf8mb4'岩手県'),
        ( 4, _utf8mb4'宮城県'),
        ( 5, _utf8mb4'秋田県'),
        ( 6, _utf8mb4'山形県'),
        ( 7, _utf8mb4'福島県'),
        ( 8, _utf8mb4'茨城県'),
        ( 9, _utf8mb4'栃木県'),
        (10, _utf8mb4'群馬県'),
        (11, _utf8mb4'埼玉県'),
        (12, _utf8mb4'千葉県'),
        (13, _utf8mb4'東京都'),
        (14, _utf8mb4'神奈川県'),
        (15, _utf8mb4'新潟県'),
        (16, _utf8mb4'富山県'),
        (17, _utf8mb4'石川県'),
        (18, _utf8mb4'福井県'),
        (19, _utf8mb4'山梨県'),
        (20, _utf8mb4'長野県'),
        (21, _utf8mb4'岐阜県'),
        (22, _utf8mb4'静岡県'),
        (23, _utf8mb4'愛知県'),
        (24, _utf8mb4'三重県'),
        (25, _utf8mb4'滋賀県'),
        (26, _utf8mb4'京都府'),
        (27, _utf8mb4'大阪府'),
        (28, _utf8mb4'兵庫県'),
        (29, _utf8mb4'奈良県'),
        (30, _utf8mb4'和歌山県'),
        (31, _utf8mb4'鳥取県'),
        (32, _utf8mb4'島根県'),
        (33, _utf8mb4'岡山県'),
        (34, _utf8mb4'広島県'),
        (35, _utf8mb4'山口県'),
        (36, _utf8mb4'徳島県'),
        (37, _utf8mb4'香川県'),
        (38, _utf8mb4'愛媛県'),
        (39, _utf8mb4'高知県'),
        (40, _utf8mb4'福岡県'),
        (41, _utf8mb4'佐賀県'),
        (42, _utf8mb4'長崎県'),
        (43, _utf8mb4'熊本県'),
        (44, _utf8mb4'大分県'),
        (45, _utf8mb4'宮崎県'),
        (46, _utf8mb4'鹿児島県'),
        (47, _utf8mb4'沖縄県')
    ;

    COMMIT;

  END create_location;

  SELECT NOW() AS "END CREATE LOCATION";


  SELECT NOW() AS "START CREATE CATEGORY/ITEM DATA";

  /**
   * アイテム、在庫を作成
   * 1カテゴリにつき3から7種のアイテムをランダムで作成
   */
  create_item: BEGIN
    DECLARE v_name VARCHAR(90);
    DECLARE v_price, v_standard_type, v_stock, v_location_id INT;
    DECLARE v_sales_from, v_sales_to DATE;

    DECLARE v_rand_max_item, v_cnt_item INT;


    START TRANSACTION;

    SET done = 0;

    OPEN category_cur;

    category_ite: LOOP

      FETCH category_cur INTO category_id_rec, category_name_rec;
      IF done = 1 THEN
        SELECT "leave category_ite";
        LEAVE category_ite;
      END IF;

      /* 1カテゴリに作成するアイテムの数をランダムで決定 (3-7) */
      SET v_rand_max_item = FLOOR(RAND() * 5) + 3;
      SET v_cnt_item = 0;

      WHILE v_rand_max_item > v_cnt_item DO

        /* アイテム名をランダムで決定 */
        SET v_name = CONCAT(category_name_rec, ' - ',  SUBSTRING(MD5(RAND()), 1, 10));
        /* アイテムの価格をランダムで決定 (100-1000) */
        SET v_price = (FLOOR(RAND() * 10) + 1) * 100;
        /* アイテムの販売期間 */
        SET v_sales_from = CAST('2018-01-01' AS DATE);
        SET v_sales_to = CAST('2018-12-31' AS DATE);
        /* 規格タイプをランダムで決定 (0-9) */
        SET v_standard_type = FLOOR(RAND() * 10);
        /* ロケーションIDをランダムで決定 (1-47) */
        SET v_location_id = FLOOR(RAND() * 47) + 1;

        INSERT INTO item (
          name,
          price,
          sales_from,
          sales_to,
          standard_type,
          category_id)
        VALUES (
          v_name,
          v_price,
          v_sales_from,
          v_sales_to,
          v_standard_type,
          category_id_rec
        );

        /* アイテムの在庫数をランダムで決定 */
        SET v_stock = (FLOOR(RAND() * 1000) + 1) * 1000;
        INSERT INTO item_stock (
          stock,
          item_id,
          location_id)
        VALUES (
          v_stock,
          LAST_INSERT_ID(),
          v_location_id
        );

        SET v_cnt_item = v_cnt_item + 1;
      END WHILE;

    END LOOP category_ite;

    CLOSE category_cur;

    COMMIT;

  END create_item;

  SELECT NOW() AS "END CREATE CATEGORY/ITEM DATA";


  SELECT NOW() AS "START CREATE CUSTOMER DATA";

  /**
   * ユーザーを作成
   * 
   * 性別は男性が60%、女性が40%
   */
  create_customer: BEGIN
    DECLARE v_nick_name VARCHAR(60);
    DECLARE v_gender TINYINT(1);
    DECLARE v_prefecture_id TINYINT(2);
    DECLARE v_email VARCHAR(120);

    DECLARE v_max_customer, v_cnt_customer INT;


    START TRANSACTION;

    /* テストユーザーの作成件数 */
    SET v_max_customer = 250000;
    SET v_cnt_customer = 0;

    WHILE v_max_customer > v_cnt_customer DO

      /* ユーザー名をランダムで決定 */
      SET v_nick_name = CONCAT('TESTUSER-', SUBSTRING(MD5(RAND()), 1, 20));
      /* 性別をランダムで決定 */
      SET v_gender = func_get_gender();
      /* メールアドレスをランダムで決定 */
      SET v_email = func_get_email();
      /* 住所をランダムで決定 */
      SET v_prefecture_id = func_get_prefecture();

      INSERT INTO customer (
        nick_name,
        gender,
        prefecture_id,
        email)
      VALUES (
        v_nick_name,
        v_gender,
        v_prefecture_id,
        v_email);

      /* 1000件ごとにcommit */
      IF v_cnt_customer % 1000 = 0 THEN
        COMMIT;
        START TRANSACTION;
      END IF;

      SET v_cnt_customer = v_cnt_customer + 1;
    END WHILE;

    COMMIT;

  END create_customer;

  SELECT NOW() AS "END CREATE CUSTOMER DATA";


  SELECT NOW() AS "START CUSTOMER ORDER DATA";

  /**
   * 注文データを作成
   * 
   * 注文データを作成する期間は1/1～3/31までの3カ月間
   * 1日あたり5万ユーザーがアイテムを1-9件購入するという想定
   */
  create_customer_order: BEGIN
    DECLARE v_rand_order_num INT;
    DECLARE v_order_at DATETIME;
    DECLARE v_shipped_at DATETIME;
    DECLARE v_category_id, v_item_id INT;

    DECLARE v_order_date, v_order_date_end DATE;

    DECLARE v_rand_max_order, v_cnt_order INT;
    DECLARE v_cnt_customer INT;


    START TRANSACTION;

    SET v_cnt_customer = 0;

    /* 注文データを作成する期間 */
    SET v_order_date = CAST('2018-05-01' AS DATE);
    SET v_order_date_end = CAST('2018-08-01' AS DATE);

    WHILE v_order_date_end > v_order_date DO
      SELECT v_order_date;

      /* 日毎に注文するユーザー数をランダムで決定 (5000-10000) */
      SET rand_num_order_customers = FLOOR(RAND() * 5001) + 5000;
      SELECT rand_num_order_customers;

      SET done = 0;

      OPEN customer_cur;

      customer_ite: LOOP

        FETCH customer_cur INTO customer_id_rec, customer_nick_name_rec, customer_prefecture_id_rec;
        IF done = 1 THEN
          SELECT "leave customer_ite";
          LEAVE customer_ite;
        END IF;

        /* 注文日の時刻をランダムで決定 */
        SET v_order_at = func_get_order_at(v_order_date);

        /* 注文するアイテム数をランダムで決定 */
        SET v_rand_max_order = func_get_max_order(customer_prefecture_id_rec);

        SET v_cnt_order = 0;

        /* 注文するカテゴリをランダムで選択 */
        SELECT c.id
          INTO v_category_id
          FROM category c
         ORDER BY
               RAND()
         LIMIT 1
             ;

        /* 1ユーザーの注文を作成 */
        WHILE v_rand_max_order > v_cnt_order DO

          /* 注文するアイテムをランダムで選択 */
          SELECT i.id
            INTO v_item_id
            FROM item i
           WHERE i.category_id = v_category_id
             AND i.sales_from <= v_order_date
             AND i.sales_to   >  v_order_date
           ORDER BY
                 RAND()
           LIMIT 1
               ;

          /* 注文数をランダムで決定 (1-3) */
          SET v_rand_order_num = FLOOR(RAND() * 3) + 1;

          /* 配送日をランダムで決定 */
          SET v_shipped_at = func_get_shipped_at(v_order_at, CURRENT_TIMESTAMP);

          INSERT INTO customer_order (
            order_num,
            order_at,
            order_type,
            shipped_at,
            item_id,
            customer_id)
          VALUES (
            v_rand_order_num,
            v_order_at,
            1,
            v_shipped_at,
            v_item_id,
            customer_id_rec
          );

          /* アイテムの在庫を減らす */
          UPDATE item_stock
             SET item_stock.stock = item_stock.stock - v_rand_order_num
               , item_stock.update_at = NOW()
           WHERE item_stock.item_id = v_item_id
               ;

          SET v_cnt_order = v_cnt_order + 1;
        END WHILE;

        /* 100人毎にcommit */
        IF v_cnt_customer % 100 = 0 THEN
          COMMIT;
          START TRANSACTION;
        END IF;

        SET v_cnt_customer = v_cnt_customer + 1;
      END LOOP customer_ite;

      CLOSE customer_cur;

      COMMIT;

      SET v_order_date = v_order_date + INTERVAL 1 DAY;
    END WHILE;

    COMMIT;

  END create_customer_order;

  SELECT NOW() AS "END CREATE CUSTOMER ORDER DATA";


  SELECT NOW() AS "START CREATE CUSTOMER REVIEW DATA";

  /**
   * レビューデータを作成
   */
  create_customer_review: BEGIN
    DECLARE v_review_at DATETIME;
    DECLARE v_review TEXT;

    DECLARE v_cnt_review INT;
    DECLARE v_rand_day_after_shipped INT DEFAULT 1;

    /* レビューデータを作成する件数をランダムで選択 (100000 - 149999) */
    SET rand_num_review_customers = FLOOR(RAND() * 50000) + 100000;


    START TRANSACTION;

    SET v_cnt_review = 0;

    SET done = 0;

    OPEN customer_order_cur;

    customer_order_ite: LOOP

      FETCH customer_order_cur INTO customer_order_id_rec, customer_order_customer_id_rec, customer_order_shipped_at_rec;
      IF done = 1 THEN
        SELECT "leave customer_order_ite";
        LEAVE customer_order_ite;
      END IF;

      /* レビュー日は配送日から1-3日後 */
      SET v_rand_day_after_shipped = FLOOR(RAND() * 3) + 1;
      SET v_review_at = customer_order_shipped_at_rec + INTERVAL v_rand_day_after_shipped DAY;

      SET v_review = func_get_review_text();

      INSERT INTO customer_review (
        review_at,
        review,
        customer_order_id,
        customer_id)
      VALUES (
        v_review_at,
        v_review,
        customer_order_id_rec,
        customer_order_customer_id_rec
      );

      IF v_cnt_review % 1000 = 0 THEN
        COMMIT;
        START TRANSACTION;
      END IF;

      SET v_cnt_review = v_cnt_review + 1;
    END LOOP customer_order_ite;

    CLOSE customer_order_cur;

    COMMIT;

  END create_customer_review;

  SELECT NOW() AS "END CREATE CUSTOMER REVIEW DATA";

END;
//

SHOW WARNINGS//

DELIMITER ;
