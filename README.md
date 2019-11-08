# market_place (codename MarketPlacer ?)

https://calm-stream-89104.herokuapp.com

## Description

ruby web-server project handling information of stalls and their sales items (e.g. Sunday markets, meetups, events).

Made with ruby, sinatra, postgresSQL, html, javascript, css.

## Problem

 A market is the destination / place that opens for business on some days of the year but not for 24 hours (such as online shopping) to sell goods and services e.g. Queen Vic Market, local farmers market. 

 The main idea was a web-site where sellers could setup and then advertise a stall and the goods quickly (even on the day.)

## Design Process

I tried to look of ways of doing data entry really quick, so had a look at working with WhatsApp. But time ran out.

I made a entity relational diagram that show a problem early on which was the web site had a lot of entities (around 7 - 8) 

Then made some wireframes which were designed for mobiles 

Then I spent half a day writing some pseudo-code for the more complicated features in my application.

## Challenges and Cool Tech

There is a lot of duplication in my website around authenication. It came a problem when I had three points in the application where the seller could log on.

I started using exec_params to handle string escaping

## Installation

Deploy on heroku and run the schema in the 

## TODOs 

  - Products and sale items are not implemented.

## Future Features

  - Organizers that the acts as adminstrators / moderators for a particular market  and can also add, edit and remove market dates.
  - To make registration of stalls less error prone, add market location (i.e. stall number 1, table 1)
  - Calculate stall open and closed by checking all stalls' opening times.
  - Tags (market-level, stall-level, sale item-level)
