// Menu data — prices in Pakistani rupees.
const menu = [
  { name: "Chicken Corn Soup", category: "starters", price: 350, desc: "Slow-cooked chicken soup with sweetcorn and egg ribbons.", tags: [] },
  { name: "Vegetable Samosa (2 pc)", category: "starters", price: 200, desc: "Crisp pastry filled with spiced potatoes and peas, served with imli chutney.", tags: ["veg"] },
  { name: "Chicken Wings", category: "starters", price: 550, desc: "Fried wings tossed in a mild chilli sauce.", tags: ["spicy"] },
  { name: "Chicken Tikka", category: "bbq", price: 450, desc: "Whole leg piece marinated overnight and grilled over charcoal.", tags: ["spicy", "chef"] },
  { name: "Beef Seekh Kabab (4 pc)", category: "bbq", price: 650, desc: "Hand-minced beef kababs with green chillies and fresh coriander.", tags: ["spicy"] },
  { name: "Malai Boti", category: "bbq", price: 750, desc: "Creamy, mild chicken cubes — good for anyone who avoids spice.", tags: ["chef"] },
  { name: "Chicken Karahi (Half)", category: "karahi", price: 950, desc: "Desi chicken cooked in a wok with tomatoes, ginger and green chillies.", tags: ["spicy", "chef"] },
  { name: "Mutton Karahi (Half)", category: "karahi", price: 1450, desc: "Mutton on the bone, cooked the same way as our chicken karahi.", tags: ["spicy"] },
  { name: "Daal Makhani", category: "karahi", price: 450, desc: "Black lentils simmered with butter and cream.", tags: ["veg"] },
  { name: "Chicken Biryani", category: "rice", price: 400, desc: "Basmati rice layered with chicken masala, served with raita and salad.", tags: ["spicy"] },
  { name: "Beef Pulao", category: "rice", price: 550, desc: "Mild beef pulao with whole spices, served with raita.", tags: [] },
  { name: "Vegetable Fried Rice", category: "rice", price: 450, desc: "Rice tossed with mixed vegetables and soya sauce.", tags: ["veg"] },
  { name: "Tandoori Naan", category: "breads", price: 60, desc: "Baked fresh in the tandoor.", tags: ["veg"] },
  { name: "Roghni Naan", category: "breads", price: 90, desc: "Naan brushed with sesame seeds and a little butter.", tags: ["veg"] },
  { name: "Raita", category: "breads", price: 120, desc: "Yogurt with cucumber and a pinch of roasted cumin.", tags: ["veg"] },
  { name: "Fresh Limes Soda", category: "drinks", price: 180, desc: "Sweet or salted, made to order.", tags: [] },
  { name: "Sweet Lassi", category: "drinks", price: 220, desc: "Thick yogurt lassi with a little sugar.", tags: [] },
  { name: "Soft Drink (345 ml)", category: "drinks", price: 120, desc: "Chilled bottle, your choice of flavour.", tags: [] },
  { name: "Gulab Jamun (2 pc)", category: "desserts", price: 200, desc: "Warm milk dumplings in light syrup.", tags: ["veg"] },
  { name: "Kheer", category: "desserts", price: 250, desc: "Slow-cooked rice pudding with pistachio on top.", tags: ["veg"] },
];

const categoryNames = {
  starters: "Starters",
  bbq: "BBQ",
  karahi: "Karahi & Handi",
  rice: "Rice",
  breads: "Breads & Sides",
  drinks: "Drinks",
  desserts: "Desserts",
};

const grid = document.getElementById("menu-grid");
const resultsLine = document.getElementById("results-line");
const searchInput = document.getElementById("search");
const order = new Map(); // dish name -> quantity

let activeCategory = "all";

function formatRs(amount) {
  return "Rs " + amount.toLocaleString("en-PK");
}

function tagLabel(tag) {
  if (tag === "veg") return "Veg";
  if (tag === "spicy") return "Spicy";
  return "Chef's pick";
}

