# Monster Shop
BE Mod 2 Week 6 Solo Project

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models. 

Week 6 additions:
- gem orderly (for testing this.before.that)
- new table called 'addresses' (address info is removed from 'orders', and each order has a user and an optional address)
- CRUD functionality for addresses
  - addresses cannot be deleted if shipped to
  - pending orders can have their address changed
  - deleting all addresses from a user does not cause the user order show page or merchant order show page to break
  - users choose a shipping address for an order prior to checking out from the cart show page

## Environment setup
- ruby 2.4.1p111
- Rails 5.1.7
- Test variables with Factory bot
- Styling with Boostrap




