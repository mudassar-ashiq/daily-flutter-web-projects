// Mobile menu: show/hide the nav when the button is clicked
var menuBtn = document.getElementById('menuBtn');
var mainNav = document.getElementById('mainNav');

menuBtn.addEventListener('click', function () {
  mainNav.classList.toggle('open');
});

// Close the mobile menu after picking a section
var navLinks = mainNav.querySelectorAll('a');
navLinks.forEach(function (link) {
  link.addEventListener('click', function () {
    mainNav.classList.remove('open');
  });
});

// Footer year
document.getElementById('year').textContent = new Date().getFullYear();
