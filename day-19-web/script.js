// Weather cards page. The figures are sample data written by hand
// for practice — there is no live weather API behind this page.

var cities = [
  {
    name: "Sahiwal", province: "Punjab",
    tempC: 24, condition: "Sunny", icon: "sun",
    highC: 27, lowC: 13, humidity: 42, windKmh: 9,
    forecast: [["Mon", 27, 13], ["Tue", 26, 12], ["Wed", 25, 12], ["Thu", 26, 13], ["Fri", 28, 14]]
  },
  {
    name: "Lahore", province: "Punjab",
    tempC: 23, condition: "Partly cloudy", icon: "partly",
    highC: 26, lowC: 12, humidity: 48, windKmh: 11,
    forecast: [["Mon", 26, 12], ["Tue", 25, 11], ["Wed", 24, 11], ["Thu", 25, 12], ["Fri", 27, 13]]
  },
  {
    name: "Karachi", province: "Sindh",
    tempC: 29, condition: "Sunny", icon: "sun",
    highC: 31, lowC: 21, humidity: 58, windKmh: 16,
    forecast: [["Mon", 31, 21], ["Tue", 31, 20], ["Wed", 30, 20], ["Thu", 30, 21], ["Fri", 32, 22]]
  },
  {
    name: "Islamabad", province: "Islamabad Capital Territory",
    tempC: 19, condition: "Partly cloudy", icon: "partly",
    highC: 22, lowC: 8, humidity: 52, windKmh: 8,
    forecast: [["Mon", 22, 8], ["Tue", 21, 7], ["Wed", 20, 7], ["Thu", 21, 8], ["Fri", 23, 9]]
  },
  {
    name: "Rawalpindi", province: "Punjab",
    tempC: 20, condition: "Cloudy", icon: "cloud",
    highC: 22, lowC: 9, humidity: 55, windKmh: 10,
    forecast: [["Mon", 22, 9], ["Tue", 21, 8], ["Wed", 21, 8], ["Thu", 22, 9], ["Fri", 23, 10]]
  },
  {
    name: "Multan", province: "Punjab",
    tempC: 26, condition: "Sunny", icon: "sun",
    highC: 29, lowC: 14, humidity: 38, windKmh: 12,
    forecast: [["Mon", 29, 14], ["Tue", 28, 13], ["Wed", 28, 13], ["Thu", 29, 14], ["Fri", 30, 15]]
  },
  {
    name: "Faisalabad", province: "Punjab",
    tempC: 24, condition: "Partly cloudy", icon: "partly",
    highC: 27, lowC: 12, humidity: 45, windKmh: 10,
    forecast: [["Mon", 27, 12], ["Tue", 26, 12], ["Wed", 26, 11], ["Thu", 27, 12], ["Fri", 28, 13]]
  },
  {
    name: "Peshawar", province: "Khyber Pakhtunkhwa",
    tempC: 21, condition: "Light rain", icon: "rain",
    highC: 23, lowC: 10, humidity: 64, windKmh: 13,
    forecast: [["Mon", 23, 10], ["Tue", 22, 9], ["Wed", 22, 9], ["Thu", 23, 10], ["Fri", 24, 11]]
  }
];

var icons = {
  sun: '<svg viewBox="0 0 24 24" fill="none" stroke="#d9930d" stroke-width="2" stroke-linecap="round" aria-hidden="true"><circle cx="12" cy="12" r="4" fill="#f4c542" stroke="none"/><line x1="12" y1="1" x2="12" y2="4"/><line x1="12" y1="20" x2="12" y2="23"/><line x1="4.2" y1="4.2" x2="6.3" y2="6.3"/><line x1="17.7" y1="17.7" x2="19.8" y2="19.8"/><line x1="1" y1="12" x2="4" y2="12"/><line x1="20" y1="12" x2="23" y2="12"/><line x1="4.2" y1="19.8" x2="6.3" y2="17.7"/><line x1="17.7" y1="6.3" x2="19.8" y2="4.2"/></svg>',
  partly: '<svg viewBox="0 0 24 24" fill="none" stroke="#7d97a8" stroke-width="2" stroke-linecap="round" aria-hidden="true"><circle cx="8" cy="8" r="3.5" fill="#f4c542" stroke="none"/><path d="M8 17h10a3.5 3.5 0 0 0 .6-6.9A5 5 0 0 0 9 11.5 3 3 0 0 0 8 17z" fill="#dbe5ea" stroke="none"/></svg>',
  cloud: '<svg viewBox="0 0 24 24" fill="none" stroke="#7d97a8" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M6 18h12a4 4 0 0 0 .8-7.9A6 6 0 0 0 7.2 11 3.5 3.5 0 0 0 6 18z" fill="#dbe5ea" stroke="none"/></svg>',
  rain: '<svg viewBox="0 0 24 24" fill="none" stroke="#7d97a8" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M6 14h12a4 4 0 0 0 .8-7.9A6 6 0 0 0 7.2 7 3.5 3.5 0 0 0 6 14z" fill="#dbe5ea" stroke="none"/><line x1="8" y1="19" x2="7" y2="22"/><line x1="12" y1="19" x2="11" y2="22"/><line x1="16" y1="19" x2="15" y2="22"/></svg>'
};

