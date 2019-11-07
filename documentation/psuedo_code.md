# Psuedo-code: market_place

## Glossary
 - Market 
    - A market is the destination / place that opens for business on some days of the year but not for 24 hours (such as online shopping) to sell goods and services e.g. Queen Vic Market, local farmers market. 

 - Market Date (or Market Day)
    - A market date is the duration when a particular market is open for business. Market Days are the same thing, but market date is preferred as a market should be able to be opened over multiple days (i.e. past midnight).

 - Sellers (Vendors, Merchants)
    - The primary users for this website. Sellers can set-up stalls and add products to the market once they have logged in.

 - Products 
    - Details on stock that the seller could sell at a markets. Hopefully, the information about each product would be entered in advance to be reused at multiple market dates.

 - Stall
    - A stall is a seller AND their location at the market on a market date.

 - Sale Items
    - The products that are deemed on sale at the stall during a market date.

 - Users 
    - Anybody using the website

 - General Public 
    - Users can only view the changes on the site. 

 - Market Date Portal
    - the section of the website / app server that show the stalls opened and items on sales

 - Admin Portal
    - this section of the website / app server that users can sign-up to be sellers for markets. Sellers can then add, edit or delete stalls and products.

## Use Cases

### Login as a seller

#### Routes / Paths
  - /markets/:market_id/login
  - /market_dates/:market_date_id/login
  - /login (admin)

#### Steps

  1. If user comes to the market (date) portal, the user will click the login button on the market (date) portal.
  1. Login involves entering a email address and password combination.
  1. If login failed, then allow them to re-enter email / password again.
  1. If login passes, then redirect back to the market date site.
      - QUESTION (Should sign-up be disabled on the day?)
  1. Once they have logged in the market date portal, redirect them to seller screen
      - /markets/:market_id/login --> /markets/:market_id/sellers/:seller_id
      - /market_dates/:market_date_id/login --> /market_dates/:market_date_id/sellers/:seller_id
      - /login (admin) --> /sellers/:seller_id (admin)
  1. Redirect all other users cannot access this redirect page
      - /markets/:market_id/sellers/:seller_id --> /markets/:market_id/loging
      -  /market_dates/:market_date_id/sellers/:seller_id --> /market_dates/:market_date_id/login -->
      - /sellers/:seller_id (admin) --> /login (admin)

### Registering for a stall via the market date portal

#### Routes / Paths
  - /markets/:market_id/stalls/new
  - /market_dates/:market_date_id/stalls/new
  - /stalls/new (admin)

#### Pre-conditions

  - For the user to register as a stall for a market date, the user must sign in as seller.
  - If login passes, then redirect back to the market date site.
  - QUESTION (Should sign-up be disabled on the day?)


#### Steps
  1.  Once the seller is logged, the 'Register stall' button / link on the screen will be visible on the screen.
  1. The server handles a GET '/market_dates/:id/stalls/new' http request
  1. Reject any other users from this route by redirecting them to login screen.
  1. The timezone of the server is embedded on screen.
  1. Load available tags from database and populate combo box
  1. On the 'Register Stall' screen, the seller (the logged-in-user) can create a stall with the following things
      - stall name
      - location in the market (SHOULD be a resource to assign)
      - website
      - opening time (date + time + timezone?)
        - date input
        - time input
        - timezone input (hidden?)
      - closing time (date + time + timezone?)
        - date input
        - time input
        - timezone input (hidden?)
      - tags (OR future feature)
  1. The opening time on load should be populated with the opening time of the market date.
  1. The closing time on load should be populated with the closing time of the market date.
  1. The database should have a new stall record with the following fields
      - market date id
      - seller id
      - stall name
      - stall location
      - tags (OR future feature)
  1. The server should redirected to the sellers screen
      - /markets/:market_id/stalls/new --> /markets/:market_id/stalls
      - /market_dates/:market_date_id/stalls/new --> market_dates/:market_date_id/stalls
      - /stalls/new (admin) --> /stalls/ (admin)


### Updating a stall via the market date portal 

#### Routes / Paths
  - /markets/:market_id/stalls/:stall_id/edit
  - /market_dates/:market_date_id/stalls/:stall_id/edit
  - /stalls/:stall_id/edit (admin)

#### Pre-conditions
  - For the user to update an existing stall on a market date, the user must sign in as seller.
  - Redirect on Server validation too;
    - --> /markets/:market_id/login on: 
      - get /markets/:market_id/stalls/:stall_id/edit
      - patch /markets/:market_id/stalls/:stall_id
    - --> /market_dates/:market_date_id/logon on:
      - get /market_dates/:market_date_id/stalls/:stall_id/edit
      - patch /market_dates/:market_date_id/stalls/:stall_id
    - --> /login (admin)
      - get /stalls/:stall_id/edit  (admin) 
      - patch /stalls/:stall_id  (admin) 
  - The market date id would be the current market date (hidden field)

