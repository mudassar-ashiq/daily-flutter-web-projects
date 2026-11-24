// Layout practice page: two small toggles so the layouts can be compared.

// Switch the examples section between grid and flexbox.
var layoutToggle = document.getElementById("layoutToggle");
var exampleGrid = document.getElementById("exampleGrid");
var layoutNote = document.getElementById("layoutNote");

layoutToggle.addEventListener("click", function () {
  var nowFlex = exampleGrid.classList.toggle("as-flex");

  if (nowFlex) {
    layoutToggle.textContent = "Show as grid";
    layoutNote.textContent = "Currently using flexbox: the boxes wrap " +
      "onto new lines, and the wide box just takes about twice the space.";
  } else {
    layoutToggle.textContent = "Show as flexbox";
    layoutNote.textContent = "Currently using grid: three columns, with " +
      "the wide box spanning two of them.";
  }
});

// Hide or show the sidebar in the two-column section.
var sidebarToggle = document.getElementById("sidebarToggle");
var twoColumn = document.querySelector(".two-column");

sidebarToggle.addEventListener("click", function () {
  var hidden = twoColumn.classList.toggle("sidebar-hidden");
  sidebarToggle.textContent = hidden ? "Show sidebar" : "Hide sidebar";
});
