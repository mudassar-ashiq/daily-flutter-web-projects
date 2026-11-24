# CSS Layout Practice Page

A single page of small layout exercises, in plain HTML, CSS and
JavaScript. It shows a flexbox navigation bar, a flexbox row of cards,
a grid of examples that can be switched to flexbox, a two-column
article with a sidebar, and a three-column footer.

## What it does

- Header built with flexbox, with the title on the left and the links
  on the right
- Intro section in two columns, with a facts box on the side
- Three cards in a flex row that wrap on narrow screens
- Six example boxes in a grid — a button switches the same six boxes
  to a flexbox layout so the two can be compared
- Two-column article with a sidebar that can be hidden with a button
- One breakpoint at 700px: everything stacks into a single column

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

## What I practised

- Deciding between flexbox (one direction) and grid (rows and columns)
  for each part of a page
- Letting the container set the width with `1fr` and `flex: 1` instead
  of fixed widths
- Spanning grid items across columns with `grid-column: span 2`
- Keeping a page responsive with one breakpoint instead of many
- Toggling a class from JavaScript to change a layout