#### Steps
  1. The seller should be on these screens to edit
      - /markets/:market_id/stalls/:stall_id
      - /market_dates/:market_date_id/stalls/:stall_id
      - /stalls/:stall_id (admin)
  1. The user click on the edit link
  1. Browser sends a http GET request; The server will accept these route:
      - get /markets/:market_id/stalls/:stall_id/edit
      - get /market_dates/:market_date_id/stalls/:stall_id/edit
      - get /stalls/:stall_id/edit
  1. Load edit.erb with a form with following details
      - stall id (not editable)
      - seller id (not editable)
      - seller name (editable)
      - seller website (editable)
      - seller location (editable)
      - tags (editable)
  1. Wait for form to submit a patch request
      - patch /markets/:market_id/stalls/:stall_id/edit
      - patch /market_dates/:market_date_id/stalls/:stall_id/edit
      - patch /stalls/:stall_id/edit
  1. SERVER validation: Redirect unless logged in as correct seller
  1. Update stall (and tags) on database
  1. Redirect on success
      - patch /markets/:market_id/stalls/:stall_id/edit --> /markets/:market_id/stalls/:stall_id
      - patch /market_dates/:market_date_id/stalls/:stall_id/edit --> /market_dates/:market_date_id/stalls/:stall_id
      - patch /stalls/:stall_id/edit --> /stalls/:stall_id


### Adding sale items to stall for market date portal

#### Routes / Paths
  - /markets/:market_id/stalls/:stall_id/sale_items/
  - /market_dates/:market_date_id/stalls/:stall_id/sale_items/
  - /stalls/:stall_id/sale_items/

#### Pre-conditions

  - The user must be logged in as a seller be able to add sale items to a stall.
  - The seller has permissions to make changes to a stall that is registered to them (by seller id). Therefore the seller should be  add sales items to their own stalls. The link should be disabled / hidden to other users. Server validation too;
    - /markets/:market_id/stalls/:stall_item_id/sale_items/new --> /markets/:market_id/login

    - /market_dates/:market_date_id/stalls/:stall_id/sale_items/new --> /market_dates/:market_date_id/login

    - /stalls/:stall_id/sale_items/new  (admin) --> /login (admin)

  - The market date id would be the current market date

#### METHOD A: Create product and add inventory to a stall in one-go.
  1. Click button 'Create new product and add sale item'. Hide this button for other users (i.e. visible only if signed as seller).
  1. Browser sends GET request
      - get /markets/:market_id/stalls/:stall_id/sale_items/add_product/

      - get /market_dates/:market_date_id/stalls/:stall_id/sale_items/add_product

      - get /stalls/:stall_id/sale_items/add_product

  1. Go to the 'Create and then sale item' screen with a form
  1. The seller should enter a number of input fields on the screen
      - Step 1: product
        - product name
        - product description
        - product image
        - unit cost
        - tags (MAYBE)
      - Step 2: sale item
        - unit price
        - quantity
        - tags (MAYBE)

  1. The seller should click the 'Create' button once done in a form
  1. Browser sends POST request
      - post /markets/:market_id/stalls/:stall_id/sale_items/add_product/new

      - post /market_dates/:market_date_id/stalls/:stall_id/sale_items/add_product/new

      - post /stalls/:stall_id/sale_items/add_product/new

  1. Insert new product to the database with values
      - seller id (from session)
      - product name
      - product description
      - unit cost
  1. Retrieve the product id from the database
  1. Insert new sale item to database with values
      - market date id (from current market date)
      - product id (new product id from db)
      - quantity
      - unit price
      - tags (MAYBE)
  1. Redirect back to stall detail screen
      - post /markets/:market_id/stalls/:stall_id/sale_items/add_product/new --> /markets/:market_id/stalls/:stall_id/sale_items/

      - post /market_dates/:market_date_id/stalls/:stall_id/sale_items/add_product/new  --> /market_dates/:market_date_id/stalls/:stall_id/sale_items/

      - post /stalls/:stall_id/sale_items/add_product/new --> /stalls/:stall_id/sale_items/


#### METHOD B: Add a existing product to a stall.

  1. Click button 'Add existing product for sale'. Hide this button for other users (i.e. visible only if signed as seller).
   1. Browser sends GET request
      - get /markets/:market_id/stalls/:stall_id/sale_items/new

      - get /market_dates/:market_date_id/stalls/:stall_id/sale_items/new

      - get /stalls/:stall_id/sale_items/new

  1. Go to the 'Add existing product for sale'
  1. Populate combo box with existing products (maybe js) for all products that sellers has created in advance.
  1. Load the seller (session) & stall (products seller id) for display in form
  1. Browser send POST request 
      - post /markets/:market_id/stalls/:stall_id/sale_items/new

      - post /market_dates/:market_date_id/stalls/:stall_id/sale_items/new

      - post /stalls/:stall_id/sale_items/new  
  1. Insert new sale item to database with values
      - market date id (from current market date)
      - product id (new product id from db)
      - quantity
      - unit price
  1. Redirect back to market page
      - post /markets/:market_id/stalls/:stall_id/sale_items/new --> /markets/:market_id/stalls/:stall_id/sale_items

      - post /market_dates/:market_date_id/stalls/:stall_id/sale_items/new --> /market_dates/:market_date_id/stalls/:stall_id/sale_items

      - post /stalls/:stall_id/sale_items/new --> /stalls/:stall_id/sale_items

