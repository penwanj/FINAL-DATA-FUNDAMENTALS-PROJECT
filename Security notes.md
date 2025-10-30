Security Notes for Restaurant Ordering Database
-This document describes breakdown of how security system is designed and protected including role-based access control, row-level security, and custom functions.

Authentication & Role Management
-‘Supabase Auth’ has been used to authenticate users via UUIDs.
- A custom `user_roles` table maps each `user_uid` to a role: ‘admin’ or ‘user’.
- A `customer_auth_map` table links `user_uid` to `customer_id` for identity resolution.

Row-Level Security (RLS)
RLS is enabled on all four tables to enforce access control:

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

Access Policies by Table
'customers' table
-Admin: Full access
-User: Can only read and insert their own customer record

'menu_items' table
-Admin: Full access 
-User: Read-only access

'orders' table
-Admin: Full access
-User: Can only read and insert their own orders

'order_details' table
-Admin: Full access
-User: Can only read and insert items in their own orders

Custom Function---Sales’ report generation by Admin
-Returns total daily sales in KES.
-Accessible only to admins due to RLS enforcement

Unauthorized Access Prevention
-All policies use auth.uid to verify identity
-Role checks are performed via 'user_roles' table(‘Admin’ or ‘User’).
-Ownership checks are enforced via ‘customer_auth_map’ table.

In Summary, the setup ensures
-Only authenticated users can access data
-Admins have full control
-Regular users can only access their own records
-Sensitive operations are encapsulated in secure customized functions

