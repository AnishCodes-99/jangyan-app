/**
 * JanGyan - Citizen Awareness Platform
 * Interactive E-Learning & Assessment Engine
 */

// Category Metadata and Study Guides
const domainDetails = {
  "Cyber Safety & Digital Security": {
    id: "cyber_safety",
    num: "01",
    icon: "fa-shield-halved",
    desc: "Protect devices, prevent financial scams, secure personal data, and navigate the digital ecosystem responsibly.",
    topics: ["Phishing Scams", "OTP & 2FA Security", "Helpline 1930", "DPDP Act 2023", "Social Engineering"],
    notes: `
      <h4><i class="fa-solid fa-shield-halved"></i> Key Cyber Safety Takeaways</h4>
      <ul>
        <li><strong>Golden Window for Financial Fraud:</strong> If you lose money to cyber fraud, immediately dial <strong>1930</strong> or report on <em>cybercrime.gov.in</em> within the first 2-3 hours to freeze stolen funds in transit.</li>
        <li><strong>The OTP Golden Rule:</strong> Never share One-Time Passwords (OTP), UPI PINs, or CVVs with anyone. Banks and official agencies never ask for your PIN.</li>
        <li><strong>UPI Payment Mechanics:</strong> Entering a UPI PIN is strictly for <em>sending money</em>, never for receiving money. QR codes only accept payments.</li>
        <li><strong>Multi-Factor Authentication (2FA):</strong> Always enable 2FA on email, WhatsApp, and banking accounts to block unauthorized access even if your password is leaked.</li>
        <li><strong>Digital Personal Data Protection (DPDP) Act 2023:</strong> Recognizes citizen data rights, mandating transparent consent and penalizing unauthorized data harvesting.</li>
      </ul>
    `
  },
  "Government Services & Citizen Rights": {
    id: "gov_services",
    num: "02",
    icon: "fa-landmark-flag",
    desc: "Understand constitutional foundations, public welfare portals, right to information, and citizen grievance channels.",
    topics: ["Constitution of India", "RTI Act 2005", "DigiLocker & UMANG", "CPGRAMS Grievances", "Citizen Charters"],
    notes: `
      <h4><i class="fa-solid fa-landmark-flag"></i> Key Government & Civic Rights Takeaways</h4>
      <ul>
        <li><strong>Article 1 & Constitutional Nature:</strong> India is defined as a "Union of States" with a federal structure with a strong unitary bias.</li>
        <li><strong>Right to Information (RTI) Act 2005:</strong> Empowers citizens to request public documents from authorities within 30 days (48 hours for life and liberty matters).</li>
        <li><strong>DigiLocker Legal Validity:</strong> Under Rule 9A of the IT Rules 2016, documents in DigiLocker are legally treated at par with original physical documents across traffic police and airports.</li>
        <li><strong>Central Grievance Redressal (CPGRAMS):</strong> File citizen complaints against central or state public services on <em>pgportal.gov.in</em>.</li>
        <li><strong>Fundamental Rights & Duties:</strong> Part III protects citizen liberties, while Article 51A outlines Fundamental Duties including safeguarding public property.</li>
      </ul>
    `
  },
  "Road Safety & Public Safety": {
    id: "road_safety",
    num: "03",
    icon: "fa-traffic-light",
    desc: "Master traffic regulations, Motor Vehicles Act provisions, pedestrian priority, and life-saving accident protocols.",
    topics: ["Motor Vehicles Act", "Good Samaritan Law", "Golden Hour Care", "Cashless Scheme 2025", "Speed & Helmet Norms"],
    notes: `
      <h4><i class="fa-solid fa-traffic-light"></i> Key Road Safety Takeaways</h4>
      <ul>
        <li><strong>The Good Samaritan Protection (Section 134A):</strong> Any bystander who assists a road accident victim is legally protected from civil or criminal liability, police harassment, and forced disclosure.</li>
        <li><strong>The Golden Hour:</strong> The first 60 minutes post-trauma where prompt medical intervention drastically increases the chances of survival.</li>
        <li><strong>Cashless Treatment Scheme 2025:</strong> Guarantees up to ₹1.5 lakh cashless emergency treatment for road accident victims during the first 7 days at authorized hospitals.</li>
        <li><strong>Overspeeding Risks:</strong> MoRTH statistics indicate overspeeding accounts for nearly 68% of all road accident fatalities in India.</li>
        <li><strong>Helmet & Seatbelt Standards:</strong> Mandatory ISI/BIS-certified helmets for two-wheelers reduce fatal head injury risks by over 40%.</li>
      </ul>
    `
  },
  "Health & Emergency Awareness": {
    id: "health_emergency",
    num: "04",
    icon: "fa-hospital",
    desc: "First aid fundamentals, emergency numbers, Ayushman Bharat entitlements, and proactive lifestyle disease control.",
    topics: ["Dial 112 Unified Response", "CPR & First Aid", "PM-JAY Health Cover", "Silent Diseases (NCDs)", "Mental Well-being"],
    notes: `
      <h4><i class="fa-solid fa-hospital"></i> Key Health & Emergency Takeaways</h4>
      <ul>
        <li><strong>Unified Emergency Number 112:</strong> Single emergency number across India that routes calls seamlessly to police, fire, or medical disaster response.</li>
        <li><strong>Cardiopulmonary Resuscitation (CPR):</strong> Perform hands-only chest compressions (100–120 per minute at a depth of 2 inches) in the center of the chest for cardiac arrest victims.</li>
        <li><strong>Ayushman Bharat PM-JAY:</strong> World's largest public health insurance scheme providing ₹5 lakh annual secondary and tertiary hospital cover per eligible family.</li>
        <li><strong>Silent NCD Killers:</strong> Hypertension and diabetes often exhibit zero visible early symptoms. Annual preventive screenings after age 30 are essential.</li>
        <li><strong>First Aid Recovery Position:</strong> Place an unconscious, breathing victim on their side with an open airway to prevent choking.</li>
      </ul>
    `
  },
  "Financial Literacy & Digital Finance": {
    id: "financial_literacy",
    num: "05",
    icon: "fa-wallet",
    desc: "Budgeting discipline, credit scores, insurance planning, mutual funds, and recognizing fraudulent investment traps.",
    topics: ["50-30-20 Budgeting", "Emergency Funds", "CIBIL Credit Score", "NPS & APY Pensions", "Ponzi Scheme Warning"],
    notes: `
      <h4><i class="fa-solid fa-wallet"></i> Key Financial Literacy Takeaways</h4>
      <ul>
        <li><strong>The 50-30-20 Rule:</strong> Allocate 50% of income to essential needs, 30% to wants/lifestyle, and 20% toward savings, emergency funds, and debt repayment.</li>
        <li><strong>Emergency Fund Rule of Thumb:</strong> Maintain at least 3 to 6 months of mandatory living expenses in high-liquidity accounts before investing.</li>
        <li><strong>Credit Score (CIBIL):</strong> Scores above 750 reflect responsible repayment behavior and unlock lower interest rates for loans.</li>
        <li><strong>Recognizing Fraudulent Schemes:</strong> Any investment offering "guaranteed 20%+ monthly returns" without regulatory SEBI/RBI registration is a Ponzi/pyramid scam.</li>
        <li><strong>Retirement Planning (NPS & APY):</strong> Long-term compound interest through National Pension System and Atal Pension Yojana ensures financial independence post-60.</li>
      </ul>
    `
  },
  "Environment & Civic Responsibility": {
    id: "environment",
    num: "06",
    icon: "fa-leaf",
    desc: "Solid waste segregation, single-use plastic reduction, water conservation, Air Quality Index, and local civic duties.",
    topics: ["Waste Segregation (Wet/Dry)", "Single-Use Plastic Ban", "AQI & Air Quality", "E-Waste Management", "Public Cleanliness"],
    notes: `
      <h4><i class="fa-solid fa-leaf"></i> Key Environment & Civic Takeaways</h4>
      <ul>
        <li><strong>Three-Bin Source Segregation:</strong> Green bin for biodegradable wet kitchen waste, Blue bin for dry recyclables (paper, plastic, metal), and Red bin for domestic hazardous waste (batteries, medicines).</li>
        <li><strong>Single-Use Plastic Prohibition:</strong> Plastic sticks on earbuds, balloons, thermocol plates, and cutlery are legally banned under Plastic Waste Management Rules.</li>
        <li><strong>Understanding AQI:</strong> 0-50 is 'Good', 51-100 is 'Satisfactory', 101-200 is 'Moderate', 201-300 is 'Poor', and >300 is 'Very Poor/Severe'.</li>
        <li><strong>Energy & Water Conservation:</strong> Transition to 5-star BEE-rated appliances, solar rooftops, and rainwater harvesting drastically lowers carbon footprints.</li>
        <li><strong>Article 51A(g):</strong> It is the constitutional fundamental duty of every citizen of India to protect and improve the natural environment, including forests, lakes, rivers, and wildlife.</li>
      </ul>
    `
  }
};

