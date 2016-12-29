/*Creating Time Dimension*/
CREATE TABLE [dbo].[dimTime](
[Time_ID] [int] IDENTITY(1,1) NOT NULL,
[Year] [int] NULL,
[Month] [int] NULL,
[Week_Number] [int] NULL,
[Special_Event] [varchar](50) NULL,
CONSTRAINT [PK_dimTime] PRIMARY KEY CLUSTERED
(
[Time_ID] ASC
))
/*Populating Time Dimension*/
Insert into [dbo].[dimTime] ([Year],[Month],[Week_Number],[Special_Event] ) 
select year([StartDate]),month([StartDate]),[Week_Number],[Special Events] from [dbo].[Staging_Weekly_Decode]

/*Creating Store Dimension*/
CREATE TABLE [dbo].[dimStore](
[Store_ID] [int] IDENTITY(1,1) NOT NULL,
[Store_number] [int] NULL,
[Store_name] [nvarchar](50) NULL,
[Store_city] [varchar](50) NULL,
[Price_tier] [varchar](50) NULL,
[Zone] [int] NULL,
[Percent over 60 years] [float] NULL
CONSTRAINT [PK_dimStore] PRIMARY KEY CLUSTERED
(
[Store_ID] ASC
))

/*Populating Store Dimension*/
Insert into [dbo].[dimStore] ([Store_number], [Store_name], [Store_city], [Price_tier], [Zone], [Percent over 60 years] ) 
select [Store_Number],[Store_Name],[City],[Price_tier],[Zone], [Percent over 60 years] from [dbo].[Staging_Store_Demographics]

/*Creating Product Dimension*/
CREATE TABLE [dbo].[dimProduct](
[Product_ID] [int] IDENTITY(1,1) NOT NULL,
[UPC_Number] [bigint] NULL,
[Product_Name] [varchar](50) NULL,
[Type] [nvarchar](20) NULL,
CONSTRAINT [PK_dimProduct] PRIMARY KEY CLUSTERED
(
[Product_ID] ASC
))

/*Populating Product Dimension*/
Insert into [dbo].[dimProduct] ([UPC_Number],[Product_Name], [Type]) 
select [UPC],[Product_Name], [Type] from [dbo].[Staging_UPCANA]
union
select [UPC],[Product_Name], [Type] from [dbo].[Staging_UPCSDR]
union
select [UPC],[Product_Name], [Type] from [dbo].[Staging_UPCCER]

/*Creating Category Dimension*/
CREATE TABLE [dbo].[dimCategory](
[Category_ID] [int] IDENTITY(1,1) NOT NULL,
[Category_name] [nvarchar](255) NULL,
CONSTRAINT [PK_dimCategory] PRIMARY KEY CLUSTERED
(
[Category_ID] ASC
))

/*Inserting only relevant categories which are pertaining to our questions*/
insert into [dimCategory] ([Category_name]) values ('FISH')
insert into [dimCategory] ([Category_name]) values ('MEAT')
insert into [dimCategory] ([Category_name]) values ('CAMERA')
insert into [dimCategory] ([Category_name]) values ( 'WINE')
insert into [dimCategory] ([Category_name]) values ('PHARMACY')

/*Transforming Staging_CCOUNT table for data to be represented in usable format*/
SELECT   [STORE], [WEEK], [Category], [SalesAmount] into StagingTransformedCCount
FROM [dbo].[Staging_CCOUNT]
UNPIVOT
(
       [SalesAmount]
       FOR [Category] IN ([FISH] , [MEAT], [CAMERA], [WINE], [PHARMACY])
) AS P


