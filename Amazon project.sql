use amazon;
select * from amazon_prime_users;
rename table amazon_prime_users to amazon;
select * from amazon;
alter table amazon
rename column `User ID` to User_ID;
alter table amazon
rename column `Email Address` to Email_Address;
alter table amazon
rename column `Date of Birth` to Date_of_birth;
alter table amazon
rename column `Start_Date` to Membership_Start_Date;
alter table amazon
rename column `Membership_End_Address` to Membership_End_Date;
alter table amazon
rename column `Subscription Plan` to Subscription_plan;
alter table amazon
rename column `Payment Information` to Payment_Information;
alter table amazon
rename column `Renewal Status` to Renewal_Status;
alter table amazon
rename column `Usage Frequency` to Usage_Frequency;
alter table amazon
rename column `Purchase History` to Purchase_History;
alter table amazon
rename column `Favorite Genres` to Favorite_Genres;
alter table amazon
rename column `Devices Used` to Devices_Used;
alter table amazon
rename column `Engagement Metrics` to Engagement_Metrics;
alter table amazon
rename column `Feedback/Ratings` to Ratings;
alter table amazon
rename column `Customer Support Interactions` to Customer_Support_Interactions;

set sql_safe_updates=0;
set autocommit=off;

select * from amazon;
update amazon
set Date_of_birth = str_to_date(Date_of_birth,"%Y-%m-%d")
where Date_of_birth is not null;

alter table amazon
modify column Date_of_birth date;

update amazon
set Membership_Start_Date = str_to_date(Membership_Start_Date,"%Y-%m-%d")
where Membership_Start_Date is not null;

alter table amazon
modify column Membership_Start_Date date;

select * from amazon;
update amazon
set Membership_End_Date = str_to_date(Membership_End_Date,"%Y-%m-%d")
where Membership_End_Date is not null;

alter table amazon
modify column Membership_End_Date date;
commit;
#Tạo cột mới tính tuổi khách hàng
alter table amazon
add column Age int
after date_of_birth;

update amazon
set age=timestampdiff(Year,Date_of_birth,current_date());

#Customers by locations
select Location, count(user_id) from amazon
group by location
order by 2 desc;

#Gender distribution
select gender, count(user_id) from amazon
group by gender;

select *from amazon;
#Age distribution
select case 
	when age <18 then"Under 18"
    when age <30 then "18-30"
    when age <45 then "30-45"
    when age <60 then "45-60"
    else "60+"
end as age_range, count(user_id) as user_count
from amazon
group by age_range
order by 2 desc;
 
#Top favortie genres
select favorite_genres, count(user_id) as user_count from amazon
group by 1
order by 2 desc;

#Proportion of subscription plan 
select subscription_plan, user_count, round((user_count/total_users)*100,2) as percentage
from (
select subscription_plan,
  count(user_id) as user_count,
  (select count(user_id) from amazon) as total_users
from amazon
group by 1) as sub
group by 1
order by 2,3;
commit;

#Customer types distribution
select usage_frequency,count(user_id) as user_count from amazon
group by 1;

#Payment method distribution
select payment_information,count(user_id) as user_count from amazon
group by 1; 

#Average customer's ratings
select round(avg(ratings),0) as Average_Rating from amazon ;

#Total customer support 
select sum(Customer_support_interactions) as Total_Support from amazon;

#Top products 
select purchase_history, count(user_id) from amazon 
group by 1;