// Fallback sample questions if questions.js is still loading
const fallbackQuestions = {
  "Cyber Safety & Digital Security": [
    { id: 1, question: "What is the primary objective of cyber security?", options: ["Only running antivirus software", "Protecting digital systems, networks, and data from unauthorized access and attacks", "Applying for government IDs", "Improving broadband download speed"], answer: 1, explanation: "Cyber security encompasses the practices, tools, and protocols to protect systems and data from digital threats." },
    { id: 2, question: "What is the official toll-free helpline number in India to report immediate cyber financial fraud?", options: ["100", "1930", "1098", "1800"], answer: 1, explanation: "1930 is the dedicated National Cyber Crime Reporting Helpline for reporting financial fraud within the Golden Period." }
  ]
};

// Web Audio API Synthesizer for lightweight, responsive sound effects
class SoundEngine {
  constructor() {
    this.enabled = true;
    this.ctx = null;
  }

  init() {
    if (!this.ctx) {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (AudioCtx) this.ctx = new AudioCtx();
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume();
    }
  }

  playTone(freq, type = 'sine', duration = 0.15, gainVal = 0.1) {
    if (!this.enabled) return;
    try {
      this.init();
      if (!this.ctx) return;
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      osc.type = type;
      osc.frequency.setValueAtTime(freq, this.ctx.currentTime);
      gain.gain.setValueAtTime(gainVal, this.ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + duration);
      osc.connect(gain);
      gain.connect(this.ctx.destination);
      osc.start();
      osc.stop(this.ctx.currentTime + duration);
    } catch (e) {
      console.warn("Audio unavailable:", e);
    }
  }

