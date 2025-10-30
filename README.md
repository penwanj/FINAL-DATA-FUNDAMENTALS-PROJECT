# FINAL-DATA-FUNDAMENTALS-PROJECT
Final project

<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
- [💻 Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [DB Schema](#db-schema)
  - [Generate a mapping table](#generate-a-mapping-table)
  - [Generate a 'user_roles' table](#generate-a-'user_roles'-table)
  - [Row Level Security](#row-level-security)
  - [Policies](#policies)
  - [Roles](#roles)
  - [Custom Restricted Function](#custom-restricted-function)
  - [Usage](#usage)
  - [Security Enforcement](#security-enforcement)
- [👥 Authors](#authors)

<!-- PROJECT DESCRIPTION -->

# 📖 [Restaurant Ordering Database]
The purpose of this project is to implement user roles, admin privileges, and basic security rules. Thus, manage data access, enforce least privilege, and document the security setup.

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

-Supabase
-PostgreSQL

<!-- Features -->

### Key Features <a name="key-features"></a>

- **[Tables]**
- **[Schema]**
- **[Policies]**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

### Prerequisites

In order to run this project you need:

- [A Supabase account](https://supabase.com/)
- [Knowledge on SQL](https://www.w3schools.com/sql/)
- A schema for creating your tables in the DB
- Understanding how policies work

### Setup

Copy the contents of this Readme.md to your Project's file
OR
Clone this repository to your desired folder

### DB Schema

- The database schema is defined in `schema.sql`.
- Execute the provided sql statements to generate your tables and their records.
- The DB is made up of 4 tables, each table having 7 records. 
  
### Generate a mapping table
Create a `customer_auth_map` that links uuid from the auth system to the customer_id via;

CREATE TABLE customer_auth_map (
  user_uid UUID PRIMARY KEY,
  customer_id INT UNIQUE NOT NULL REFERENCES customers(customer_id)
);

### Generate a `user_roles` table 
This table assigns each user a role (`admin` or `user`)

Then, populate **user_roles** and **customer_auth_map** for each user.

### Row Level Security
Set up Supabase Auth 
Enable Row Level Security (RLS) on all tables.

### Policies
-Refer to the *RLS and Policies Applied.md* file for all policies applied
-Depending on what Admin and User priviledges are, policies were set via sql statements for the different tables accordingly.

-For example; to grant Admin full access to 'menu_items' table,

```sql
CREATE POLICY "menu_items: admin full access"
ON menu_items
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_uid = auth.uid() AND role = 'admin'
  )
);
```

-After applying all policies to the menu_items table, here is a screenshot of them (in supabase);
<img width="998" height="422" alt="image" src="https://github.com/user-attachments/assets/a6a7754e-035e-42b7-b47d-7908990900f4" />

### Roles
1. Admin
- Full access to all tables
- Can manage menu items, read all orders, update any order and generate daily sales reports

2. Regular User
- Can read and insert their own customer data
- Can place and read their own orders
- Can read menu_items but cannot modify them

### Custom Restricted Function
-An Admin-only Function has been employed that allows Admin(s) to generate daily sales reports in KES (Kenyan Shillings).
-This function is protected by Row Level Security and only accessible to users with the 'admin' role.

```sql
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
```

### Usage
This project supports two types of users: **Admins** and **Regular Users**.
1. Regular Users

- Sign up and log in via Supabase Auth.
- Automatically linked to a `customer_id` via the `customer_auth_map` table. Can;
  - View and update their customer profile
  - Browse menu items
  - Place new orders
  - View their own order history

2. Admins
- Assigned via the `user_roles` table with role `'admin'`. They can:
  - Manage all customer records
  - Add, update, or remove menu items
  - View all orders and order details

Admin(s) can generate daily sales reports using:

    ```sql
    SELECT * FROM admin_generate_sales_report();
    ```

### Security Enforcement

All access is controlled via **Row-Level Security (RLS)**

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

👤 **Peninah Wanjiru**

- GitHub: [@penwanj](https://github.com/penwanj)
- Twitter: [@PeninahWan96693](https://x.com/PeninahWan96693)
- LinkedIn: [@Peninah Wanjiru](www.linkedin.com/in/peninah-wanjiru-3b9900200)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
