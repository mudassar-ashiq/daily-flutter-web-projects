# Portfolio Page

Day 1 of my daily project series — the web one, kept separate from my Flutter projects.

This is a simple personal portfolio page. It says who I am, what I study, my skills, and two projects I have worked on, with a link to my GitHub.

I made it with plain HTML, CSS and JavaScript. No framework and no library, just the three files below.

## Files

- `index.html` — the page itself: header, about, skills, projects and contact sections
- `style.css` — all the styling, including the layout for small screens
- `script.js` — the mobile menu button and the year in the footer

## Open it

Just open `index.html` in a browser. That is enough, everything works from the file.

If you want to run it through a local server instead:

```
python -m http.server
```

then open http://localhost:8000 in the browser.

## What I practised

- Semantic HTML tags — header, nav, main, section and footer instead of only divs
- Flexbox for the header and the skills list, and CSS grid for the project cards
- A media query so the page fits a phone screen, with a menu button that opens the nav
- A little JavaScript: toggling the menu and setting the year in the footer automatically
