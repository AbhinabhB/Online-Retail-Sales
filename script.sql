create database virtusa_practice;
use virtusa_practice;

create table customers (
	customer_id int primary key,
    name varchar(100),
    city varchar(50)
);

create table products (
	product_id int primary key,
    name varchar(100),
    category varchar(50),
    price decimal(10, 2)
);

create table orders (
	order_id int primary key,
    customer_id int,
    date date,
    foreign key(customer_id) references customers(customer_id)
);

create table order_items (
	order_id int,
    product_id int,
    quantity int,
    foreign key(order_id) references orders(order_id),
    foreign key(product_id) references products(product_id)
);

show tables;

insert into customers values
(1, 'rahul', 'delhi'),
(2, 'priya', 'mumbai'),
(3, 'amit', 'bangalore'),
(4, 'neha', 'chennai'),
(5, 'arjun', 'kolkata'),
(6, 'sneha', 'delhi'),
(7, 'vikas', 'pune'),
(8, 'kiran', 'hyderabad'),
(9, 'meena', 'jaipur'),
(10, 'rohit', 'lucknow');

insert into products values
(101, 'laptop', 'electronics', 60000),
(102, 'phone', 'electronics', 30000),
(103, 'headphones', 'electronics', 2000),
(104, 'shirt', 'clothing', 1500),
(105, 'jeans', 'clothing', 2500),
(106, 'shoes', 'footwear', 3000),
(107, 'watch', 'accessories', 5000),
(108, 'bag', 'accessories', 2000),
(109, 'tablet', 'electronics', 25000),
(110, 'jacket', 'clothing', 4000);

insert into orders values
(1001, 1, '2024-01-10'),
(1002, 2, '2024-01-15'),
(1003, 3, '2024-02-05'),
(1004, 1, '2024-02-20'),
(1005, 4, '2024-03-12'),
(1006, 5, '2024-03-18'),
(1007, 6, '2024-04-01'),
(1008, 7, '2024-04-10'),
(1009, 8, '2024-05-05'),
(1010, 2, '2024-05-20');

insert into order_items values
(1001, 101, 1),
(1001, 103, 2),

(1002, 102, 1),
(1002, 104, 3),

(1003, 105, 2),
(1003, 103, 1),

(1004, 101, 1),
(1004, 106, 1),

(1005, 107, 2),

(1006, 108, 3),
(1006, 104, 1),

(1007, 109, 1),

(1008, 106, 2),
(1008, 105, 1),

(1009, 102, 1),

(1010, 103, 4),
(1010, 110, 1);


delimiter //
create procedure GetTopSellingProducts()
begin
	select p.name, sum(oi.quantity) as total_sold
    from order_items oi
    join
    products p on oi.product_id = p.product_id
    group by p.product_id, p.name
    order by total_sold desc;
end //


delimiter // 
create procedure GetMostValuableCustomers()
begin
	select c.customer_id, c.name, sum(p.price * oi.quantity) as total_spent
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_items oi on oi.order_id = o.order_id
    join products p on p.product_id = oi.product_id
    group by c.customer_id, c.name
    order by total_spent desc;
end //


delimiter //
create procedure GetMonthlyRevenue()
begin
	select year(o.date) as year, month(o.date) as month, sum(p.price * oi.quantity) as revenue
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on p.product_id = oi.product_id
    group by year(o.date), month(o.date)
    order by year, month;
end //


delimiter // 
create procedure GetCategorySales()
begin
	select p.category, sum(p.price * oi.quantity) as total_sales
    from products p
    join order_items oi on oi.product_id = p.product_id
    group by p.category
    order by total_sales desc;
end //


delimiter // 
create procedure GetInactiveCustomers()
begin
	select c.customer_id, c.name
    from customers c
    left join orders o on c.customer_id = o.customer_id
    where o.order_id is null;
end //

delimiter ;


call GetTopSellingProducts();
call GetMostValuableCustomers();
call GetMonthlyRevenue();
call GetCategorySales();
call GetInactiveCustomers();