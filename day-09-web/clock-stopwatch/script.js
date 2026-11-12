// Clock: updates once a second from the system time.
var use24Hour = false;

var clockTimeEl = document.getElementById("clock-time");
var clockDateEl = document.getElementById("clock-date");
var formatToggle = document.getElementById("format-toggle");

function pad(n) {
  return String(n).padStart(2, "0");
}

function updateClock() {
  var now = new Date();
  var hours = now.getHours();
  var suffix = "";

  if (!use24Hour) {
    suffix = hours >= 12 ? " PM" : " AM";
    hours = hours % 12 || 12;
  }

  clockTimeEl.textContent =
    pad(hours) + ":" + pad(now.getMinutes()) + ":" + pad(now.getSeconds()) + suffix;

  clockDateEl.textContent = now.toLocaleDateString("en-GB", {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

formatToggle.addEventListener("click", function () {
  use24Hour = !use24Hour;
  formatToggle.textContent = use24Hour ? "Switch to 12-hour" : "Switch to 24-hour";
  updateClock();
});

updateClock();
setInterval(updateClock, 1000);

// Stopwatch: counts in centiseconds, using timestamps so it stays
// accurate even if the interval fires a little late.
var startPauseBtn = document.getElementById("start-pause");
var lapBtn = document.getElementById("lap");
var resetBtn = document.getElementById("reset");
var stopwatchEl = document.getElementById("stopwatch-time");
var lapsEl = document.getElementById("laps");

var running = false;
var elapsed = 0; // milliseconds, not counting the current run
var startedAt = 0;
var timerId = null;
var lapCount = 0;
var lastLapTotal = 0;

function formatTime(ms) {
  var totalSeconds = Math.floor(ms / 1000);
  var minutes = Math.floor(totalSeconds / 60);
  var seconds = totalSeconds % 60;
  var centiseconds = Math.floor((ms % 1000) / 10);
  return pad(minutes) + ":" + pad(seconds) + "." + pad(centiseconds);
}

function currentElapsed() {
  return running ? elapsed + (Date.now() - startedAt) : elapsed;
}

function renderStopwatch() {
  stopwatchEl.textContent = formatTime(currentElapsed());
}

function start() {
  running = true;
  startedAt = Date.now();
  timerId = setInterval(renderStopwatch, 31);
  startPauseBtn.textContent = "Pause";
  lapBtn.disabled = false;
  resetBtn.disabled = false;
}

function pause() {
  running = false;
  elapsed = currentElapsed();
  clearInterval(timerId);
  renderStopwatch();
  startPauseBtn.textContent = "Resume";
}

function toggleStartPause() {
  if (running) {
    pause();
  } else {
    start();
  }
}

function recordLap() {
  if (!running) return;
  var total = currentElapsed();
  lapCount += 1;

  var item = document.createElement("li");
  var label = document.createElement("span");
  label.textContent = "Lap " + lapCount;
  var diff = document.createElement("span");
  diff.className = "lap-diff";
  diff.textContent = "+" + formatTime(total - lastLapTotal);
  var value = document.createElement("span");
  value.textContent = formatTime(total);

  item.appendChild(label);
  item.appendChild(diff);
  item.appendChild(value);
  lapsEl.prepend(item);

  lastLapTotal = total;
}

function reset() {
  running = false;
  clearInterval(timerId);
  elapsed = 0;
  lapCount = 0;
  lastLapTotal = 0;
  renderStopwatch();
  lapsEl.innerHTML = "";
  startPauseBtn.textContent = "Start";
  lapBtn.disabled = true;
  resetBtn.disabled = true;
}

startPauseBtn.addEventListener("click", toggleStartPause);
lapBtn.addEventListener("click", recordLap);
resetBtn.addEventListener("click", reset);

// Same actions from the keyboard, so it works without the mouse too.
document.addEventListener("keydown", function (event) {
  if (event.code === "Space") {
    event.preventDefault();
    toggleStartPause();
  } else if (event.key === "l" || event.key === "L") {
    recordLap();
  } else if (event.key === "r" || event.key === "R") {
    reset();
  }
});

renderStopwatch();