  correct() {
    this.playTone(523.25, 'sine', 0.1, 0.12);
    setTimeout(() => this.playTone(659.25, 'sine', 0.2, 0.15), 100);
  }

  wrong() {
    this.playTone(330, 'triangle', 0.15, 0.12);
    setTimeout(() => this.playTone(260, 'triangle', 0.25, 0.12), 120);
  }

  complete() {
    [523.25, 659.25, 783.99, 1046.5].forEach((f, idx) => {
      setTimeout(() => this.playTone(f, 'sine', 0.25, 0.15), idx * 120);
    });
  }
}

const sounds = new SoundEngine();

// App State
const state = {
  activeDomain: "Cyber Safety & Digital Security",
  questions: [],
  currentIndex: 0,
  userAnswers: {}, // index -> chosen option
  score: 0,
  timerSeconds: 0,
  timerInterval: null,
  quizMode: "instant",
  quizSize: 20
};

// DOM References
const elements = {
  themeToggle: document.getElementById('themeToggle'),
  soundToggle: document.getElementById('soundToggle'),
  mobileToggle: document.getElementById('mobileToggle'),
  navMenu: document.getElementById('navMenu'),
  categoryGrid: document.getElementById('categoryGrid'),
  quizCategory: document.getElementById('quizCategory'),
  quizCount: document.getElementById('quizCount'),
  quizMode: document.getElementById('quizMode'),
  startQuizBtn: document.getElementById('startQuizBtn'),
  browseNotesBtn: document.getElementById('browseNotesBtn'),
  quizSetup: document.getElementById('quizSetup'),
  quizContainer: document.getElementById('quizContainer'),
  quizResult: document.getElementById('quizResult'),
  activeDomainBadge: document.getElementById('activeDomainBadge'),
  questionCounter: document.getElementById('questionCounter'),
  quizTimer: document.getElementById('quizTimer'),
  currentScore: document.getElementById('currentScore'),
  progressBar: document.getElementById('progressBar'),
  questionNav: document.getElementById('questionNav'),
  questionStem: document.getElementById('questionStem'),
  optionsContainer: document.getElementById('optionsContainer'),
  explanationBox: document.getElementById('explanationBox'),
  explanationText: document.getElementById('explanationText'),
  prevBtn: document.getElementById('prevBtn'),
  nextBtn: document.getElementById('nextBtn'),
  restartQuizBtn: document.getElementById('restartQuizBtn'),
  retakeQuizBtn: document.getElementById('retakeQuizBtn'),
  chooseOtherDomainBtn: document.getElementById('chooseOtherDomainBtn'),
  finalScoreVal: document.getElementById('finalScoreVal'),
  finalTotalVal: document.getElementById('finalTotalVal'),
  finalPercentVal: document.getElementById('finalPercentVal'),
  finalTimeVal: document.getElementById('finalTimeVal'),
  proficiencyBadge: document.getElementById('proficiencyBadge'),
  proficiencyNote: document.getElementById('proficiencyNote'),
  certCandidateName: document.getElementById('certCandidateName'),
  generateCertBtn: document.getElementById('generateCertBtn'),
  reviewContainer: document.getElementById('reviewContainer'),
  certModal: document.getElementById('certModal'),
  closeCertModal: document.getElementById('closeCertModal'),
  closeCertBtn: document.getElementById('closeCertBtn'),
  notesModal: document.getElementById('notesModal'),
  notesModalTitle: document.getElementById('notesModalTitle'),
  notesModalBody: document.getElementById('notesModalBody'),
  closeNotesModal: document.getElementById('closeNotesModal'),
  closeNotesBtn: document.getElementById('closeNotesBtn'),
  launchQuizFromNotes: document.getElementById('launchQuizFromNotes'),
  contactForm: document.getElementById('contactForm'),
  toast: document.getElementById('toast'),
  // Cert Display Elements
  certCandidateDisplay: document.getElementById('certCandidateDisplay'),
  certDomainDisplay: document.getElementById('certDomainDisplay'),
  certCategoryDisplay: document.getElementById('certCategoryDisplay'),
  certScoreDisplay: document.getElementById('certScoreDisplay'),
  certUniqueId: document.getElementById('certUniqueId'),
  certIssueDate: document.getElementById('certIssueDate')
};

