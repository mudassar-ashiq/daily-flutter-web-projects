// Question bank: four questions per category.
const QUESTIONS = [
  {
    category: "general",
    question: "What is the capital of Pakistan?",
    options: ["Lahore", "Karachi", "Islamabad", "Rawalpindi"],
    answer: 2
  },
  {
    category: "general",
    question: "Which is the largest ocean in the world?",
    options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
    answer: 3
  },
  {
    category: "general",
    question: "How many days are there in a leap year?",
    options: ["365", "366", "364", "367"],
    answer: 1
  },
  {
    category: "general",
    question: "Which river is the longest in Pakistan?",
    options: ["Jhelum", "Chenab", "Ravi", "Indus"],
    answer: 3
  },
  {
    category: "science",
    question: "What is the chemical symbol for water?",
    options: ["CO2", "O2", "H2O", "NaCl"],
    answer: 2
  },
  {
    category: "science",
    question: "Which planet is known as the Red Planet?",
    options: ["Venus", "Mars", "Jupiter", "Saturn"],
    answer: 1
  },
  {
    category: "science",
    question: "At what temperature does water boil at sea level?",
    options: ["90°C", "95°C", "100°C", "110°C"],
    answer: 2
  },
  {
    category: "science",
    question: "Which gas do plants take in from the air?",
    options: ["Oxygen", "Nitrogen", "Hydrogen", "Carbon dioxide"],
    answer: 3
  },
  {
    category: "computing",
    question: "What does CPU stand for?",
    options: [
      "Central Processing Unit",
      "Computer Personal Unit",
      "Central Program Utility",
      "Control Processing Unit"
    ],
    answer: 0
  },
  {
    category: "computing",
    question: "What does HTML stand for?",
    options: [
      "Hyper Text Markup Language",
      "High Text Machine Language",
      "Hyperlink Text Marking Language",
      "Home Tool Markup Language"
    ],
    answer: 0
  },
  {
    category: "computing",
    question: "Which of these is a programming language?",
    options: ["HTTP", "Python", "HTML", "USB"],
    answer: 1
  },
  {
    category: "computing",
    question: "What does RAM stand for?",
    options: [
      "Read And Modify",
      "Random Access Memory",
      "Run All Machines",
      "Rapid Application Module"
    ],
    answer: 1
  }
];

const TIME_PER_QUESTION = 20;

const startScreen = document.getElementById("start-screen");
const questionScreen = document.getElementById("question-screen");
const resultScreen = document.getElementById("result-screen");
const questionText = document.getElementById("question-text");
const optionsBox = document.getElementById("options");
const feedback = document.getElementById("feedback");
const nextBtn = document.getElementById("next-btn");
const progressText = document.getElementById("progress-text");
const progressFill = document.getElementById("progress-fill");
const timerEl = document.getElementById("timer");
const bestScoreEl = document.getElementById("best-score");

let questions = [];
let currentIndex = 0;
let score = 0;
let timeLeft = TIME_PER_QUESTION;
let timerId = null;
let answered = false;
let currentCategory = "all";
let results = [];

