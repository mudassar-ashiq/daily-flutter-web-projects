// Simple calculator: keeps the current number, the previous number and
// the pending operator, and works the way a pocket calculator does.

const expressionEl = document.getElementById('expression');
const resultEl = document.getElementById('result');
const historyList = document.getElementById('history-list');
const emptyHistoryEl = document.getElementById('empty-history');
const clearHistoryBtn = document.getElementById('clear-history');

const OPERATORS = {
  add: { symbol: '+', fn: (a, b) => a + b },
  subtract: { symbol: '−', fn: (a, b) => a - b },
  multiply: { symbol: '×', fn: (a, b) => a * b },
  divide: { symbol: '÷', fn: (a, b) => a / b }
};

let current = '0';
let previous = null;
let operator = null;
let justCalculated = false;
let history = loadHistory();

function loadHistory() {
  try {
    return JSON.parse(localStorage.getItem('calculator-history')) || [];
  } catch (e) {
    return [];
  }
}

function saveHistory() {
  localStorage.setItem('calculator-history', JSON.stringify(history.slice(0, 20)));
}

function formatNumber(value) {
  if (!isFinite(value)) return 'Error';
  // Round off the usual floating point noise, e.g. 0.1 + 0.2.
  const rounded = Math.round(value * 1e10) / 1e10;
  return String(rounded);
}

function updateDisplay() {
  resultEl.textContent = current;
  if (operator && previous !== null) {
    expressionEl.textContent = previous + ' ' + OPERATORS[operator].symbol;
  } else {
    expressionEl.textContent = '\u00a0';
  }
}

function enterDigit(digit) {
  if (justCalculated) {
    current = '0';
    justCalculated = false;
  }
  if (current === '0' && digit !== '0') {
    current = digit;
  } else if (current.replace('-', '').length < 12) {
    current += digit;
  }
  updateDisplay();
}

function enterDecimal() {
  if (justCalculated) {
    current = '0';
    justCalculated = false;
  }
  if (!current.includes('.')) {
    current += '.';
  }
  updateDisplay();
}

function applyOperator(nextOperator) {
  if (operator && previous !== null && !justCalculated) {
    calculate();
  }
  previous = current;
  operator = nextOperator;
  current = '0';
  justCalculated = false;
  updateDisplay();
}

function calculate() {
  if (!operator || previous === null) return;
  const a = parseFloat(previous);
  const b = parseFloat(current);
  const answer = OPERATORS[operator].fn(a, b);
  const sum = previous + ' ' + OPERATORS[operator].symbol + ' ' + current;
  const value = formatNumber(answer);

  if (value !== 'Error') {
    history.unshift({ sum: sum, value: value });
    saveHistory();
    renderHistory();
  }

  current = value === 'Error' ? '0' : value;
  previous = null;
  operator = null;
  justCalculated = true;
  expressionEl.textContent = value === 'Error' ? 'Cannot divide by zero' : sum + ' =';
  resultEl.textContent = value === 'Error' ? 'Error' : value;
}

function clearAll() {
  current = '0';
  previous = null;
  operator = null;
  justCalculated = false;
  updateDisplay();
}

function backspace() {
  if (justCalculated) {
    clearAll();
    return;
  }
  current = current.length > 1 ? current.slice(0, -1) : '0';
  if (current === '-') current = '0';
  updateDisplay();
}

function renderHistory() {
  historyList.innerHTML = '';
  emptyHistoryEl.style.display = history.length ? 'none' : 'block';

  history.forEach(function (item) {
    const li = document.createElement('li');
    const sum = document.createElement('span');
    sum.className = 'sum';
    sum.textContent = item.sum + ' =';
    const value = document.createElement('span');
    value.className = 'value';
    value.textContent = item.value;
    li.appendChild(sum);
    li.appendChild(value);
    // Clicking a past answer puts it back into the calculator.
    li.addEventListener('click', function () {
      current = item.value;
      justCalculated = false;
      updateDisplay();
    });
    historyList.appendChild(li);
  });
}

document.querySelectorAll('.key').forEach(function (button) {
  button.addEventListener('click', function () {
    if (button.dataset.digit !== undefined) {
      enterDigit(button.dataset.digit);
    } else {
      const actions = {
        clear: clearAll,
        backspace: backspace,
        decimal: enterDecimal,
        equals: calculate,
        percent: function () {
          current = formatNumber(parseFloat(current) / 100);
          updateDisplay();
        },
        negate: function () {
          if (current !== '0') {
            current = current.startsWith('-') ? current.slice(1) : '-' + current;
          }
          updateDisplay();
        }
      };
      if (OPERATORS[button.dataset.action]) {
        applyOperator(button.dataset.action);
      } else if (actions[button.dataset.action]) {
        actions[button.dataset.action]();
      }
    }
  });
});

clearHistoryBtn.addEventListener('click', function () {
  history = [];
  saveHistory();
  renderHistory();
});

document.addEventListener('keydown', function (event) {
  const key = event.key;
  if (key >= '0' && key <= '9') {
    enterDigit(key);
  } else if (key === '.') {
    enterDecimal();
  } else if (key === '+') {
    applyOperator('add');
  } else if (key === '-') {
    applyOperator('subtract');
  } else if (key === '*') {
    applyOperator('multiply');
  } else if (key === '/') {
    event.preventDefault();
    applyOperator('divide');
  } else if (key === 'Enter' || key === '=') {
    event.preventDefault();
    calculate();
  } else if (key === 'Backspace') {
    backspace();
  } else if (key === 'Escape') {
    clearAll();
  } else if (key === '%') {
    current = formatNumber(parseFloat(current) / 100);
    updateDisplay();
  } else {
    return;
  }
  // Brief press effect so keyboard use feels like a button press.
  const pressed = document.querySelector('.key.pressed');
  if (pressed) pressed.classList.remove('pressed');
});

updateDisplay();
renderHistory();
