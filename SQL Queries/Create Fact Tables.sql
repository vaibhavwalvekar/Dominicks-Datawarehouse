/*Creating Fact Table for Product Sales Datamart*/
CREATE TABLE [dbo].[factProductSales](
[Fact_ProductSales_ID] [int] IDENTITY(1,1) NOT NULL,
[Product_ID] [int] NOT NULL,
[Store_ID] [int] NOT NULL,
[Week] [float] NULL, 
[Unit_price] [float] NULL,
[Quantity] [int] NULL,
[Number_of_units_sold] [int] NULL,
[Profit_per_dollar] [float] NULL,
[Sale_code] [varchar](50) NULL,
[Product_sales] [float] NULL,
PRIMARY KEY ([Fact_ProductSales_ID]),
FOREIGN KEY ([Product_ID]) REFERENCES dimProduct([Product_ID]),
FOREIGN KEY ([Store_ID]) REFERENCES dimStore([Store_ID])
)

/*Loading Fact Table for Product Sales Datamart*/
Insert into [dbo].[factProductSales] ([Product_ID], [Store_ID], [Week],[Unit_price], [Quantity],
[Number_of_units_sold],[Profit_per_dollar],[Sale_code], [Product_sales])
select p.[Product_ID], s.[Store_ID], [WEEK],[Unit_price],[Quantity],[Number_of_units_sold],
[Profit_per_dollar], [Sale_code], [Product_sales] from [ProductStaging] ps join dimProduct p 
on ps.UPC_number= p.UPC_Number
join dimStore s on ps.Store = s.Store_number 
where ps.[Number_of_units_sold] >0

/*Creating Fact Table for Category Sales Datamart*/
CREATE TABLE [dbo].[factCategorySales](
[Fact_CategorySales_ID] [int] IDENTITY(1,1) NOT NULL,
[Time_ID] [int] NOT NULL,
[Category_ID] [int] NOT NULL,
[Store_ID] [int] NOT NULL,
[Category_sales] [float] NULL,
PRIMARY KEY ([Fact_CategorySales_ID]),
FOREIGN KEY ([Time_ID]) REFERENCES dimTime([Time_ID]),
FOREIGN KEY ([Store_ID]) REFERENCES dimStore([Store_ID]),
FOREIGN KEY ([Category_ID]) REFERENCES dimCategory([Category_ID]))

/*Loading Fact Table for Category Sales Datamart*/
Insert into [dbo].[factCategorySales] ([Time_ID], [Category_ID], [Store_ID], [Category_sales]) 
select t.[Time_ID],c.[Category_ID],s.[Store_ID], stc.[SalesAmount] from [dbo].[StagingTransformedCCount] stc join
dimTime t on stc.[WEEK] = t.[Week_Number] join dimStore s on stc.[STORE] = s.[Store_number] join dimCategory c on
stc.[Category] = c.[Category_name]