function shuffle(list) {
  const copy = list.slice();
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function bestScoreKey(category) {
  return "quiz-best-" + category;
}

function showBestScore() {
  const best = localStorage.getItem(bestScoreKey(currentCategory));
  if (best !== null) {
    bestScoreEl.textContent = "Your best score in this category: " + best;
  } else {
    bestScoreEl.textContent = "";
  }
}

function startQuiz(category) {
  currentCategory = category;
  questions = category === "all"
    ? shuffle(QUESTIONS)
    : shuffle(QUESTIONS.filter(function (q) { return q.category === category; }));
  currentIndex = 0;
  score = 0;
  results = [];

  startScreen.classList.add("hidden");
  resultScreen.classList.add("hidden");
  questionScreen.classList.remove("hidden");

  showQuestion();
}

function showQuestion() {
  const q = questions[currentIndex];
  answered = false;
  timeLeft = TIME_PER_QUESTION;

  questionText.textContent = q.question;
  progressText.textContent = "Question " + (currentIndex + 1) + " of " + questions.length;
  progressFill.style.width = ((currentIndex) / questions.length * 100) + "%";
  feedback.textContent = "";
  nextBtn.classList.add("hidden");

  optionsBox.innerHTML = "";
  q.options.forEach(function (option, index) {
    const btn = document.createElement("button");
    btn.className = "option-btn";
    btn.textContent = (index + 1) + ". " + option;
    btn.addEventListener("click", function () { pickAnswer(index); });
    optionsBox.appendChild(btn);
  });

  updateTimerDisplay();
  clearInterval(timerId);
  timerId = setInterval(tick, 1000);
}

function updateTimerDisplay() {
  timerEl.textContent = timeLeft + "s";
  timerEl.classList.toggle("low", timeLeft <= 5);
}

function tick() {
  timeLeft--;
  updateTimerDisplay();
  if (timeLeft <= 0) {
    clearInterval(timerId);
    timeUp();
  }
}

function timeUp() {
  if (answered) return;
  answered = true;
  const q = questions[currentIndex];
  markOptions(q.answer, -1);
  feedback.textContent = "Time ran out. The right answer was: " + q.options[q.answer];
  recordResult(q, -1);
  nextBtn.textContent = currentIndex === questions.length - 1 ? "See results" : "Next question";
  nextBtn.classList.remove("hidden");
}

function pickAnswer(index) {
  if (answered) return;
  answered = true;
  clearInterval(timerId);

  const q = questions[currentIndex];
  markOptions(q.answer, index);

  if (index === q.answer) {
    score++;
    feedback.textContent = "Correct.";
  } else {
    feedback.textContent = "Not quite. The right answer was: " + q.options[q.answer];
  }

  recordResult(q, index);
  nextBtn.textContent = currentIndex === questions.length - 1 ? "See results" : "Next question";
  nextBtn.classList.remove("hidden");
}

function markOptions(correctIndex, pickedIndex) {
  const buttons = optionsBox.querySelectorAll(".option-btn");
  buttons.forEach(function (btn, index) {
    btn.disabled = true;
    if (index === correctIndex) btn.classList.add("correct");
    if (index === pickedIndex && pickedIndex !== correctIndex) btn.classList.add("wrong");
  });
}

function recordResult(q, pickedIndex) {
  results.push({ question: q, picked: pickedIndex });
}

function nextQuestion() {
  currentIndex++;
  if (currentIndex < questions.length) {
    showQuestion();
  } else {
    showResults();
  }
}

function showResults() {
  clearInterval(timerId);
  progressFill.style.width = "100%";

  questionScreen.classList.add("hidden");
  resultScreen.classList.remove("hidden");

  document.getElementById("score").textContent = score;
  document.getElementById("total").textContent = questions.length;

  const percent = score / questions.length;
  let message;
  if (percent === 1) {
    message = "Perfect score. Well done.";
  } else if (percent >= 0.7) {
    message = "Good work, nearly there.";
  } else if (percent >= 0.4) {
    message = "A fair attempt. Try another round.";
  } else {
    message = "A tough round. Have another go and the answers below will help.";
  }
  document.getElementById("score-message").textContent = message;

  const key = bestScoreKey(currentCategory);
  const previousBest = localStorage.getItem(key);
  if (previousBest === null || score > Number(previousBest)) {
    localStorage.setItem(key, String(score));
    document.getElementById("result-best").textContent =
      "New best score for this category: " + score + " / " + questions.length;
  } else {
    document.getElementById("result-best").textContent =
      "Best score for this category: " + previousBest + " / " + questions.length;
  }

  const reviewList = document.getElementById("review-list");
  reviewList.innerHTML = "";
  results.forEach(function (r) {
    const item = document.createElement("li");
    const qLine = document.createElement("p");
    qLine.className = "review-q";
    qLine.textContent = r.question.question;
    item.appendChild(qLine);

    const aLine = document.createElement("p");
    if (r.picked === r.question.answer) {
      aLine.className = "right";
      aLine.textContent = "Your answer: " + r.question.options[r.picked] + " — correct";
    } else if (r.picked === -1) {
      aLine.className = "wrong-answer";
      aLine.textContent = "No answer — correct answer: " + r.question.options[r.question.answer];
    } else {
      aLine.className = "wrong-answer";
      aLine.textContent = "Your answer: " + r.question.options[r.picked] +
        " — correct answer: " + r.question.options[r.question.answer];
    }
    item.appendChild(aLine);
    reviewList.appendChild(item);
  });
}

document.querySelectorAll(".category-btn").forEach(function (btn) {
  btn.addEventListener("click", function () {
    startQuiz(btn.dataset.category);
  });
});

document.querySelectorAll(".category-btn").forEach(function (btn) {
  btn.addEventListener("mouseenter", function () {
    currentCategory = btn.dataset.category;
    showBestScore();
  });
});

nextBtn.addEventListener("click", nextQuestion);

document.getElementById("restart-btn").addEventListener("click", function () {
  resultScreen.classList.add("hidden");
  startScreen.classList.remove("hidden");
  showBestScore();
});

// Answer with keys 1-4 while a question is showing.
document.addEventListener("keydown", function (event) {
  if (questionScreen.classList.contains("hidden") || answered) return;
  const num = Number(event.key);
  if (num >= 1 && num <= 4) pickAnswer(num - 1);
});

showBestScore();
