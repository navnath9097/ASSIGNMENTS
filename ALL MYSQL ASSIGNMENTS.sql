/* assignment no 1 (a) */
select * from employees;
select employeeNumber, firstName, lastName from employees where 
jobTitle = "Sales Rep" and reportsTo = 1102;

/* assignment no 1 (b) */

select * from products;
select distinct productLine from products where productLine like "%cars";

/* assignment no 2 */
 
 select * from customers;
select customerNumber, customerName,
case 
when country in ('USA', 'Canada') then 'North America'
when country in ('UK', 'France', 'Germany') then 'Europe'
else 'other'
end as Customersegment
from customers;

/* assignment no 3 (a) */
select * from orderdetails;
select ProductCode, sum(quantityOrdered) as total_ordered from 
orderdetails group by productCode order by total_ordered desc 
limit 10;

/* assignment no 3 (b) */
select * from payments;
desc payments;
select monthname(paymentDate) as payment_month, count(*) as num_payments
from payments
Group by payment_month
having  num_payments > 20
order by 
num_payments DESC;

/* assignment no 4 (a) */

create table customer22(custo_id int AUTO_INCREMENT primary key, custo_firstname varchar(50) NOT NULL, custo_lastname varchar(50) NOT NULL, email varchar(255) unique, phone_number varchar(20));
select * from customer22;
desc customer22;
select * from customer22;
insert into customer22 values(1, "ravi", "lande", "ravilande@gmail.com", "6472482324");
insert into customer22 values(2, "prachi", "wagh", "prachiwagh@gmail.com", "4356859876");
insert into customer22 values(3, "amey", "deshmukh", "amey@gmail.com", "9011546745");
insert into customer22 values(4, "pratik", "raut", "pratikraut@gmail.com", "7447569834");
select * from customer22;

/* assignment no 4 (b) */

create table customer99(customer_id int AUTO_INCREMENT primary key, first_name varchar(50), last_name varchar(50), email varchar(255) unique, phone_no varchar(20));
select * from customer99;
create table orders99(order_id int AUTO_INCREMENT primary key, order_date date, total_amount decimal(10,2));
select * from orders99;

alter table orders99 add column custo_id int;
select * from orders99;
alter table orders99 add constraint adding_fkkey  foreign key(custo_id) references customer99(customer_id);
 desc orders99;
 
 insert into customer99 values(100, "sanket", "shinde", "shindesanket@gail.com", "9595763410");
 insert into customer99 values(101, "Ravi", "Patil", "ravipatil@gail.com", "9595763560");
 insert into customer99 values(102, "shrutika", "wagh", "waghshrutika@gail.com", "9595769010");
 insert into customer99 values(103, "pooja", "ghode", "poojaghode@gail.com", "9595764510");
 select * from customer99;
 
 insert into orders99 values(1, "2024-07-29", 5000, 100);
 insert into orders99 values(2, "2024-07-29", 6000, 101);
 insert into orders99 values(3, "2024-07-29", 70000, 102);
 insert into orders99 values(4, "2024-07-29", 10000, 103);
 
 select * from orders99;
 
 alter table orders99
 add constraint check_positive_total_amount
 check (total_amount > 0);
 
 select * from orders99;
 
 /* assignment no 5 */
 
 select * from customers;
select * from orders;
select customers.country, count(orders.orderNumber) as order_count from customers
join orders
on customers.customerNumber = orders.customerNumber
group by customers.country
order by order_count desc
limit 5;

 /* assignment no 6 */
 create table project41(EmployeeID int primary key auto_increment, FullName varchar(50) not null, Gender char(6), ManagerID int);
desc project41;

insert into project41 values(1, 'Pranaya', 'Male', 3);
insert into project41 values(2, 'Priyanka', 'Female', 1);
insert into project41 values(3, 'Preety', 'Female', Null);
insert into project41 values(4, 'Anurag', 'Male', 1);
insert into project41 values(5, 'Sambit', 'Male', 1);
insert into project41 values(6, 'Rajesh', 'Male', 3);
insert into project41 values(7, 'Hina', 'Female', 3);


SELECT * FROM project41;
SELECT p.FullName AS "Manager name", e.FullName AS "Emp Name"
FROM project41 P
LEFT JOIN  project41 e
on
p.Employeeid = e.ManagerID;

/* assignment no 7 */

create table facility(facility_id int, name varchar(50), state varchar(10), country varchar(10));
select * from facility;
desc facility;
alter table facility
modify column facility_id int AUTO_INCREMENT,
add primary key(facility_id);
select * from facility;
desc facility;
alter table facility
add column city varchar(255) not null after name;
desc facility;

/* assignment no 8 */

select * from products;
select * from productlines;
select * from orders;
select * from orderdetails;

CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS category_name,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    ProductLines pl
JOIN 
    Products p ON pl.productLine = p.productLine
JOIN 
    OrderDetails od ON p.productCode = od.productCode
JOIN 
    Orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
    
    SELECT * FROM product_category_sales;

/* assignment no 9 */

call classicmodels.Get_country_payments1(2003, 'france');

/* assignment no 10 (a) */


select * from customers;
select * from orders;

select customers.customerName, 
       count(orders.orderNumber) as order_count, 
       rank() over(order by count(orders.orderNumber) desc) as order_frequency_rnk 
from customers 
left join orders
on customers.customerNumber = orders.customerNumber
group by customerName
order by order_frequency_rnk;

/* assignment no 10 (b) */

select * from orders;
WITH orderCounts as(
select 
      YEAR(orderDate) AS Year,
      MONTHNAME(orderDate) AS Month,
      COUNT(orderNumber) AS order_count
      from 
          orders
      GROUP BY
             YEAR,
             MONTH

) ,
RankedOrderCounts AS(
SELECT 
      Year,
      month,
      order_count,
      LAG(order_count, 1) OVER (PARTITION BY Month ORDER By Year) AS prev_year_order_count
      FROM
         OrderCounts
         
)
SELECT 
     Year,
     Month,
     order_count,
     concat(
           CASE 
               WHEN	prev_year_order_count IS NULL THEN 'N/A'
               ELSE FORMAT ((order_count - prev_year_order_count) * 100.0 / prev_year_order_count, 0)
               END,
               '%'
               ) AS '%YoY change'
               FROM
                   RankedOrderCounts
             ORDER BY
                    Year,
                    FIELD(Month, 'January', 'February', 'March', 'April', 'May', 'June',
                    'Jully', 'August', 'September', 'October', 'November', 'December');
                    
                   
     
	/* assignment no 11 */
    
    select * from products;
select productLine, count(*) as Total from products
where buyprice > (select avg(buyprice) from products)
group by productLine;

/* assignment no 12 */

call classicmodels.AddEmployee(5, 'navnath', 'navnath@gmail.com');

/* assignment no 13 */

create table Emp_BIT3(Name varchar(255), Occupation varchar(255), Working_date date, Working_hours int);
desc emp_bit;

Insert into Emp_BIT values('Robin', 'Scientst', '2020-10-04', 12),
						  ('Warner', 'Engineer', '2020-10-04', 10),
                          ('Peter', 'Actor', '2020-10-04', 13),
                          ('Marco', 'Doctor', '2020-10-04', 14),
                          ('Brayden', 'Teacher', '2020-10-04', 12),
                          ('Antonio', 'Business', '2020-10-04', 11);
                          
select * from emp_bit;

/* inserting a negative working hours */
insert into emp_bit value('John Doe', 'IT', '2020-10-04', -10);
insert into emp_bit value('Bob', 'Software Engineer', '2020-10-04', -9);
select * from emp_bit;



