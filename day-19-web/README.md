# Pakistan Weather — Weather Card Page

A weather card page for eight Pakistani cities, in plain HTML, CSS and
JavaScript. Each card shows the temperature, condition, high and low,
humidity and wind, plus a five-day forecast.

## What it does

- One card per city: Sahiwal, Lahore, Karachi, Islamabad, Rawalpindi,
  Multan, Faisalabad and Peshawar
- Switch between &deg;C and &deg;F — the choice is saved in localStorage
- Search by city or province name
- Sort by city name, warmest first, or coolest first
- Each card has a small five-day forecast strip
- The layout is responsive: the cards reflow into one column on a phone

## How to run it

Open `index.html` in a browser. Nothing to install, no build step.

The figures are sample data written by hand for practice, not a live
forecast. There is no weather API behind this page.

## What I practised

- Keeping the city data in a plain array and rendering the cards from
  JavaScript instead of writing each card by hand
- Converting temperatures between Celsius and Fahrenheit in one place
- Filtering and sorting the same list with one render function
- Saving a small preference (the temperature unit) with localStorage