// Helper to get question bank
function getQuestionBank() {
  if (typeof jangyanQuestions !== 'undefined' && Object.keys(jangyanQuestions).length > 0) {
    return jangyanQuestions;
  }
  return fallbackQuestions;
}

// Initialize Theme
function initTheme() {
  const saved = localStorage.getItem('jangyan_theme') || 'light';
  document.documentElement.setAttribute('data-theme', saved);
  updateThemeIcon(saved);

  elements.themeToggle.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme') || 'light';
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('jangyan_theme', next);
    updateThemeIcon(next);
    showToast(`Switched to ${next} mode`);
  });
}

function updateThemeIcon(theme) {
  const icon = elements.themeToggle.querySelector('i');
  if (theme === 'dark') {
    icon.className = 'fa-solid fa-sun';
  } else {
    icon.className = 'fa-solid fa-moon';
  }
}

// Show Toast
function showToast(msg, duration = 3000) {
  elements.toast.textContent = msg;
  elements.toast.classList.remove('hidden');
  setTimeout(() => {
    elements.toast.classList.add('hidden');
  }, duration);
}

// Render 6 Domain Cards
function renderDomainCards() {
  elements.categoryGrid.innerHTML = '';
  const bank = getQuestionBank();
  
  Object.keys(domainDetails).forEach((domainName) => {
    const info = domainDetails[domainName];
    const totalQ = bank[domainName] ? bank[domainName].length : 25;
    
    const card = document.createElement('div');
    card.className = 'category-card';
    card.innerHTML = `
      <div class="category-card-top">
        <span class="category-num-badge">DOMAIN ${info.num}</span>
        <div class="category-icon-bubble">
          <i class="fa-solid ${info.icon}"></i>
        </div>
      </div>
      <h3>${domainName}</h3>
      <p>${info.desc}</p>
      <div class="category-topics">
        ${info.topics.map(t => `<span class="topic-tag">${t}</span>`).join('')}
      </div>
      <div class="category-actions">
        <button class="btn btn-sm btn-primary" onclick="launchQuizDirectly('${domainName}')">
          <i class="fa-solid fa-pen-to-square"></i> Practice 20 MCQs
        </button>
        <button class="btn btn-sm btn-outline" onclick="openDomainNotes('${domainName}')">
          <i class="fa-solid fa-book-open"></i> Notes
        </button>
      </div>
    `;
    elements.categoryGrid.appendChild(card);
  });
}

