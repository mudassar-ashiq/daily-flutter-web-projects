// Focus timer: 25 minutes of work, short breaks, a long break after 4.
// Tasks, lengths and today's session count are kept in localStorage.

var SETTINGS_KEY = 'focusTimer.settings';
var TASKS_KEY = 'focusTimer.tasks';
var SESSIONS_KEY = 'focusTimer.sessions';

var timeLeftEl = document.getElementById('timeLeft');
var modeLabelEl = document.getElementById('modeLabel');
var currentTaskEl = document.getElementById('currentTask');
var startPauseBtn = document.getElementById('startPauseBtn');
var resetBtn = document.getElementById('resetBtn');
var skipBtn = document.getElementById('skipBtn');
var dotsEl = document.getElementById('sessionDots');
var sessionsDoneEl = document.getElementById('sessionsDone');
var timerCard = document.getElementById('timerCard');
var taskForm = document.getElementById('taskForm');
var taskInput = document.getElementById('taskInput');
var taskListEl = document.getElementById('taskList');
var emptyNote = document.getElementById('emptyNote');
var clearDoneBtn = document.getElementById('clearDoneBtn');
var settingsForm = document.getElementById('settingsForm');
var settingsNote = document.getElementById('settingsNote');

var settings = loadSettings();
var tasks = loadTasks();
var sessions = loadSessions();

var mode = 'focus';          // focus | shortBreak | longBreak
var remaining = settings.focus * 60;
var running = false;
var timerId = null;
var endTime = 0;
var cycleCount = 0;          // focus sessions finished in this round of 4

function loadSettings() {
  try {
    var saved = JSON.parse(localStorage.getItem(SETTINGS_KEY));
    if (saved && saved.focus && saved.shortBreak && saved.longBreak) return saved;
  } catch (e) {}
  return { focus: 25, shortBreak: 5, longBreak: 15 };
}

function loadTasks() {
  try {
    var saved = JSON.parse(localStorage.getItem(TASKS_KEY));
    if (Array.isArray(saved)) return saved;
  } catch (e) {}
  return [];
}

// Sessions count resets each day.
function loadSessions() {
  var today = new Date().toDateString();
  try {
    var saved = JSON.parse(localStorage.getItem(SESSIONS_KEY));
    if (saved && saved.date === today) return saved.count;
  } catch (e) {}
  return 0;
}

function saveAll() {
  localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
  localStorage.setItem(TASKS_KEY, JSON.stringify(tasks));
  localStorage.setItem(SESSIONS_KEY, JSON.stringify({
    date: new Date().toDateString(),
    count: sessions
  }));
}

function formatTime(totalSeconds) {
  var minutes = Math.floor(totalSeconds / 60);
  var seconds = totalSeconds % 60;
  return String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
}

function modeMinutes(name) {
  return settings[name];
}

function modeName(name) {
  if (name === 'focus') return 'Focus';
  if (name === 'shortBreak') return 'Short break';
  return 'Long break';
}

function updateDisplay() {
  timeLeftEl.textContent = formatTime(remaining);
  document.title = running
    ? formatTime(remaining) + ' — ' + modeName(mode) + ' | Focus Timer'
    : 'Focus Timer';

  if (mode === 'focus') {
    modeLabelEl.textContent = 'Focus session ' + (cycleCount + 1) + ' of 4';
  } else if (mode === 'shortBreak') {
    modeLabelEl.textContent = 'Short break — stretch, drink some water';
  } else {
    modeLabelEl.textContent = 'Long break — you earned it';
  }

  timerCard.classList.toggle('break', mode !== 'focus');
  startPauseBtn.textContent = running ? 'Pause' : 'Start';
  sessionsDoneEl.textContent = sessions + (sessions === 1 ? ' focus session' : ' focus sessions') + ' finished today';

  var dots = dotsEl.querySelectorAll('.dot');
  dots.forEach(function (dot, i) {
    dot.classList.toggle('done', i < cycleCount);
  });

  var current = tasks.find(function (t) { return t.current; });
  currentTaskEl.textContent = current
    ? 'Working on: ' + current.text
    : 'No task selected — add one below.';

  document.querySelectorAll('.mode-tab').forEach(function (tab) {
    tab.classList.toggle('active', tab.dataset.mode === mode);
  });
}

function setMode(newMode) {
  stopTimer();
  mode = newMode;
  remaining = modeMinutes(newMode) * 60;
  updateDisplay();
}

function startTimer() {
  running = true;
  endTime = Date.now() + remaining * 1000;
  timerId = setInterval(tick, 250);
  updateDisplay();
}

function stopTimer() {
  running = false;
  if (timerId) clearInterval(timerId);
  timerId = null;
  updateDisplay();
}

