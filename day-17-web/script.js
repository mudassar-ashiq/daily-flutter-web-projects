// Prices in Pakistani rupees, as listed in the shop.
var PRODUCTS = [
  { id: 1, name: "Basmati Rice", unit: "1 kg pack", price: 340, category: "groceries" },
  { id: 2, name: "Wheat Flour (Atta)", unit: "5 kg bag", price: 620, category: "groceries" },
  { id: 3, name: "Cooking Oil", unit: "1 litre bottle", price: 560, category: "groceries" },
  { id: 4, name: "Sugar", unit: "1 kg pack", price: 175, category: "groceries" },
  { id: 5, name: "Red Lentils (Masoor Daal)", unit: "1 kg pack", price: 290, category: "groceries" },
  { id: 6, name: "Tea (Patti)", unit: "450 g pack", price: 640, category: "groceries" },
  { id: 7, name: "Fresh Milk", unit: "1 litre", price: 220, category: "dairy" },
  { id: 8, name: "Eggs", unit: "dozen", price: 300, category: "dairy" },
  { id: 9, name: "Butter", unit: "200 g pack", price: 480, category: "dairy" },
  { id: 10, name: "Yogurt (Dahi)", unit: "500 g cup", price: 150, category: "dairy" },
  { id: 11, name: "Laundry Detergent", unit: "1 kg pack", price: 420, category: "household" },
  { id: 12, name: "Dishwashing Liquid", unit: "500 ml bottle", price: 260, category: "household" },
  { id: 13, name: "Toilet Paper", unit: "pack of 4 rolls", price: 310, category: "household" },
  { id: 14, name: "Bath Soap", unit: "3 bars", price: 240, category: "personal" },
  { id: 15, name: "Shampoo", unit: "400 ml bottle", price: 550, category: "personal" },
  { id: 16, name: "Toothpaste", unit: "140 g tube", price: 280, category: "personal" }
];

var FREE_DELIVERY_OVER = 1000;
var DELIVERY_FEE = 100;
var STORAGE_KEY = "mohallah-store-cart";

// The cart is an object: product id -> quantity.
var cart = loadCart();
var activeCategory = "all";
var searchText = "";

function loadCart() {
  try {
    var saved = localStorage.getItem(STORAGE_KEY);
    return saved ? JSON.parse(saved) : {};
  } catch (e) {
    return {};
  }
}

function saveCart() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(cart));
}

function formatRs(amount) {
  return "Rs " + amount.toLocaleString("en-PK");
}

function findProduct(id) {
  return PRODUCTS.find(function (p) { return p.id === id; });
}

function filteredProducts() {
  var query = searchText.trim().toLowerCase();
  return PRODUCTS.filter(function (p) {
    var inCategory = activeCategory === "all" || p.category === activeCategory;
    var matchesSearch = !query ||
      p.name.toLowerCase().indexOf(query) !== -1 ||
      p.unit.toLowerCase().indexOf(query) !== -1;
    return inCategory && matchesSearch;
  });
}

function renderProducts() {
  var grid = document.getElementById("product-grid");
  var list = filteredProducts();
  document.getElementById("no-results").hidden = list.length > 0;
  grid.innerHTML = "";

  list.forEach(function (p) {
    var card = document.createElement("article");
    card.className = "card";

    var name = document.createElement("h3");
    name.textContent = p.name;
    var unit = document.createElement("p");
    unit.className = "unit";
    unit.textContent = p.unit;

    var row = document.createElement("div");
    row.className = "price-row";
    var price = document.createElement("span");
    price.className = "price";
    price.textContent = formatRs(p.price);
    var button = document.createElement("button");
    button.type = "button";
    button.className = "add-button";
    button.textContent = "Add to cart";
    button.addEventListener("click", function () { addToCart(p.id); });

    row.appendChild(price);
    row.appendChild(button);
    card.appendChild(name);
    card.appendChild(unit);
    card.appendChild(row);
    grid.appendChild(card);
  });
}

function cartItemCount() {
  return Object.keys(cart).reduce(function (total, id) {
    return total + cart[id];
  }, 0);
}

function cartSubtotal() {
  return Object.keys(cart).reduce(function (total, id) {
    var product = findProduct(Number(id));
    return product ? total + product.price * cart[id] : total;
  }, 0);
}

