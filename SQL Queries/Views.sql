/* Creating View to answer Question a*/
create view WineSales as
select t.Year, fs.Store_ID, fs.Fact_CategorySales_ID, fs.Category_Sales, 
DENSE_RANK() OVER (partition by fs.Store_ID,fs.Time_ID ORDER BY fs.Fact_CategorySales_ID) Day_of_Week
from factCategorySales fs join dimTime t on fs.Time_ID = t.Time_ID where 
fs.Category_ID = (select Category_ID from dimCategory where Category_name = 'WINE') and 
fs.Time_ID in (select Time_ID from dimTime where Special_Event = 'Thanksgiving')

create view ThanksgivingSales as
select Year, Day_of_Week, sum(Category_Sales) as ThanksgivingSales from WineSales
group by  Day_of_Week, Year

/*Creating View to answer Ques b*/
create view AvgFishSales as
select avg(fs.Category_sales) as AverageFishSales ,t.Zone from factCategorySales fs join
dimStore t on fs.Store_ID = t.Store_ID join dimTime s on fs.Time_ID = s.Time_ID where
Category_ID = (select Category_ID from dimCategory where Category_name = 'FISH') and
s.year > 1995
group by t.Zone

/*Creating View to answer Ques c*/
create view SaleCodeAnalysis as
select ps.sale_code, s.Zone, sum(ps.Number_of_units_sold) as Quantity_Sold from factProductSales ps join dimStore s 
on ps.Store_ID = s.Store_ID  where ps.sale_code in ('S', 'B')
group by s.Zone,ps.Sale_code

/*Creating View to answer Ques d*/
create view CerealSales as
select s.Price_tier, sum(Product_sales) as CerealSales from factProductSales fs join dimStore s on fs.Store_ID = s.Store_ID
where Product_ID in (select Product_ID from dimProduct where TYPE = 'CEREALS')   
group by s.Price_tier

/*Creating View to answer Question e*/
create view CameraSales as
select sum(fs.Category_sales) as CameraSales ,t.Year from factCategorySales fs join dimTime t on fs.Time_ID = t.Time_ID where
Category_ID = (select Category_ID from dimCategory where Category_name = 'CAMERA') and 
t.Year >1989 and t.Year <1997 
group by t.Year 

/*Creating View to answer Ques f*/
create view MeatSales as
select sum(fs.Category_sales) as MeatSales ,t.Month,t.year from factCategorySales fs join dimTime t on fs.Time_ID = t.Time_ID where
Category_ID = (select Category_ID from dimCategory where Category_name = 'MEAT') and 
t.Year >1993 and t.Year<1997
group by t.Month,t.year

/**Creating View to answer Ques g**/
create view PharmacySales as
select sum(fs.Category_sales) as PharmacySales ,t.Store_name from factCategorySales fs join
dimStore t on fs.Store_ID = t.Store_ID where
Category_ID = (select Category_ID from dimCategory where Category_name = 'PHARMACY') 
and t.[Percent over 60 years] > (select avg([Percent over 60 years]) from dimStore)
group by t.Store_name 

/*Creating View to answer Ques h*/
create view SoftDrinksAvgProfit as
select avg(ps.Profit_per_dollar) as AvgProfit, s.Store_name from factProductSales ps join dimStore s 
on ps.Store_ID = s.Store_ID where ps.Product_ID in (select Product_ID from dimProduct where TYPE = 'SOFT DRINKS')
group by s.Store_name  
