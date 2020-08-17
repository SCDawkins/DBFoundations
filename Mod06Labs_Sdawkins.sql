--*************************************************************************--
-- Title: Mod06Labs
-- Author: SDawkins
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2020-08-11,SDawkins,Created File
-- 2020-08-12, Sdawkins, Answering Questions
-- 
--**************************************************************************--

Create Database Mod06Labs_Sdawkins;
go

Use Mod06Labs_Sdawkins;
go

Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;
go


Select * From  Northwind.dbo.Customers
go

--------------------------------------Lab 1: Creating Reporting View -----------------------------------------

--Question 1: How can you create a view to show a list of customer names and their locations? 
--Use the IsNull() function to display null region names as the name of the customer's country? Call the view vCustomersByLocation.

--Select [CustomerName] = CompanyName , City, [Region] = IsNull(Region, Country), Country
--From Northwind.dbo.Customers
--Order by CompanyName
--Go


Create 
View vCustomersByLocation
AS 
  Select 
    [CustomerName] = CompanyName , 
	City, [Region] = IsNull(Region, Country), 
	Country
  From Northwind.dbo.Customers
Go

Select * From vCustomersByLocation Order By CustomerName;

---------------------------------------------------------------------------------------------
--Question 2: How can you create a view to show a list of customer names, their locations, and the number of orders they have placed (hint: use the count() function)? 
--Call the view vNumberOfCustomerOrdersByLocation.

Go
Create 
View vNumberOfCustomerOrdersByLocation
AS 
  Select 
     [CustomerName] = CompanyName , 
	 City, [Region] = IsNull(Region, Country), 
	 Country, 
	 [NumberofOrders] = Count(OrderID)
  From Northwind.dbo.Customers As C
  Join Northwind.dbo.Orders As O
  On C.CustomerID = O.CustomerID
  Group By CompanyName, City, IsNull(Region, Country), Country;
Go

Select * From vNumberOfCustomerOrdersByLocation Order By CustomerName

--Question 3: How can you create a view to shows a list of customer names, 
--their locations, and the number of orders they have placed (hint: use the count() function) on a given year (hint: use the year() function)? 
--Call the view vNumberOfCustomerOrdersByLocationAndYears.

Go
Create 
View vNumberOfCustomerOrdersByLocationAndYears
As 
  Select    
	[CustomerName] = CompanyName, 
    City, [Region] = IsNull(Region, Country), 
	Country, 
	[NumberofOrders] = Count(OrderID),
	[YearofOrder] = Year(OrderDate)
  From Northwind.dbo.Customers As C
  Join Northwind.dbo.Orders As O
  On C.CustomerID = O.CustomerID
  Group By CompanyName, City, IsNull(Region, Country), Country, Year(OrderDate)
Go

Select * From vNumberOfCustomerOrdersByLocationAndYears Order By CustomerName, YearofOrder;

--------------------------------------Lab 2: Creating Reporting Function -----------------------------------------

--In this lab, you create reporting functions using the code you created in lab 1. 
--Step 1: Complete Lab 1
--You must complete lab 1 before you continue with this lab.
--Step 2: Copy and Convert
--Using the same Select code you created lab1, create three functions in the Mod06LabsYourNameHere database (using your own name, of course!) 

Create Function dbo.fCustomersByLocation()
 Returns Table 
 As 
 Return 
  (Select [CustomerName] = CompanyName , City, [Region] = IsNull(Region, Country), Country
  From Northwind.dbo.Customers);

Select * From dbo.fCustomersByLocation() Order By CustomerName;

------------------------------------------------------------------------------

Create Function dbo.fNumberOfCustomerOrdersByLocation()
Returns Table 
 As 
  Return 
    (Select [CustomerName] = CompanyName , City, 
	        [Region] = IsNull(Region, Country), 
			Country, 
			[NumberofOrders] = Count(OrderID)
     From Northwind.dbo.Customers As C
         Join Northwind.dbo.Orders As O
         On C.CustomerID = O.CustomerID
    Group By CompanyName, City, IsNull(Region, Country), Country);
Go

Select * From dbo.fNumberOfCustomerOrdersByLocation() Order By CustomerName;
 
---------------------------------------------------------------------------

Create Function dbo.fNumberOfCustomerOrdersByLocationAndYears()
Returns Table 
As 
Return 
     (Select [CustomerName] = CompanyName, 
         City, [Region] = IsNull(Region, Country), 
		 Country, [NumberofOrders] = Count(OrderID),
		 [YearofOrder] = Year(OrderDate)
      From Northwind.dbo.Customers As C
       Join Northwind.dbo.Orders As O
       On C.CustomerID = O.CustomerID
      Group By CompanyName, City, IsNull(Region, Country), Country, Year(OrderDate));
Go


Select * From dbo.fNumberOfCustomerOrdersByLocationAndYears() Order By CustomerName, YearOfOrder;

----------------------------------- Lab 3: Creating Reporting Stored Procedures -----------------------------------------------
--In this lab, you create reporting stored procedures using the code you created in lab 1. 
--Step 1: Complete Lab 1
--You must complete lab 1 before you continue with this lab.
--Step 2: Copy and Convert
--Using the same Select code you created lab1, create three stored procedures in the 
--Mod06LabsYourNameHere database (using your own name, of course!) 


Create Procedure pCustomersByLocation
AS 
  Select 
    [CustomerName] = CompanyName , 
	City, [Region] = IsNull(Region, Country), 
	Country
  From Northwind.dbo.Customers
Go

Exec pCustomersByLocation;
Go
 
 ----------------------------------------

Create Proc pNumberOfCustomerOrdersByLocation
As
  Select 
     [CustomerName] = CompanyName , 
	 City, [Region] = IsNull(Region, Country), 
	 Country, 
	 [NumberofOrders] = Count(OrderID)
  From Northwind.dbo.Customers As C
  Join Northwind.dbo.Orders As O
  On C.CustomerID = O.CustomerID
  Group By CompanyName, City, IsNull(Region, Country), Country;
Go

Exec pNumberOfCustomerOrdersByLocation;
Go
 
 ------------------------------------------

Create Proc dbo.pNumberOfCustomerOrdersByLocationAndYears
As 
  Select    
	[CustomerName] = CompanyName, 
    City, [Region] = IsNull(Region, Country), 
	Country, 
	[NumberofOrders] = Count(OrderID),
	[YearofOrder] = Year(OrderDate)
  From Northwind.dbo.Customers As C
  Join Northwind.dbo.Orders As O
  On C.CustomerID = O.CustomerID
  Group By CompanyName, City, IsNull(Region, Country), Country, Year(OrderDate);
Go

Exec pNumberOfCustomerOrdersByLocationAndYears;
Go

