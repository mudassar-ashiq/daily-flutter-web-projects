const form = document.getElementById("signup-form");
const successBox = document.getElementById("success");
const formError = document.getElementById("form-error");

const fields = {
  "full-name": document.getElementById("full-name"),
  email: document.getElementById("email"),
  phone: document.getElementById("phone"),
  dob: document.getElementById("dob"),
  course: document.getElementById("course"),
  password: document.getElementById("password"),
  "confirm-password": document.getElementById("confirm-password"),
  terms: document.getElementById("terms"),
};

function showError(id, message) {
  const input = fields[id];
  const errorEl = document.getElementById(id + "-error");
  errorEl.textContent = message;
  if (input.type !== "checkbox") {
    input.classList.toggle("invalid", message !== "");
    input.classList.toggle("valid", message === "");
  }
  return message === "";
}

// Each check returns an error message, or "" when the value is fine.
const validators = {
  "full-name"(value) {
    const name = value.trim();
    if (name === "") return "Please enter your full name.";
    if (name.length < 3) return "Name is too short.";
    if (!/^[a-zA-Z][a-zA-Z .'-]*$/.test(name)) {
      return "Name can only contain letters, spaces, hyphens and apostrophes.";
    }
    return "";
  },
  email(value) {
    const email = value.trim();
    if (email === "") return "Please enter your email address.";
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
      return "That email address does not look right.";
    }
    return "";
  },
  phone(value) {
    const digits = value.replace(/[\s-]/g, "");
    if (digits === "") return "Please enter your phone number.";
    if (!/^03\d{9}$/.test(digits)) {
      return "Enter an 11-digit mobile starting with 03, e.g. 0300 1234567.";
    }
    return "";
  },
  dob(value) {
    if (value === "") return "Please enter your date of birth.";
    const birth = new Date(value);
    const today = new Date();
    if (birth > today) return "Date of birth cannot be in the future.";
    let age = today.getFullYear() - birth.getFullYear();
    const hadBirthday =
      today.getMonth() > birth.getMonth() ||
      (today.getMonth() === birth.getMonth() && today.getDate() >= birth.getDate());
    if (!hadBirthday) age -= 1;
    if (age < 16) return "You must be at least 16 to register.";
    return "";
  },
  course(value) {
    if (value === "") return "Please choose a course.";
    return "";
  },
  password(value) {
    if (value === "") return "Please choose a password.";
    if (value.length < 8) return "Password must be at least 8 characters.";
    if (!/[a-zA-Z]/.test(value) || !/\d/.test(value)) {
      return "Password needs at least one letter and one number.";
    }
    return "";
  },
  "confirm-password"(value) {
    if (value === "") return "Please type the password again.";
    if (value !== fields.password.value) return "Passwords do not match.";
    return "";
  },
  terms(checked) {
    if (!checked) return "You need to agree to the terms to register.";
    return "";
  },
};

function validateField(id) {
  const input = fields[id];
  const value = input.type === "checkbox" ? input.checked : input.value;
  return showError(id, validators[id](value));
}

function validateAll() {
  let firstBad = null;
  for (const id of Object.keys(fields)) {
    const ok = validateField(id);
    if (!ok && !firstBad) firstBad = fields[id];
  }
  return firstBad;
}

// Check a field when the user leaves it, and re-check it as they fix it.
for (const id of Object.keys(fields)) {
  const input = fields[id];
  input.addEventListener("blur", () => validateField(id));
  input.addEventListener("input", () => {
    if (input.classList.contains("invalid")) validateField(id);
    if (id === "password") updateStrength();
    if (id === "password" && fields["confirm-password"].value !== "") {
      validateField("confirm-password");
    }
  });
  input.addEventListener("change", () => {
    if (id === "course" || id === "terms" || id === "dob") validateField(id);
  });
}

function updateStrength() {
  const box = document.getElementById("strength");
  const fill = document.getElementById("strength-fill");
  const label = document.getElementById("strength-label");
  const value = fields.password.value;

  if (value === "") {
    box.hidden = true;
    return;
  }
  box.hidden = false;

  let score = 0;
  if (value.length >= 8) score += 1;
  if (value.length >= 12) score += 1;
  if (/[a-z]/.test(value) && /[A-Z]/.test(value)) score += 1;
  if (/\d/.test(value)) score += 1;
  if (/[^a-zA-Z0-9]/.test(value)) score += 1;

  const width = Math.min(100, (score / 5) * 100);
  fill.style.width = width + "%";
  if (score <= 2) {
    fill.className = "";
    label.textContent = "Weak";
  } else if (score <= 3) {
    fill.className = "medium";
    label.textContent = "Okay";
  } else {
    fill.className = "strong";
    label.textContent = "Strong";
  }
}

form.addEventListener("submit", (event) => {
  event.preventDefault();
  formError.textContent = "";
  const firstBad = validateAll();

  if (firstBad) {
    formError.textContent = "Some fields still need fixing — check the messages above.";
    firstBad.focus();
    return;
  }

  const courseText = fields.course.options[fields.course.selectedIndex].text;
  document.getElementById("success-name").textContent = fields["full-name"].value.trim();
  document.getElementById("success-course").textContent = courseText;
  document.getElementById("success-email").textContent = fields.email.value.trim();
  form.hidden = true;
  successBox.hidden = false;
  successBox.scrollIntoView();
});

document.getElementById("clear-btn").addEventListener("click", () => {
  form.reset();
  document.getElementById("strength").hidden = true;
  formError.textContent = "";
  for (const id of Object.keys(fields)) {
    showError(id, "");
  }
  fields["full-name"].focus();
});

document.getElementById("again-btn").addEventListener("click", () => {
  form.reset();
  document.getElementById("strength").hidden = true;
  for (const id of Object.keys(fields)) {
    showError(id, "");
  }
  successBox.hidden = true;
  form.hidden = false;
  fields["full-name"].focus();
});
