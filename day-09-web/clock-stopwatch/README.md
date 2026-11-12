# Day 9 — Digital Clock & Stopwatch

A page with two things: a live digital clock and a stopwatch.
The clock shows the current time and date, and can switch between
12-hour and 24-hour format. The stopwatch starts, pauses and resets,
records lap times with the split for each lap, and also works from
the keyboard (Space to start or pause, L for a lap, R to reset).

## What I practised

- Updating the page on a timer with `setInterval`
- Reading the current time with the `Date` object and formatting it
- Keeping stopwatch time accurate with timestamps instead of counting ticks
- Building and adding list items to the page with JavaScript
- Handling the same actions from buttons and from keyboard keys

## How to run it

Open `index.html` in a browser. No build step and no server needed.

## Files

- `index.html` — the page, clock display and stopwatch controls
- `style.css` — all the styling, plain CSS
- `script.js` — the clock, the 12/24-hour switch, and the stopwatch with laps