### Delete stall

#### Routes / Paths
  - delete /markets/:market_id/stalls/:stall_id/

  - delete /market_dates/:market_date_id/stalls/:stall_id/
  
  - delete /stalls/:stall_id/ (admin)

#### Pre-conditions

  - The user must be logged in as a seller to delete a stall.
  - Delete button is only visible on logged on; server validation check needed too. Redirect to login screen i.e. 
    - /markets/:market_id/stalls/:stall_id --> /markets/:market_id/login

    - /market_dates/:market_date_id/stalls/:stall_id --> /market_dates/:market_date_id/login

    - /stalls/:stall_id/ (admin) --> /login (admin)

### Steps

  1. Seller (authorized user) clicks on form button on the following  details screens
      - /markets/:market_id/stalls/:stall_id

      - /market_dates/:market_date_id/stalls/:stall_id

      - /stalls/:stall_id/ (admin)
  2. Browser sends a delete request for the following routes:
      - delete /markets/:market_id/stalls/:stall_id/

      - delete /market_dates/:market_date_id/stalls/:stall_id/sale_items/

      - delete /stalls/:stall_id/ (admin)

  3. Delete from db all sale items attached to stall
  4. Delete from db all tags attached to stall
  5. Delete from db the stall object 
  6. Redirect on success 
      - delete /markets/:market_id/stalls/:stall_id/ --> /markets/:market_id/stalls/

      - delete /market_dates/:market_date_id/stalls/:stall_id/ -->
      /market_dates/:market_date_id/stalls/

      - delete /stalls/:stall_id/ (admin) --> /stalls/

### Edit Sale Item of stall 
#### Routes / Paths
  - patch /markets/:market_id/stalls/:stall_id/sale_items/:item_id

  - patch /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id

  - patch /stalls/:stall_id/sale_items/:item_id

#### Pre-conditions

  - The user must be logged in as a seller to view and edit a sale item.
  - Delete button is only visible on logged on; server validation check needed too. Redirect to login screen i.e. 
    - patch /markets/:market_id/stalls/:stall_id/sale_items/:item_id --> /markets/:market_id/login

    - patch /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id --> /market_dates/:market_date_id/login

    - patch /stalls/:stall_id/sale_items/:item_id (admin) --> /login (admin)

### Steps 

  1. Browser sends a get request 
      - get /markets/:market_id/stalls/:stall_id/sale_items/:item_id/edit

      - get /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id/edit

      - get /stalls/:stall_id/sale_items/:item_id/edit

  1. Get sale item details (plus product and seller) from database
  1. Server returns a HTML form with item id existing database values 
  1. Seller sends patch request on form submit
      - patch /markets/:market_id/stalls/:stall_id/sale_items/:item_id

      - patch /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id

      - patch /stalls/:stall_id/sale_items/:item_id
  1. Add and delete tags if required
  1. Update sale item on database
  1. Redirect on success 
      - patch /markets/:market_id/stalls/:stall_id/sale_items/:item_id --> /markets/:market_id/stalls/:stall_id/sale_items/:item_id

      - patch /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id --> /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id

      - patch /stalls/:stall_id/sale_items/:item_id (admin) --> /stalls/:stall_id/sale_items/:item_id (admin)    

### Delete Sale item

#### Routes / Paths
  - delete /markets/:market_id/stalls/:stall_id/sale_items/:item_id
  - delete /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id
  - delete /stalls/:stall_id/sale_items/:item_id

#### Pre-conditions

  - The user must be logged in as a seller to view and delete a sale item.
  - Delete button is only visible on logged on; server validation check needed too. Redirect to login screen i.e. 
    - delete /markets/:market_id/stalls/:stall_id/sale_items/:item_id --> /markets/:market_id/login

    - delete /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id --> /market_dates/:market_date_id/login

    - delete /stalls/:stall_id/sale_items/:item_id (admin) --> /login (admin)

#### Steps

  1. Browser sends delete request via form button
  1. Delete tags from database by item id in params
  1. Delete sale_item from database by item id in params
  1. Redirect on success 
      - delete /markets/:market_id/stalls/:stall_id/sale_items/:item_id --> /markets/:market_id/stalls/:stall_id/sale_items/
      
      - delete /market_dates/:market_date_id/stalls/:stall_id/sale_items/:item_id --> /market_dates/:market_date_id/stalls/:stall_id/sale_items/

      - delete /stalls/:stall_id/sale_items/:item_id (admin) --> /stalls/:stall_id/sale_items/ (admin)



### TODOs
1. Update sale items on market date
1. Adding tags to stalls
1. Adding tags to products 
1. Adding custom tags to sale items
1. Disabling past market dates to changes.