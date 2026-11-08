// Tasks are kept in localStorage so they survive a page refresh.
const STORAGE_KEY = "today-todo-tasks";

const form = document.getElementById("add-form");
const input = document.getElementById("new-task");
const error = document.getElementById("form-error");
const list = document.getElementById("task-list");
const emptyMessage = document.getElementById("empty-message");
const count = document.getElementById("count");
const clearDoneButton = document.getElementById("clear-done");
const filterButtons = document.querySelectorAll(".filters button");

let tasks = loadTasks();
let currentFilter = "all";

function loadTasks() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY));
    return Array.isArray(saved) ? saved : [];
  } catch {
    return [];
  }
}

function saveTasks() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks));
}

function addTask(text) {
  tasks.push({ id: Date.now(), text, done: false });
  saveTasks();
  render();
}

function render() {
  const visible = tasks.filter((task) => {
    if (currentFilter === "active") return !task.done;
    if (currentFilter === "done") return task.done;
    return true;
  });

  list.innerHTML = "";
  visible.forEach((task) => {
    const item = document.createElement("li");
    if (task.done) item.classList.add("done");

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = task.done;
    checkbox.setAttribute("aria-label", "Mark done: " + task.text);
    checkbox.addEventListener("change", () => {
      task.done = checkbox.checked;
      saveTasks();
      render();
    });

    const label = document.createElement("span");
    label.className = "task-text";
    label.textContent = task.text;

    const deleteButton = document.createElement("button");
    deleteButton.type = "button";
    deleteButton.className = "delete";
    deleteButton.textContent = "×";
    deleteButton.setAttribute("aria-label", "Delete: " + task.text);
    deleteButton.addEventListener("click", () => {
      tasks = tasks.filter((t) => t.id !== task.id);
      saveTasks();
      render();
    });

    item.append(checkbox, label, deleteButton);
    list.appendChild(item);
  });

  emptyMessage.hidden = visible.length > 0;
  emptyMessage.textContent =
    tasks.length === 0
      ? "Nothing here yet. Add your first task above."
      : "Nothing in this view.";

  const left = tasks.filter((task) => !task.done).length;
  count.textContent = left === 1 ? "1 task left" : left + " tasks left";
}

form.addEventListener("submit", (event) => {
  event.preventDefault();
  const text = input.value.trim();
  if (!text) {
    error.hidden = false;
    input.focus();
    return;
  }
  error.hidden = true;
  addTask(text);
  input.value = "";
  input.focus();
});

input.addEventListener("input", () => {
  error.hidden = true;
});

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    currentFilter = button.dataset.filter;
    filterButtons.forEach((b) => b.classList.toggle("active", b === button));
    render();
  });
});

clearDoneButton.addEventListener("click", () => {
  tasks = tasks.filter((task) => !task.done);
  saveTasks();
  render();
});

render();
