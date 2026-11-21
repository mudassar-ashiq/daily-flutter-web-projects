# Mohallah Store — Small Shop Page

A small shop page for a neighbourhood general store in Sahiwal, in plain
HTML, CSS and JavaScript. Sixteen everyday products with prices in rupees,
a cart that keeps a running total, and free delivery over Rs 1,000.

## What it does

- Product list with prices in Rs, grouped into groceries, dairy and eggs,
  household and personal care
- Category filter buttons and a search box
- Add items to the cart, change quantities, or remove them by taking the
  quantity down to zero
- Cart panel shows the number of items, subtotal, delivery fee and total
- Free delivery on orders over Rs 1,000, with a note saying how much more
  is needed to reach it
- A simple place-order message with the order total
- The cart is saved in localStorage, so it is still there after a refresh
- Escape closes the cart panel

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

## What I practised

- Keeping the product list in a plain data array and rendering it from JavaScript
- Working out a running cart total from quantities and prices
- Filtering and searching the same list with one render function
- Saving and reading the cart with localStorage
