CREATE Table orders
(
order_id int NOT NULL,
order_date date NOT NULL,
order_time time NOT NULL,
primary key(order_id)
);
Select *From orders





CREATE Table order_details
(
order_details_id int NOT NULL,
order_id  int NOT NULL,
pizza_id text NOT NULL,
quantity int NOT NULL,
primary key(order_details_id)
	
);

Select *From order_details








CREATE Table pizzas
(
pizza_id text NOT NULL,
pizza_type_id text NOT NULL,
size char(5) NOT NULL,
price Real NOT NULL,
primary key(pizza_id)
);
Select* From pizzas


CREATE table pizza_types
(
pizza_type_id text NOT NULL,
name text NOT NULL,
category text NOT NULL,
ingredients text NOT NULL,
PRIMARY KEY (pizza_type_id) 	
);
 
 SELECT* FROM pizza_types

