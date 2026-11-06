// Fresh Oven Bakery — small bits of behaviour for the landing page.

// Mobile navigation toggle
var navToggle = document.getElementById("navToggle");
var mainNav = document.getElementById("mainNav");

navToggle.addEventListener("click", function () {
  var open = mainNav.classList.toggle("open");
  navToggle.setAttribute("aria-expanded", open ? "true" : "false");
  navToggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
});

// Close the mobile menu when a link is tapped
mainNav.querySelectorAll("a").forEach(function (link) {
  link.addEventListener("click", function () {
    mainNav.classList.remove("open");
    navToggle.setAttribute("aria-expanded", "false");
  });
});

// Today's special, based on the day of the week
var specials = {
  0: "Sunday special: buy any cake by the slice, get a rusk pack half price.",
  1: "Monday: fresh whole wheat bread is out of the oven at 8 am.",
  2: "Tuesday: chicken patties are two for Rs 120 until noon.",
  3: "Wednesday: chocolate fudge cake slices, Rs 180 while they last.",
  4: "Thursday: order a whole cake today and pick it up on Friday.",
  5: "Friday: we are closed 12:30 to 2:00 pm, then baking until 9 pm.",
  6: "Saturday: the busiest day — order ahead if you need a whole cake."
};

var note = document.getElementById("specialNote");
note.textContent = specials[new Date().getDay()];

// Order form: simple checks, then a confirmation message.
// There is no server behind this page, so the order is shown back
// to the customer as a summary they can read out at the counter.
var form = document.getElementById("orderForm");
var errorBox = document.getElementById("formError");
var successBox = document.getElementById("formSuccess");

form.addEventListener("submit", function (event) {
  event.preventDefault();

  var name = document.getElementById("name").value.trim();
  var phone = document.getElementById("phone").value.trim();
  var pickupTime = document.getElementById("pickupTime").value;
  var details = document.getElementById("orderDetails").value.trim();

  var error = "";
  if (!name) {
    error = "Please add your name so we know who the order is for.";
  } else if (!phone || phone.replace(/[^0-9]/g, "").length < 10) {
    error = "Please add a valid phone number so we can call to confirm.";
  } else if (!pickupTime) {
    error = "Please choose a pickup time.";
  } else if (!details) {
    error = "Please tell us what you would like to order.";
  }

  if (error) {
    errorBox.textContent = error;
    errorBox.hidden = false;
    successBox.hidden = true;
    return;
  }

  errorBox.hidden = true;
  successBox.textContent =
    "Thanks, " + name + ". Your order for " + pickupTime +
    " is noted. We will call " + phone +
    " to confirm — please mention your name at the counter.";
  successBox.hidden = false;
  form.reset();
});
