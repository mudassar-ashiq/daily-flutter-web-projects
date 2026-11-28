# Monthly Budget Tracker

A simple budget page in plain HTML, CSS and JavaScript. Set your monthly
income, add expenses with a category, and see how much is left. There is a
breakdown of spending by category and a list of all expenses, which can be
filtered or deleted.

## What it does

- Set a monthly income, shown with spent and remaining amounts
- Add expenses with a description, amount and category
- Progress bar showing how much of the budget is used, turning amber near
  80% and red when over budget
- Spending breakdown by category with a bar for each one
- Expense list with a category filter and delete buttons
- "Start new month" button to clear the month's expenses
- Income and expenses are saved in localStorage, so they are still there
  after the page is closed

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

## What I practised

- Keeping the page state in one object and saving it with localStorage
- Re-rendering the page from state instead of updating bits of HTML by hand
- Form validation with plain JavaScript and showing error messages
- Working out totals and percentages from a list of items
- A small responsive layout with one breakpoint
