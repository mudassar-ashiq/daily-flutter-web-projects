// Monthly budget tracker - plain JS, state saved in localStorage.

const STORAGE_KEY = "budget-tracker-v1";
const CATEGORIES = ["Food", "Transport", "Bills", "Shopping", "Entertainment", "Other"];

const monthLabel = document.getElementById("monthLabel");
const incomeValue = document.getElementById("incomeValue");
const spentValue = document.getElementById("spentValue");
const expenseCount = document.getElementById("expenseCount");
const remainingValue = document.getElementById("remainingValue");
const remainingNote = document.getElementById("remainingNote");
const progressFill = document.getElementById("progressFill");
const percentLabel = document.getElementById("percentLabel");
const categoryList = document.getElementById("categoryList");
const expenseList = document.getElementById("expenseList");
const listEmpty = document.getElementById("listEmpty");
const expenseForm = document.getElementById("expenseForm");
const descInput = document.getElementById("descInput");
const amountInput = document.getElementById("amountInput");
const categorySelect = document.getElementById("categorySelect");
const filterSelect = document.getElementById("filterSelect");
const formError = document.getElementById("formError");

let state = loadState();

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY));
    if (saved && Array.isArray(saved.expenses)) {
      return { income: Number(saved.income) || 0, expenses: saved.expenses };
    }
  } catch (e) {
    // Corrupt save, start fresh rather than breaking the page.
  }
  return { income: 0, expenses: [] };
}

function saveState() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function formatRs(amount) {
  return "Rs " + Number(amount).toLocaleString("en-PK");
}

function totalSpent() {
  return state.expenses.reduce((sum, item) => sum + item.amount, 0);
}

function render() {
  const now = new Date();
  monthLabel.textContent = now.toLocaleString("en-GB", {
    month: "long",
    year: "numeric",
  });

  const spent = totalSpent();
  const remaining = state.income - spent;

  incomeValue.textContent = formatRs(state.income);
  spentValue.textContent = formatRs(spent);
  expenseCount.textContent =
    state.expenses.length + (state.expenses.length === 1 ? " expense" : " expenses");

  remainingValue.textContent = formatRs(remaining);
  remainingValue.classList.toggle("over", remaining < 0);
  if (state.income === 0) {
    remainingNote.textContent = "Set your income to see this";
  } else if (remaining < 0) {
    remainingNote.textContent = "Over budget by " + formatRs(-remaining);
  } else {
    remainingNote.textContent = "Left to spend this month";
  }

  const percent = state.income > 0 ? Math.min(100, Math.round((spent / state.income) * 100)) : 0;
  progressFill.style.width = percent + "%";
  progressFill.classList.toggle("over", state.income > 0 && spent > state.income);
  progressFill.classList.toggle("warning", state.income > 0 && spent <= state.income && percent >= 80);
  percentLabel.textContent = percent + "%";

  renderCategories(spent);
  renderExpenses();
}

function renderCategories(spent) {
  if (state.expenses.length === 0) {
    categoryList.innerHTML =
      '<p class="empty">No expenses yet. Add one and the breakdown will show here.</p>';
    return;
  }

  const totals = {};
  state.expenses.forEach((item) => {
    totals[item.category] = (totals[item.category] || 0) + item.amount;
  });

  categoryList.innerHTML = "";
  CATEGORIES.forEach((category) => {
    if (!totals[category]) return;
    const share = Math.round((totals[category] / spent) * 100);

    const row = document.createElement("div");
    row.className = "category-row";

    const top = document.createElement("div");
    top.className = "category-top";
    const name = document.createElement("span");
    name.textContent = category;
    const value = document.createElement("span");
    value.textContent = formatRs(totals[category]) + " (" + share + "%)";
    top.append(name, value);

    const bar = document.createElement("div");
    bar.className = "category-bar";
    const fill = document.createElement("div");
    fill.className = "category-fill";
    fill.style.width = share + "%";
    bar.appendChild(fill);

    row.append(top, bar);
    categoryList.appendChild(row);
  });
}

function renderExpenses() {
  const filter = filterSelect.value;
  const visible = state.expenses.filter(
    (item) => filter === "all" || item.category === filter
  );

  expenseList.innerHTML = "";
  listEmpty.hidden = visible.length > 0;

  visible.forEach((item) => {
    const li = document.createElement("li");

    const info = document.createElement("div");
    info.className = "expense-info";
    const desc = document.createElement("span");
    desc.className = "expense-desc";
    desc.textContent = item.desc;
    const meta = document.createElement("span");
    meta.className = "expense-meta";
    meta.textContent = item.category + " · " + item.date;
    info.append(desc, meta);

    const right = document.createElement("div");
    right.className = "expense-right";
    const amount = document.createElement("span");
    amount.className = "expense-amount";
    amount.textContent = formatRs(item.amount);
    const del = document.createElement("button");
    del.type = "button";
    del.className = "delete-btn";
    del.textContent = "Delete";
    del.addEventListener("click", () => {
      state.expenses = state.expenses.filter((e) => e.id !== item.id);
      saveState();
      render();
    });
    right.append(amount, del);

    li.append(info, right);
    expenseList.appendChild(li);
  });
}

expenseForm.addEventListener("submit", (event) => {
  event.preventDefault();

  const desc = descInput.value.trim();
  const amount = Number(amountInput.value);

  if (!desc) {
    formError.textContent = "Please write what the expense was for.";
    formError.hidden = false;
    return;
  }
  if (!amount || amount <= 0) {
    formError.textContent = "Please enter an amount above Rs 0.";
    formError.hidden = false;
    return;
  }

  state.expenses.unshift({
    id: Date.now(),
    desc: desc,
    amount: Math.round(amount),
    category: categorySelect.value,
    date: new Date().toLocaleDateString("en-GB", {
      day: "numeric",
      month: "short",
    }),
  });

  saveState();
  expenseForm.reset();
  formError.hidden = true;
  descInput.focus();
  render();
});

filterSelect.addEventListener("change", renderExpenses);

document.getElementById("editIncomeBtn").addEventListener("click", () => {
  const value = prompt("Monthly income (Rs):", state.income || "");
  if (value === null) return; // cancelled
  const amount = Math.round(Number(value));
  if (!amount || amount < 0) {
    alert("Please enter a valid amount.");
    return;
  }
  state.income = amount;
  saveState();
  render();
});

document.getElementById("newMonthBtn").addEventListener("click", () => {
  if (!confirm("Start a new month? This clears all expenses for this month.")) return;
  state.expenses = [];
  saveState();
  render();
});

render();