function tick() {
  remaining = Math.max(0, Math.round((endTime - Date.now()) / 1000));
  updateDisplay();
  if (remaining <= 0) finishSession();
}

function finishSession() {
  stopTimer();
  if (mode === 'focus') {
    sessions++;
    cycleCount++;
    if (cycleCount >= 4) {
      cycleCount = 0;
      setMode('longBreak');
    } else {
      setMode('shortBreak');
    }
  } else {
    setMode('focus');
  }
  saveAll();
  updateDisplay();
}

startPauseBtn.addEventListener('click', function () {
  if (running) stopTimer(); else startTimer();
});

resetBtn.addEventListener('click', function () {
  stopTimer();
  remaining = modeMinutes(mode) * 60;
  updateDisplay();
});

// Skip ends the current session early, without counting it.
skipBtn.addEventListener('click', function () {
  stopTimer();
  setMode(mode === 'focus' ? 'shortBreak' : 'focus');
});

document.querySelectorAll('.mode-tab').forEach(function (tab) {
  tab.addEventListener('click', function () {
    setMode(tab.dataset.mode);
  });
});

// Space bar starts or pauses, unless typing in a box.
document.addEventListener('keydown', function (e) {
  if (e.code === 'Space' && !/INPUT|TEXTAREA/.test(document.activeElement.tagName)) {
    e.preventDefault();
    if (running) stopTimer(); else startTimer();
  }
});

// --- Tasks ---

function renderTasks() {
  taskListEl.innerHTML = '';
  emptyNote.style.display = tasks.length ? 'none' : 'block';

  tasks.forEach(function (task) {
    var li = document.createElement('li');
    if (task.current) li.classList.add('current');
    if (task.done) li.classList.add('done');

    var check = document.createElement('input');
    check.type = 'checkbox';
    check.checked = task.done;
    check.setAttribute('aria-label', 'Mark done: ' + task.text);
    check.addEventListener('change', function () {
      task.done = check.checked;
      if (task.done && task.current) task.current = false;
      saveAll();
      renderTasks();
      updateDisplay();
    });

    var nameBtn = document.createElement('button');
    nameBtn.type = 'button';
    nameBtn.className = 'task-name';
    nameBtn.textContent = task.text;
    nameBtn.title = 'Make this the current task';
    nameBtn.addEventListener('click', function () {
      tasks.forEach(function (t) { t.current = false; });
      task.current = true;
      saveAll();
      renderTasks();
      updateDisplay();
    });

    var delBtn = document.createElement('button');
    delBtn.type = 'button';
    delBtn.className = 'task-delete';
    delBtn.textContent = '×';
    delBtn.setAttribute('aria-label', 'Delete: ' + task.text);
    delBtn.addEventListener('click', function () {
      tasks = tasks.filter(function (t) { return t.id !== task.id; });
      saveAll();
      renderTasks();
      updateDisplay();
    });

    li.appendChild(check);
    li.appendChild(nameBtn);
    li.appendChild(delBtn);
    taskListEl.appendChild(li);
  });
}

taskForm.addEventListener('submit', function (e) {
  e.preventDefault();
  var text = taskInput.value.trim();
  if (!text) return;
  tasks.push({ id: Date.now(), text: text, done: false, current: tasks.length === 0 });
  taskInput.value = '';
  saveAll();
  renderTasks();
  updateDisplay();
});

clearDoneBtn.addEventListener('click', function () {
  tasks = tasks.filter(function (t) { return !t.done; });
  saveAll();
  renderTasks();
  updateDisplay();
});

// --- Settings ---

document.getElementById('focusLength').value = settings.focus;
document.getElementById('shortBreakLength').value = settings.shortBreak;
document.getElementById('longBreakLength').value = settings.longBreak;

settingsForm.addEventListener('submit', function (e) {
  e.preventDefault();
  var focus = parseInt(document.getElementById('focusLength').value, 10);
  var shortBreak = parseInt(document.getElementById('shortBreakLength').value, 10);
  var longBreak = parseInt(document.getElementById('longBreakLength').value, 10);

  if (focus >= 5 && focus <= 90) settings.focus = focus;
  if (shortBreak >= 1 && shortBreak <= 30) settings.shortBreak = shortBreak;
  if (longBreak >= 5 && longBreak <= 60) settings.longBreak = longBreak;

  saveAll();
  if (!running) remaining = modeMinutes(mode) * 60;
  settingsNote.textContent = 'Saved. Focus ' + settings.focus +
    ' min, short break ' + settings.shortBreak +
    ' min, long break ' + settings.longBreak + ' min.';
  updateDisplay();
});

renderTasks();
updateDisplay();