// Populate Domain Select Dropdown
function populateDomainDropdown() {
  elements.quizCategory.innerHTML = '';
  
  // Mixed option
  const mixedOption = document.createElement('option');
  mixedOption.value = 'ALL_DOMAINS';
  mixedOption.textContent = '🌟 Comprehensive Master Quiz (Mixed Across All 6 Domains)';
  elements.quizCategory.appendChild(mixedOption);

  Object.keys(domainDetails).forEach(name => {
    const opt = document.createElement('option');
    opt.value = name;
    opt.textContent = `${domainDetails[name].num}. ${name}`;
    elements.quizCategory.appendChild(opt);
  });
}

// Open Domain Notes Modal
function openDomainNotes(domainName) {
  const info = domainDetails[domainName];
  if (!info) return;

  elements.notesModalTitle.innerHTML = `<i class="fa-solid ${info.icon}"></i> ${domainName} — Study Notes`;
  elements.notesModalBody.innerHTML = info.notes;
  elements.notesModal.classList.remove('hidden');

  elements.launchQuizFromNotes.onclick = () => {
    elements.notesModal.classList.add('hidden');
    launchQuizDirectly(domainName);
  };
}

// Launch Quiz from category cards
window.launchQuizDirectly = function(domainName) {
  elements.quizCategory.value = domainName;
  elements.quizCount.value = "20";
  document.getElementById('quiz').scrollIntoView({ behavior: 'smooth' });
  startQuiz();
};

window.selectCategoryDirectly = function(domainName) {
  elements.quizCategory.value = domainName;
  document.getElementById('quiz').scrollIntoView({ behavior: 'smooth' });
};

window.openDomainNotes = openDomainNotes;

