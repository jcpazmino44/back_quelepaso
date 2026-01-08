CREATE TABLE technician_categories (
  technician_id INTEGER NOT NULL,
  category_id UUID NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (technician_id, category_id),
  CONSTRAINT technician_categories_technician_fk
    FOREIGN KEY (technician_id) REFERENCES technicians(id) ON DELETE CASCADE,
  CONSTRAINT technician_categories_category_fk
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE INDEX technician_categories_category_idx
  ON technician_categories (category_id);

CREATE INDEX technician_categories_technician_idx
  ON technician_categories (technician_id);

INSERT INTO technician_categories (technician_id, category_id) VALUES
(1, (SELECT id FROM categories WHERE slug = 'plomeria')),
(4, (SELECT id FROM categories WHERE slug = 'plomeria')),
(7, (SELECT id FROM categories WHERE slug = 'plomeria')),
(2, (SELECT id FROM categories WHERE slug = 'electricidad')),
(5, (SELECT id FROM categories WHERE slug = 'electricidad')),
(8, (SELECT id FROM categories WHERE slug = 'electricidad')),
(3, (SELECT id FROM categories WHERE slug = 'electrodomesticos')),
(6, (SELECT id FROM categories WHERE slug = 'electrodomesticos')),
(3, (SELECT id FROM categories WHERE slug = 'otro')),
(6, (SELECT id FROM categories WHERE slug = 'otro'));