function renderCart() {
  var items = document.getElementById("cart-items");
  var count = cartItemCount();
  var subtotal = cartSubtotal();

  document.getElementById("cart-count").textContent = count;
  document.getElementById("cart-empty").hidden = count > 0;
  document.getElementById("cart-summary").hidden = count === 0;
  items.innerHTML = "";

  Object.keys(cart).forEach(function (id) {
    var product = findProduct(Number(id));
    if (!product) return;

    var li = document.createElement("li");

    var info = document.createElement("div");
    var name = document.createElement("div");
    name.className = "item-name";
    name.textContent = product.name;
    var price = document.createElement("div");
    price.className = "item-price";
    price.textContent = formatRs(product.price) + " each";
    info.appendChild(name);
    info.appendChild(price);

    var controls = document.createElement("div");
    controls.className = "qty-controls";

    var minus = document.createElement("button");
    minus.type = "button";
    minus.textContent = "−";
    minus.setAttribute("aria-label", "One less " + product.name);
    minus.addEventListener("click", function () { changeQuantity(product.id, -1); });

    var qty = document.createElement("span");
    qty.textContent = cart[id];

    var plus = document.createElement("button");
    plus.type = "button";
    plus.textContent = "+";
    plus.setAttribute("aria-label", "One more " + product.name);
    plus.addEventListener("click", function () { changeQuantity(product.id, 1); });

    var lineTotal = document.createElement("span");
    lineTotal.textContent = formatRs(product.price * cart[id]);

    controls.appendChild(minus);
    controls.appendChild(qty);
    controls.appendChild(plus);
    li.appendChild(info);
    li.appendChild(controls);
    li.appendChild(lineTotal);
    items.appendChild(li);
  });

  var delivery = subtotal >= FREE_DELIVERY_OVER || subtotal === 0 ? 0 : DELIVERY_FEE;
  document.getElementById("summary-items").textContent = count;
  document.getElementById("summary-subtotal").textContent = formatRs(subtotal);
  document.getElementById("summary-delivery").textContent =
    delivery === 0 ? "Free" : formatRs(delivery);
  document.getElementById("summary-total").textContent = formatRs(subtotal + delivery);

  var note = document.getElementById("delivery-note");
  if (subtotal >= FREE_DELIVERY_OVER) {
    note.textContent = "Your order qualifies for free delivery.";
  } else if (subtotal > 0) {
    note.textContent = "Add " + formatRs(FREE_DELIVERY_OVER - subtotal) +
      " more for free delivery.";
  } else {
    note.textContent = "";
  }
}

function addToCart(id) {
  cart[id] = (cart[id] || 0) + 1;
  saveCart();
  renderCart();
  document.getElementById("order-message").hidden = true;
}

function changeQuantity(id, delta) {
  cart[id] = (cart[id] || 0) + delta;
  if (cart[id] <= 0) delete cart[id];
  saveCart();
  renderCart();
}

function openCart() { document.getElementById("cart-panel").hidden = false; }
function closeCart() { document.getElementById("cart-panel").hidden = true; }

document.getElementById("cart-toggle").addEventListener("click", openCart);
document.getElementById("cart-close").addEventListener("click", closeCart);

document.getElementById("clear-cart").addEventListener("click", function () {
  cart = {};
  saveCart();
  renderCart();
  document.getElementById("order-message").hidden = true;
});

document.getElementById("checkout").addEventListener("click", function () {
  var message = document.getElementById("order-message");
  var total = document.getElementById("summary-total").textContent;
  message.textContent = "Order placed. Total " + total +
    " — the shop will call you to confirm delivery.";
  message.hidden = false;
  cart = {};
  saveCart();
  renderCart();
});

document.getElementById("search").addEventListener("input", function (event) {
  searchText = event.target.value;
  renderProducts();
});

document.querySelectorAll("#category-filters .filter").forEach(function (button) {
  button.addEventListener("click", function () {
    document.querySelectorAll("#category-filters .filter").forEach(function (b) {
      b.classList.remove("active");
    });
    button.classList.add("active");
    activeCategory = button.getAttribute("data-category");
    renderProducts();
  });
});

// Escape closes the cart panel.
document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") closeCart();
});

renderProducts();
renderCart();
