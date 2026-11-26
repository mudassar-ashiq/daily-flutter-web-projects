# Focus Timer

A focus timer page in plain HTML, CSS and JavaScript. It works like the
Pomodoro method: 25 minutes of focused work, a 5-minute break, and a
15-minute break after every four focus sessions. There is also a small
task list, so each session has one thing to work on.

## What it does

- Focus, short break and long break modes, with a tab for each
- Start, pause, reset and skip buttons, plus the space bar to start or pause
- Task list — add tasks, click one to make it current, tick it off when done
- Counts focus sessions finished today, with four dots for the current round
- Timer lengths can be changed (focus, short break, long break) and are saved
- Tasks, lengths and today's session count are kept in localStorage

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

## What I practised

- Running a countdown with `setInterval` and `Date.now()` so it stays accurate
- Keeping the page state (mode, tasks, settings) in one place and saving it
- Reading and writing localStorage, with a fresh session count each day
- Switching modes and updating the page from a single render function
- A small responsive layout with one breakpoint