// Shuffle Helper
function shuffleArray(arr) {
  const copy = [...arr];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

// Start Quiz Session
function startQuiz() {
  sounds.init();
  const selectedDomain = elements.quizCategory.value;
  const count = parseInt(elements.quizCount.value, 10) || 20;
  const mode = elements.quizMode.value;
  const bank = getQuestionBank();

  let pool = [];
  if (selectedDomain === 'ALL_DOMAINS') {
    state.activeDomain = "Comprehensive Master Assessment (All 6 Domains)";
    // Take balanced sample from each category
    Object.keys(bank).forEach(cat => {
      if (Array.isArray(bank[cat])) {
        pool.push(...bank[cat]);
      }
    });
  } else {
    state.activeDomain = selectedDomain;
    pool = bank[selectedDomain] || [];
  }

  if (pool.length === 0) {
    showToast("No questions available for this domain.");
    return;
  }

  // Shuffle and pick desired number of questions
  const shuffled = shuffleArray(pool);
  state.questions = shuffled.slice(0, Math.min(count, shuffled.length));
  state.quizSize = state.questions.length;
  state.currentIndex = 0;
  state.userAnswers = {};
  state.score = 0;
  state.quizMode = mode;
  state.timerSeconds = 0;

  // Setup UI
  elements.quizSetup.classList.add('hidden');
  elements.quizResult.classList.add('hidden');
  elements.quizContainer.classList.remove('hidden');

  elements.activeDomainBadge.textContent = state.activeDomain;
  startTimer();
  renderQuestionNav();
  renderCurrentQuestion();

  // Scroll to active quiz box
  elements.quizContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// Timer Functions
function startTimer() {
  if (state.timerInterval) clearInterval(state.timerInterval);
  state.timerSeconds = 0;
  updateTimerDisplay();
  state.timerInterval = setInterval(() => {
    state.timerSeconds++;
    updateTimerDisplay();
  }, 1000);
}

function stopTimer() {
  if (state.timerInterval) {
    clearInterval(state.timerInterval);
    state.timerInterval = null;
  }
}

function updateTimerDisplay() {
  const mins = Math.floor(state.timerSeconds / 60);
  const secs = state.timerSeconds % 60;
  elements.quizTimer.textContent = `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

// Render Question Navigator Bubbles
function renderQuestionNav() {
  elements.questionNav.innerHTML = '';
  for (let i = 0; i < state.questions.length; i++) {
    const bubble = document.createElement('div');
    bubble.className = 'nav-bubble';
    bubble.textContent = i + 1;
    bubble.dataset.index = i;

    if (i === state.currentIndex) {
      bubble.classList.add('active');
    }
    if (state.userAnswers[i] !== undefined) {
      const q = state.questions[i];
      if (state.quizMode === 'instant') {
        if (state.userAnswers[i] === q.answer) {
          bubble.classList.add('answered');
        } else {
          bubble.classList.add('answered-wrong');
        }
      } else {
        bubble.classList.add('answered');
      }
    }

    bubble.onclick = () => {
      goToQuestion(i);
    };

    elements.questionNav.appendChild(bubble);
  }
}

// Render Current Question
function renderCurrentQuestion() {
  const q = state.questions[state.currentIndex];
  if (!q) return;

  // Header & Counter
  elements.questionCounter.textContent = `Question ${state.currentIndex + 1} of ${state.questions.length}`;
  elements.currentScore.textContent = `Score: ${state.score} / ${state.currentIndex}`;

  // Progress Bar
  const percent = ((state.currentIndex + 1) / state.questions.length) * 100;
  elements.progressBar.style.width = `${percent}%`;

  // Question Stem
  elements.questionStem.innerHTML = `<span style="color:var(--secondary);margin-right:8px;">Q${state.currentIndex + 1}.</span> ${q.question}`;

  // Options
  elements.optionsContainer.innerHTML = '';
  const alreadyAnswered = state.userAnswers[state.currentIndex] !== undefined;

  q.options.forEach((optText, optIndex) => {
    const btn = document.createElement('button');
    btn.className = 'option-btn';
    btn.dataset.optIndex = optIndex;

    const letter = String.fromCharCode(65 + optIndex);
    btn.innerHTML = `<span class="option-letter">${letter}</span> <span class="option-text">${optText}</span>`;

    // Apply styles if already answered
    if (alreadyAnswered) {
      btn.disabled = true;
      const chosen = state.userAnswers[state.currentIndex];
      if (optIndex === q.answer) {
        btn.classList.add('correct');
      } else if (optIndex === chosen) {
        btn.classList.add('wrong');
      }
    } else {
      btn.onclick = () => selectOption(optIndex);
    }

    elements.optionsContainer.appendChild(btn);
  });

  // Explanation Box
  if (alreadyAnswered && state.quizMode === 'instant') {
    elements.explanationBox.classList.remove('hidden');
    elements.explanationText.textContent = q.explanation || "Official JanGyan handbook verified civic standard.";
  } else {
    elements.explanationBox.classList.add('hidden');
  }

  // Prev / Next button state
  elements.prevBtn.disabled = state.currentIndex === 0;
  if (state.currentIndex === state.questions.length - 1) {
    elements.nextBtn.innerHTML = `Finish Assessment <i class="fa-solid fa-flag-checkered"></i>`;
  } else {
    elements.nextBtn.innerHTML = `Next <i class="fa-solid fa-arrow-right"></i>`;
  }

  renderQuestionNav();
}

// Handle Option Selection
function selectOption(chosenIndex) {
  if (state.userAnswers[state.currentIndex] !== undefined) return; // Prevent re-answering

  const q = state.questions[state.currentIndex];
  state.userAnswers[state.currentIndex] = chosenIndex;
  const isCorrect = chosenIndex === q.answer;

  if (isCorrect) {
    state.score++;
    sounds.correct();
  } else {
    sounds.wrong();
  }

  // Update telemetry
  elements.currentScore.textContent = `Score: ${state.score} / ${state.currentIndex + 1}`;

  // Highlight buttons immediately
  const buttons = elements.optionsContainer.querySelectorAll('.option-btn');
  buttons.forEach(b => {
    b.disabled = true;
    const bIndex = parseInt(b.dataset.optIndex, 10);
    if (bIndex === q.answer) {
      b.classList.add('correct');
    } else if (bIndex === chosenIndex) {
      b.classList.add('wrong');
    }
  });

  // Reveal explanation if in instant mode
  if (state.quizMode === 'instant') {
    elements.explanationBox.classList.remove('hidden');
    elements.explanationText.textContent = q.explanation || "Official JanGyan handbook verified civic standard.";
  }

  renderQuestionNav();
}

// Navigation between questions
function goToQuestion(index) {
  if (index < 0 || index >= state.questions.length) return;
  state.currentIndex = index;
  renderCurrentQuestion();
}

function handleNext() {
  if (state.currentIndex < state.questions.length - 1) {
    state.currentIndex++;
    renderCurrentQuestion();
  } else {
    finishQuiz();
  }
}

function handlePrev() {
  if (state.currentIndex > 0) {
    state.currentIndex--;
    renderCurrentQuestion();
  }
}

// Finish Assessment & Show Results Dashboard
function finishQuiz() {
  stopTimer();
  sounds.complete();

  elements.quizContainer.classList.add('hidden');
  elements.quizResult.classList.remove('hidden');

  const total = state.questions.length;
  const score = state.score;
  const percent = Math.round((score / total) * 100);

  // Fill Metrics
  elements.finalScoreVal.textContent = score;
  elements.finalTotalVal.textContent = total;
  elements.finalPercentVal.textContent = `${percent}% Accuracy`;

  const mins = Math.floor(state.timerSeconds / 60);
  const secs = state.timerSeconds % 60;
  elements.finalTimeVal.textContent = `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;

  // Evaluate Level
  if (percent >= 90) {
    elements.proficiencyBadge.textContent = "🥇 Citizen Champion";
    elements.proficiencyBadge.style.color = "#10B981";
    elements.proficiencyNote.textContent = "Distinction! Outstanding civic preparedness.";
  } else if (percent >= 75) {
    elements.proficiencyBadge.textContent = "🥈 Civic Scholar";
    elements.proficiencyBadge.style.color = "#1363DF";
    elements.proficiencyNote.textContent = "High awareness. Well prepared for civic situations.";
  } else if (percent >= 50) {
    elements.proficiencyBadge.textContent = "🥉 Aware Citizen";
    elements.proficiencyBadge.style.color = "#F59E0B";
    elements.proficiencyNote.textContent = "Good foundation. Review explanations to boost mastery.";
  } else {
    elements.proficiencyBadge.textContent = "💡 Active Learner";
    elements.proficiencyBadge.style.color = "#EF4444";
    elements.proficiencyNote.textContent = "Needs practice. Retake to master essential safety rules.";
  }

  // Render Detailed Question Review
  renderReviewList();

  // Scroll to results
  elements.quizResult.scrollIntoView({ behavior: 'smooth' });
}

// Render Review Accordion
function renderReviewList() {
  elements.reviewContainer.innerHTML = '';
  state.questions.forEach((q, idx) => {
    const userChoice = state.userAnswers[idx];
    const isCorrect = userChoice === q.answer;
    
    const card = document.createElement('div');
    card.className = `review-card ${isCorrect ? 'correct' : 'wrong'}`;

    const userAnsText = userChoice !== undefined ? `${String.fromCharCode(65 + userChoice)}. ${q.options[userChoice]}` : "Not Answered";
    const correctAnsText = `${String.fromCharCode(65 + q.answer)}. ${q.options[q.answer]}`;

    card.innerHTML = `
      <div class="review-q-stem">
        ${idx + 1}. ${q.question}
      </div>
      <div class="review-meta">
        <strong>Your Answer:</strong> <span style="color:${isCorrect ? 'var(--success)' : 'var(--danger)'};">${userAnsText}</span>
      </div>
      ${!isCorrect ? `<div class="review-meta"><strong>Correct Answer:</strong> <span style="color:var(--success);">${correctAnsText}</span></div>` : ''}
      <div class="review-explanation">
        <i class="fa-solid fa-lightbulb"></i> <strong>Handbook Explanation:</strong> ${q.explanation}
      </div>
    `;

    elements.reviewContainer.appendChild(card);
  });
}

// Generate & Display Certificate
function generateCertificate() {
  const candidateName = elements.certCandidateName.value.trim() || "Dedicated Indian Citizen";
  const total = state.questions.length;
  const score = state.score;
  const percent = Math.round((score / total) * 100);

  // Populate Certificate Fields
  elements.certCandidateDisplay.textContent = candidateName;
  elements.certDomainDisplay.textContent = state.activeDomain.toUpperCase();
  elements.certCategoryDisplay.textContent = state.activeDomain;
  elements.certScoreDisplay.textContent = `${score}/${total} (${percent}%)`;

  // Unique Certificate Serial Number
  const randomSerial = Math.floor(1000 + Math.random() * 9000);
  elements.certUniqueId.textContent = `JGY-2026-${randomSerial}`;

  // Current formatted date
  const now = new Date();
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  elements.certIssueDate.textContent = now.toLocaleDateString('en-IN', options);

  // Open Modal
  elements.certModal.classList.remove('hidden');
}

// Event Listeners Initialization
function initEventListeners() {
  elements.startQuizBtn.addEventListener('click', startQuiz);
  elements.nextBtn.addEventListener('click', handleNext);
  elements.prevBtn.addEventListener('click', handlePrev);
  
  elements.restartQuizBtn.addEventListener('click', () => {
    if (confirm("Restart this assessment from question 1?")) {
      startQuiz();
    }
  });

  elements.retakeQuizBtn.addEventListener('click', () => {
    startQuiz();
  });

  elements.chooseOtherDomainBtn.addEventListener('click', () => {
    elements.quizResult.classList.add('hidden');
    elements.quizSetup.classList.remove('hidden');
    elements.quizSetup.scrollIntoView({ behavior: 'smooth' });
  });

  elements.browseNotesBtn.addEventListener('click', () => {
    const sel = elements.quizCategory.value;
    const target = sel === 'ALL_DOMAINS' ? 'Cyber Safety & Digital Security' : sel;
    openDomainNotes(target);
  });

  // Sound toggle
  elements.soundToggle.addEventListener('click', () => {
    sounds.enabled = !sounds.enabled;
    const icon = elements.soundToggle.querySelector('i');
    if (sounds.enabled) {
      icon.className = 'fa-solid fa-volume-high';
      showToast("Sound effects enabled");
    } else {
      icon.className = 'fa-solid fa-volume-xmark';
      showToast("Sound effects muted");
    }
  });

  // Mobile nav toggle
  elements.mobileToggle.addEventListener('click', () => {
    elements.navMenu.classList.toggle('mobile-open');
  });

  // Certificate Modal Handlers
  elements.generateCertBtn.addEventListener('click', generateCertificate);
  elements.closeCertModal.addEventListener('click', () => elements.certModal.classList.add('hidden'));
  elements.closeCertBtn.addEventListener('click', () => elements.certModal.classList.add('hidden'));

  // Notes Modal Handlers
  elements.closeNotesModal.addEventListener('click', () => elements.notesModal.classList.add('hidden'));
  elements.closeNotesBtn.addEventListener('click', () => elements.notesModal.classList.add('hidden'));

  // Close modals on clicking backdrop
  window.addEventListener('click', (e) => {
    if (e.target === elements.certModal) elements.certModal.classList.add('hidden');
    if (e.target === elements.notesModal) elements.notesModal.classList.add('hidden');
  });

  // Contact Form Submission
  elements.contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    showToast("Thank you for your feedback! Your suggestion has been recorded.", 4000);
    elements.contactForm.reset();
  });
}

// Bootstrap
document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  renderDomainCards();
  populateDomainDropdown();
  initEventListeners();
});
