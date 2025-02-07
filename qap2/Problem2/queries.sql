-- QAP 1 - Databases: Problem 2
-- Author: Noah Whiffen - SD12
-- Date: February 6th, 2025

-- This file contains all of my correct queries, I didn't include my mistakes but there were a few 

-- Created products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT,
    price DECIMAL,
    stock_quantity INT
);

-- Created customers table
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	email TEXT
); 

--- Created orders table
CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_date DATE
);

-- Created order_items table
CREATE TABLE order_items (
	order_id INT REFERENCES orders(order_id),
	product_id INT REFERENCES products(product_id),
	quantity INT,
	 PRIMARY KEY (order_id, product_id)
);

-- Added data to products table
INSERT INTO products (product_name, price, stock_quantity) VALUES
('Graphics Card', 700.00, 20),
('32Gb RAM', 99.99, 30),
('Motherboard', 250.99, 15),
('6TB Hard Drive', 400.00, 10),
('CPU', 380.65, 15);

-- Added data to customers table
INSERT INTO customers (first_name, last_name, email) VALUES
('Dean', 'Winchester', 'dean.winchester@example.com'),
('James', 'Wilson', 'jameswilson123@email.com'),
('Jesse', 'Pinkman', 'jessePinkman@keyin.com'),
('Ned', 'Stark', 'ned.stark@example.com'),
('Mary', 'Winchester', 'mary-winchester@email.com');

-- Added data to orders table
INSERT INTO orders (customer_id, order_date) VALUES
(
	(SELECT customer_id FROM customers WHERE first_name = 'Mary'),
	'2025-02-06'
),
(
	(SELECT customer_id FROM customers WHERE first_name = 'Dean'),
	'2025-02-01'
),
(
	(SELECT customer_id FROM customers WHERE last_name = 'Wilson'),
	'2025-01-31'
),
(
	(SELECT customer_id FROM customers WHERE first_name = 'Jesse'),
	'2025-01-26'
),
(
	(SELECT customer_id FROM customers WHERE first_name = 'Ned'),
	'2025-01-25'
);

-- Added data to order_items table
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(
	(SELECT order_id FROM orders WHERE customer_id = 5),
	(SELECT product_id FROM products WHERE product_id = 1),
	2
),
(
	(SELECT order_id FROM orders WHERE customer_id = 1),
	(SELECT product_id FROM products WHERE product_id =  3),
	1
),
(
	(SELECT order_id FROM orders WHERE customer_id = 2),
	(SELECT product_id FROM products WHERE product_id = 5),
	1
),
(
	(SELECT order_id FROM orders WHERE customer_id = 3),
	(SELECT product_id FROM products WHERE product_id = 1),
	1
),
(
	(SELECT order_id FROM orders WHERE customer_id = 4),
	(SELECT product_id FROM products WHERE product_id = 4),
	3
);

-- Retrieve names and stock quantities of all products
SELECT products.product_name, stock_quantity FROM products;

-- Retrieve the product names and quantities for one of the orders placed
SELECT products.product_name, order_items.quantity FROM orders
	JOIN order_items ON orders.order_id = order_items.order_id
	JOIN products ON order_items.product_id = products.product_id
	WHERE orders.order_id = 1;

-- Retrieve all orders placed by a specific customer (including product_id and quantities)
SELECT order_items.order_id, order_items.product_id, order_items.quantity FROM order_items
	JOIN orders ON order_items.order_id = orders.order_id
	WHERE orders.customer_id = 1;

-- Perform an update to reduce stock after a customer places an order (indicate which order you are simlating)
UPDATE products
		SET stock_quantity = stock_quantity - 1
		WHERE product_id = 5 -- I am reducing the stock of CPUS (product_id = 5) by 1 because James Wilson (customer_id = 2) ordered 1

-- Delete one order and all associated order items
DELETE FROM order_items WHERE order_id = 1; -- Deleted from order_items first due to foreign key dependency
DELETE FROM orders WHERE customer_id = 5;