FOR END USER
This is a documentation on how to use Local Basic CRM for end-user.

When accessing the system, user will need to login first. Request login credential from system
admin to gain access to the system.

After login, user will noticed search box, 'Dashboards', 'Accounts', 'Subjects', 'Activities',
and 'Contacts' on top navigation bar. The first page will let user to choose between 'Sale Dashboard'
or 'Marketing Dashboard' for overview.

First and foremost, before creating any 'Opportunities', 'Cases', or any 'Tasks', user need to create an 'Account'(company profiles).

In 'Account' created, user can add associated 'Contacts', 'Attachment files', and 'Notes' related to the account.

From 'Account', user can create 'Opportunities', 'Cases', and 'Marketings' activities called as 'Subjects', as well as creating 'Tasks', 'Call logs', and 'Events' for each 'Subjects'.

In 'Contacts', user can create an independent contact details without any associations to 'Accounts' nor 'Subjects'.

For each 'Subjects', user can add stages pipeline. This is useful for tracking the progress of certain 'Opportunities', 'Cases', or 'Marketings' activities.

FOR ADMIN
SERVER SIDE
This software has been tested on Puma as Web-app server, and NGINX as HTTP server. The database is Rails default database which is SQLite. Everything has been placed in a single server(Raspberry Pi with Raspbian Jessie Lite). However, it can be run on clusters(multiple servers) for scalability, but require some modifications on server configurations as well as modification for Puma configuration in the web-app itself.

Setting up the server for Rails app.


SOFTWARE SIDE
Local Basic CRM is built on Ruby on Rails platform. The details version are given below:-
Ruby version 2.3.3
Rails version 5.0.0