function renderMenu() {
  const query = searchInput.value.trim().toLowerCase();
  const shown = menu.filter((dish) => {
    const inCategory = activeCategory === "all" || dish.category === activeCategory;
    const matches = !query || dish.name.toLowerCase().includes(query)
      || dish.desc.toLowerCase().includes(query);
    return inCategory && matches;
  });

  if (activeCategory === "all" && !query) {
    resultsLine.textContent = "Showing all " + shown.length + " dishes.";
  } else if (query) {
    resultsLine.textContent = shown.length + " dish" + (shown.length === 1 ? "" : "es")
      + " matching “" + searchInput.value.trim() + "”.";
  } else {
    resultsLine.textContent = "Showing " + categoryNames[activeCategory] + " — "
      + shown.length + " dish" + (shown.length === 1 ? "" : "es") + ".";
  }

  if (shown.length === 0) {
    grid.innerHTML = '<p class="no-results">No dishes match that. Try a different word or category.</p>';
    return;
  }

  grid.innerHTML = shown.map((dish) => {
    const tags = dish.tags.map((t) =>
      '<span class="tag ' + t + '">' + tagLabel(t) + "</span>").join("");
    return '<article class="dish">'
      + "<h3>" + dish.name + "</h3>"
      + '<p class="desc">' + dish.desc + "</p>"
      + '<div class="tags">' + tags + "</div>"
      + '<div class="dish-foot"><span class="price">' + formatRs(dish.price) + "</span>"
      + '<button class="add-btn" data-name="' + dish.name + '">Add</button></div>'
      + "</article>";
  }).join("");
}

function renderOrder() {
  const list = document.getElementById("order-list");
  const empty = document.getElementById("order-empty");
  const totalRow = document.getElementById("order-total");
  const clearBtn = document.getElementById("clear-order");

  if (order.size === 0) {
    list.innerHTML = "";
    empty.hidden = false;
    totalRow.hidden = true;
    clearBtn.hidden = true;
    return;
  }

  let total = 0;
  list.innerHTML = [...order.entries()].map(([name, qty]) => {
    const dish = menu.find((d) => d.name === name);
    total += dish.price * qty;
    return "<li><span>" + name + " &times; " + qty + "</span>"
      + '<span class="qty-controls">'
      + '<button class="qty-btn" data-name="' + name + '" data-change="-1" aria-label="Remove one">−</button>'
      + "<span>" + formatRs(dish.price * qty) + "</span>"
      + '<button class="qty-btn" data-name="' + name + '" data-change="1" aria-label="Add one">+</button>'
      + "</span></li>";
  }).join("");

  document.getElementById("total-amount").textContent = formatRs(total);
  empty.hidden = true;
  totalRow.hidden = false;
  clearBtn.hidden = false;
}

document.getElementById("filters").addEventListener("click", (event) => {
  const btn = event.target.closest(".filter-btn");
  if (!btn) return;
  document.querySelectorAll(".filter-btn").forEach((b) => b.classList.remove("active"));
  btn.classList.add("active");
  activeCategory = btn.dataset.category;
  renderMenu();
});

searchInput.addEventListener("input", renderMenu);

grid.addEventListener("click", (event) => {
  const btn = event.target.closest(".add-btn");
  if (!btn) return;
  const name = btn.dataset.name;
  order.set(name, (order.get(name) || 0) + 1);
  renderOrder();
});

document.getElementById("order-list").addEventListener("click", (event) => {
  const btn = event.target.closest(".qty-btn");
  if (!btn) return;
  const name = btn.dataset.name;
  const next = (order.get(name) || 0) + Number(btn.dataset.change);
  if (next <= 0) order.delete(name);
  else order.set(name, next);
  renderOrder();
});

document.getElementById("clear-order").addEventListener("click", () => {
  order.clear();
  renderOrder();
});

renderMenu();
renderOrder();
