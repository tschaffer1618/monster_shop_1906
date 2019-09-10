# Monster Shop
BE Mod 2 Week 4/5 Group Project

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models.


## Environment setup
- ruby 2.4.1p111
- Rails 5.1.7
- Test variables with Factory bot
- Styling with Boostrap
- Deployed on Heroku: [Our project website](https://rocky-island-97665.herokuapp.com)


## Database Structure
![schema](<img width="945" alt="monstershop_schema" src="https://user-images.githubusercontent.com/24424825/64744311-80218300-d4c0-11e9-976b-310d0632b496.png">)

> In this database, there are 6 tables in which each table has either one-to-many or many-to-many relationships with another table. Through associations, one table can have access to information on other tables.