var cardsEl = document.getElementById("cards");
var searchInput = document.getElementById("search");
var sortSelect = document.getElementById("sort");
var noResultsEl = document.getElementById("no-results");
var btnC = document.getElementById("btn-c");
var btnF = document.getElementById("btn-f");

// Remember the last unit the visitor picked.
var unit = "C";
try {
  var savedUnit = localStorage.getItem("weather-unit");
  if (savedUnit === "F" || savedUnit === "C") {
    unit = savedUnit;
  }
} catch (e) {
  // localStorage may be off; the page still works without it.
}

function toUnit(tempC) {
  if (unit === "F") {
    return Math.round(tempC * 9 / 5 + 32);
  }
  return tempC;
}

function render() {
  var query = searchInput.value.trim().toLowerCase();
  var shown = cities.filter(function (city) {
    return city.name.toLowerCase().indexOf(query) !== -1 ||
      city.province.toLowerCase().indexOf(query) !== -1;
  });

  if (sortSelect.value === "temp-desc") {
    shown.sort(function (a, b) { return b.tempC - a.tempC; });
  } else if (sortSelect.value === "temp-asc") {
    shown.sort(function (a, b) { return a.tempC - b.tempC; });
  } else {
    shown.sort(function (a, b) { return a.name.localeCompare(b.name); });
  }

  noResultsEl.hidden = shown.length !== 0;

  cardsEl.innerHTML = shown.map(function (city) {
    var days = city.forecast.map(function (day) {
      return "<li><span class='day'>" + day[0] + "</span><span class='range'>" +
        toUnit(day[1]) + "&deg; / " + toUnit(day[2]) + "&deg;</span></li>";
    }).join("");

    return "<article class='card'>" +
      "<div class='card-top'><div><h2>" + city.name + "</h2>" +
      "<p class='province'>" + city.province + "</p></div>" +
      icons[city.icon] + "</div>" +
      "<p class='temp'>" + toUnit(city.tempC) + "<span class='unit'>&deg;" + unit + "</span></p>" +
      "<p class='condition'>" + city.condition + "</p>" +
      "<div class='details'>" +
      "<div><span>High / Low</span>" + toUnit(city.highC) + "&deg; / " + toUnit(city.lowC) + "&deg;</div>" +
      "<div><span>Humidity</span>" + city.humidity + "%</div>" +
      "<div><span>Wind</span>" + city.windKmh + " km/h</div>" +
      "</div>" +
      "<ul class='forecast'>" + days + "</ul>" +
      "</article>";
  }).join("");
}

function setUnit(nextUnit) {
  unit = nextUnit;
  btnC.classList.toggle("active", unit === "C");
  btnF.classList.toggle("active", unit === "F");
  btnC.setAttribute("aria-pressed", unit === "C");
  btnF.setAttribute("aria-pressed", unit === "F");
  try {
    localStorage.setItem("weather-unit", unit);
  } catch (e) {
    // Saving the choice is a nicety, not a requirement.
  }
  render();
}

btnC.addEventListener("click", function () { setUnit("C"); });
btnF.addEventListener("click", function () { setUnit("F"); });
searchInput.addEventListener("input", render);
sortSelect.addEventListener("change", render);

setUnit(unit);
