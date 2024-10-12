-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders

-- Calculate the total revenue generated from pizza sales.

Select 
round(sum(order_details.quantity*pizzas.price)::numeric,2) as total_revenue
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id

-- Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.

select quantity, count (order_details_id)
from order_details group by quantity

select pizzas.size, count(order_details.order_details_id)as order_count
from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size order by order_count desc limit 1;

select* from order_details

-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.name order by quantity desc limit 5 ;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.category order by quantity desc limit 5 ;


-- Determine the distribution of orders by hour of the day.

SELECT 
    EXTRACT(HOUR FROM order_time) AS hour,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    EXTRACT(HOUR FROM order_time);
	
	
-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)from
(select orders.order_date,sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
select  pizza_types.name, 
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / 
    (SELECT SUM(order_details.quantity * pizzas.price) 
     FROM order_details 
     JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id))*100 AS revenue_percentage
FROM 
    pizza_types 
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue_percentage DESC;
	
	
-- Analyze the cumulative revenue generated over time.
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity*pizzas.price)as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity)*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn<=3;













