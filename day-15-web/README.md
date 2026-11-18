# Quick Quiz

A small quiz page in plain HTML, CSS and JavaScript. Twelve questions across
three categories — general knowledge, science and computing — with a
twenty-second timer on each question.

## What it does

- Pick a category, or play all twelve questions at once
- One question at a time, four options each
- Right and wrong answers are marked straight away
- A timer counts down on every question; running out counts as a wrong answer
- Progress bar, final score, and a review of every answer at the end
- Best score for each category is saved in localStorage
- Keys 1–4 answer without using the mouse

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

## What I practised

- Keeping the questions in a plain data array and rendering them from JavaScript
- A countdown timer with `setInterval`, and clearing it when an answer is picked
- Saving and reading a best score with localStorage
- Shuffling the question order so a replay is not the same run
