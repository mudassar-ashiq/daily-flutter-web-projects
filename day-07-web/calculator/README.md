# Day 7 — Calculator

A calculator in plain HTML, CSS and JavaScript. It does add, subtract,
multiply and divide, plus percent and plus/minus. It works with the
mouse and with the keyboard, and keeps a history of past calculations
in the browser with localStorage — clicking an old answer puts it back
into the calculator.

## What I practised

- Keeping state in JavaScript (current number, previous number, operator)
- Handling button clicks and keyboard input for the same actions
- Rounding off floating point results like 0.1 + 0.2
- Saving and loading a list with localStorage

## How to run it

Open `index.html` in a browser. No build step and no server needed.

Keyboard: numbers and `.` type digits, `+ - * /` pick an operator,
`Enter` or `=` gives the answer, `Backspace` deletes a digit,
`Escape` clears everything.

## Files

- `index.html` — the page, display and buttons
- `style.css` — all the styling, plain CSS
- `script.js` — the calculator logic, keyboard support and history
