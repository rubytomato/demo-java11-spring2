ALTER TABLE item ADD CONSTRAINT FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE;

ALTER TABLE item_stock ADD CONSTRAINT FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE;
ALTER TABLE item_stock ADD CONSTRAINT FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE SET NULL;

ALTER TABLE customer_order ADD CONSTRAINT FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE SET NULL;
ALTER TABLE customer_order ADD CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE;

ALTER TABLE customer_review ADD CONSTRAINT FOREIGN KEY (customer_order_id) REFERENCES customer_order(id) ON DELETE SET NULL;
ALTER TABLE customer_review ADD CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE;

/*
ALTER TABLE item DROP FOREIGN KEY "<name>";
ALTER TABLE item_stock DROP FOREIGN KEY "<name>";
ALTER TABLE customer_order DROP FOREIGN KEY "<name>";
ALTER TABLE customer_review DROP FOREIGN KEY "<name>";
*/