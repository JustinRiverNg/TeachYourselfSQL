SELECT *
FROM Products;

# Return 3 rows starting from Row 0:
SELECT prod_name
FROM Products
LIMIT 3
OFFSET 0;

# Also returns 3 rows starting from Row 0:
SELECT prod_name
FROM Products
LIMIT 0, 3;

# Sort by price then by name if price is tied:
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price, prod_name;

# Sort by price then by name if price is tied in descending order:
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC, prod_name DESC;

# Select all products from the vendor who's not 'DLL01':
SELECT vend_id, prod_name
FROM Products
WHERE vend_id <> 'DLL01';

# Select all products with product value between 5 and 10:
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 5 AND 10;

# Select all products with a NULL product price:
SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;

# All products from vendors 'DLL01' or 'BRS01' but has a product price >= 10:
SELECT prod_name, prod_price
FROM Products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01')
	AND prod_price >= 10;
    
/*
* This uses the IN operator to select products from vendors 'DLL01' or 'BRS01'.
* This accomplishes the same goal as the OR operator, but IN is more efficient.
*/
SELECT prod_name, prod_price
FROM Products
WHERE vend_id IN ('DLL01','BRS01');

# Select the products whose vendor id is not 'DLL01':
SELECT prod_name, prod_price, vend_id
FROM Products
WHERE NOT vend_id = 'DLL01';
# Another method:
SELECT prod_name, prod_price, vend_id
FROM Products
WHERE vend_id <> 'DLL01';

# Select all products that start with the board 'Fish':
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'Fish%';

# Select all products that contain the word 'bean bag':
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '%bean bag%';

# Select all products where there are exactly two characters before ' inch teddy bear':
# Notice this doesn't select '8 inch teddy bear' because it doesn't match the 2 wildcard requirement.
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '__ inch teddy bear';

# Select all products that do not contain 'bean bag' in their name:
SELECT prod_id, prod_name
FROM Products
WHERE NOT prod_name LIKE '%bean bag%';

# Concatenate vendor name and vendor country into one calculated field where
# vendor country is contained within parantheses. Use vend_title as the alias for this
# calculated column:
SELECT Concat(vend_name, ' (', vend_country, ')') AS vend_title
FROM Vendors
ORDER BY vend_name;

# Take all orders from order number 20008 and calculate the expanded price
# by multiplying quantity and item price. Give this an alias of expanded_price:
SELECT prod_id, quantity, item_price, quantity*item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;

# Return name of vendors in uppercase:
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;

# Return customers whose name sounds like 'Michael Green':
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

SELECT order_num
FROM Orders
WHERE YEAR (order_date) = 2012;

# Return the avg price of products offered by vendor 'DLL01':
# Can also find sum, min, max
SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

# Count the number of customer emails there are that are not NULL:
SELECT COUNT(cust_email) AS num_cust
FROM Customers;

# This gives the total price (for order number 20005) by multiplying 
# every item's price and their quantity,then summing it all together:
SELECT SUM(item_price*quantity) AS total_price
FROM OrderItems
WHERE order_num = 20005;

# Takes distinct product prices then averages them:
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

# Get the count of rows, max price, min price, and average price:
SELECT COUNT(*) AS num_items,
	MAX(prod_price) AS price_max,
    MIN(prod_price) AS price_min,
    AVG(prod_price) AS price_avg
FROM Products;

# Sorts the data and groups by vend_id then selects the vend_id and
# counts the number of rows of each vend_id:
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id
ORDER BY num_prods, vend_id;

# Groups by cust_id and counts the number each cust_id placed, but only selects
# those having greater than or equal to 2 orders:
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2
ORDER BY orders, cust_id;

# Lists all vendors who have 2 or more products priced at 4 or more:
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2
ORDER BY num_prods, vend_id;

# Count the number of items for each order number if the order number has 3 or more
# items in it, then order it by items:
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

# Get the customer ID of every customer who ordered the product with prod_id = 'RGAN01'
# by using a subquery:
SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num
					FROM OrderItems
					WHERE prod_id = 'RGAN01');

# Retrieve the customer information from every customer who ordered the product with
# prod_id = 'RGAN01'. This uses a subquery. Can also be done in a more efficient way, see (**A)
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
				  FROM Orders
				  WHERE order_num IN (SELECT order_num
									  FROM OrderItems
									  WHERE prod_id = 'RGAN01'));

# Retrieve the number of orders placed by every customer in the customer's table.
# This is done by comparing the customer ID in the Orders and Customers table then
# counting the total number of times each cust_id appears in Orders and creating this as a new
# table along with cust_name and cust_state:
SELECT cust_name, cust_state,
	(SELECT COUNT(*)
	FROM Orders
	WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;

# Joins a two tables to get the vendor name, product name, and product price of each product
# that is associated with a vendor in the vendor's table:
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;

# Above can also be written as:
SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
 ON Vendors.vend_id = Products.vend_id;
 
# Displays information on the items in order number 20007. This is an inner join.
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Products, Vendors
WHERE Products.vend_id = Vendors.vend_id
 AND OrderItems.prod_id = Products.prod_id
 AND order_num = 20007;
 
# (**A) Retrieve the customer information from every customer who ordered the product with
# prod_id = 'RGAN01'. This is an inner join.
SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
 AND OrderItems.order_num = Orders.order_num
 AND prod_id = 'RGAN01';

# Retrieves info from all customers who Jim Jones works for. This is done by
# first finding c2 whos cust_contact is 'Jim Jones' then comparing that to an identical
# table and retrieving the info from that table for each time that customer appears in c1.
# This is a self type of join usage.
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
 AND c2.cust_contact = 'Jim Jones';
 
# This uses a natural join to get all the info wanted, but doesn't double count the columns.
# It does this by using the wildcard * for the Customers table and then one-by-one asks for
# everything else that is wanted.
SELECT C.*, O.order_num, O.order_date,
		OI.prod_id, OI.quantity, OI.item_price
FROM Customers AS C, Orders AS O,
	OrderItems AS OI
WHERE C.cust_id = O.cust_id
 AND OI.order_num = O.order_num
 AND prod_id = 'RGAN01';
 
# Retrieve a list of all customers includeing those who have placed no orders.
# This uses an outer join which gets every row including empty rows. The left outer join means
# to specify the table on the left is the one to include all rows (Customers here).
SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
 ON Customers.cust_id = Orders.cust_id;
 
# Retrieve a list of all customers and the number of orders each has placed:
# This is done by using INNER JOIN to relate the Customers and Orders tables, then grouping
# the data by customers and using COUNT to count the number of order for each customer:
SELECT Customers.cust_id,
		COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
 ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

# Using union to select customer info from customers in Illinois, Milwaukee, or Minessota or
# customers from any Fun4All location, regardless of state:
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

# Insert a new customer into the Customers table:
INSERT INTO Customers(cust_id, cust_contact, cust_email, cust_name,
					cust_address, cust_city, cust_state, cust_zip)
VALUES('1000000006', NULL, NULL, 'Toy Land',
		'123 Any Street', 'New York', 'NY', '11111');

SELECT *
FROM Customers;