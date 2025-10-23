CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL, 
    city VARCHAR(50) NOT NULL
);
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL, 
    category VARCHAR(50) NOT NULL,
    is_available VARCHAR(3) NOT NULL 
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    order_type VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50) NOT NULL
);
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0), 
    unit_price DECIMAL(10, 2) NOT NULL
);
INSERT INTO customers (customer_id, first_name, last_name, phone_number, city) VALUES
(101, 'Alice', 'Johnson', '0722123456', 'Nairobi'),
(102, 'Bob', 'Smith', '0710987654', 'Mombasa'),
(103, 'Carol', 'Davis', '0733567890', 'Kisumu'),
(104, 'David', 'Lee', '0740234567', 'Nairobi'),
(105, 'Emma', 'Wilson', '0708876543', 'Nakuru'),
(106, 'Frank', 'Miller', '0791345678', 'Mombasa'),
(107, 'Grace', 'King', '0721456789', 'Eldoret');
INSERT INTO menu_items (item_id, item_name, price, category, is_available) VALUES
(201, 'Beef Samosa (2 pcs)', 150.00, 'Appetizer', 'Yes'),
(202, 'Pilau & Kachumbari', 450.00, 'Entree', 'Yes'),
(203, 'Ugali & Tilapia Fry', 600.00, 'Entree', 'Yes'),
(204, 'Hot Chips (Large)', 300.00, 'Side', 'Yes'),
(205, 'Cold Soda (300ml)', 100.00, 'Beverage', 'Yes'),
(206, 'Black Forest Cake Slice', 350.00, 'Dessert', 'No'),
(207, 'Fresh Mango Juice', 250.00, 'Beverage', 'Yes');
INSERT INTO orders (order_id, customer_id, order_date, total_amount, status, order_type, payment_method) VALUES
(3001, 101, '2024-10-13', 1050.00, 'Delivered', 'Delivery', 'M-Pesa'),
(3002, 104, '2024-10-13', 800.00, 'Ready for Pickup', 'Pickup', 'Cash'),
(3003, 103, '2024-10-12', 1800.00, 'Processing', 'Dine-in', 'Debit Card'),
(3004, 107, '2024-10-12', 300.00, 'Delivered', 'Delivery', 'M-Pesa'),
(3005, 102, '2024-10-11', 450.00, 'Canceled', 'Pickup', 'Credit Card'),
(3006, 105, '2024-10-11', 450.00, 'Pending', 'Dine-in', 'Debit Card'),
(3007, 106, '2024-10-11', 1200.00, 'Processing', 'Pickup', 'Cash');
INSERT INTO order_details (order_detail_id, order_id, item_id, quantity, unit_price) VALUES
(4001, 3001, 202, 1, 450.00),
(4002, 3001, 203, 1, 600.00),
(4003, 3002, 204, 1, 300.00),
(4004, 3002, 207, 2, 250.00),
(4005, 3003, 203, 3, 600.00),
(4006, 3004, 201, 2, 150.00),
(4007, 3006, 201, 3, 150.00);
