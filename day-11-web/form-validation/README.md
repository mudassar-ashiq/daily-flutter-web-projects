# Day 11 — Course Registration Form (Form Validation)

A registration form for a short course, with validation on every field.
Errors are shown next to the field as soon as you leave it, and again
on submit if anything is still wrong. The form only shows the success
message when every field passes.

## What I practised

- Writing validation checks with regular expressions (name, email, phone)
- Checking a date of birth and working out the age from it
- Live validation on blur and input, not just on submit
- Showing and clearing inline error messages and field states
- A simple password strength meter based on length and character types
- Matching two password fields against each other

## How to run it

Open `index.html` in a browser. No build step and no server needed.

Try it out: leave a field empty, type a wrong email, or use two
different passwords, and see the messages. A valid example is
name "Ayesha Khan", email "ayesha@example.com", phone "0300 1234567",
date of birth any date that makes you 16 or older, and a password
of 8 or more characters with a letter and a number.

## Files

- `index.html` — the registration form and the success message
- `style.css` — all the styling, plain CSS
- `script.js` — the validation rules, the strength meter, and submit handling
