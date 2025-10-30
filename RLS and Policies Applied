---Row-Level Security (RLS) policies for Restaurant Ordering Database project that supports both Admin and Regular User roles.
---Enable RLS on all tables
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

---creating a mapping table that links the uuid from the auth system to the customer_id
CREATE TABLE customer_auth_map (
  user_uid UUID PRIMARY KEY,
  customer_id INT UNIQUE NOT NULL REFERENCES customers(customer_id)
);

---creating a new table user_roles(admin and user)
CREATE TABLE user_roles (
  user_uid UUID PRIMARY KEY,
  role TEXT CHECK (role IN ('admin', 'user'))
);

---RLS Policies by Table and Role(Admin, User)
----1. customers Table
--Admin: Full Access
CREATE POLICY "customers: admin full access"
ON customers
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_uid = auth.uid() AND role = 'admin'
  )
);

--User: Only Read and Insert Own Data
CREATE POLICY "customers: user can read own data"
ON customers
FOR SELECT
USING (
  customer_id IN (
    SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

CREATE POLICY "customers: user can insert own data"
ON customers
FOR INSERT
WITH CHECK (
  customer_id IN (
    SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

----2. menu_items table
--Admin: Full Access
CREATE POLICY "menu_items: admin full access"
ON menu_items
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_uid = auth.uid() AND role = 'admin'
  )
);

--User: Read Only
CREATE POLICY "menu_items: user can only read own data"
ON menu_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_uid = auth.uid() AND role = 'user'
  )
);

----3. orders Table
--Admin: Full Access
CREATE POLICY "orders: admin full access"
ON orders
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'admin'
  )
);

--User: Only Read and Insert Own orders
CREATE POLICY "orders: user can read own orders"
ON orders
FOR SELECT
USING (
  customer_id IN (
    SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

CREATE POLICY "orders: user can insert own order"
ON orders
FOR INSERT
WITH CHECK (
  customer_id IN (
    SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

----4. order_details Table
--Admin: Full Access
CREATE POLICY "order_details: admin full access"
ON order_details
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'admin'
  )
);

--User: Only Read and Insert Items in Own order_details
CREATE POLICY "order_details: user can read own order_details"
ON order_details
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM orders
    WHERE orders.order_id = order_details.order_id
    AND orders.customer_id IN (
      SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
    )
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

CREATE POLICY "order_details: user can insert into own order_details"
ON order_details
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM orders
    WHERE orders.order_id = order_details.order_id
    AND orders.customer_id IN (
      SELECT customer_id FROM customer_auth_map WHERE user_uid = auth.uid()
    )
  )
  AND EXISTS (
    SELECT 1 FROM user_roles WHERE user_uid = auth.uid() AND role = 'user'
  )
);

---custom function that enforces admin-only access
CREATE OR REPLACE FUNCTION admin_generate_sales_report()
RETURNS TABLE (
  order_date DATE,
  total_sales_kes NUMERIC
)
LANGUAGE sql
AS $$
  SELECT
    o.order_date::DATE AS order_date,
    SUM(od.quantity * mi.price) AS total_sales_kes
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN menu_items mi ON od.item_id = mi.item_id
  GROUP BY o.order_date::DATE
  ORDER BY o.order_date::DATE;
$$;

