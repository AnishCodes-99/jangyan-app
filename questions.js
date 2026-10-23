/**
 * JanGyan Official Question Bank
 * Extracted from official category handbooks
 */
const jangyanQuestions = {
  "Cyber Safety & Digital Security": [
    {
      "id": 1,
      "question": "What is the most accurate definition of cyber security?",
      "options": [
        "Only installing antivirus software on a computer",
        "The practice of protecting devices, networks, applications, and data from digital attacks and unauthorised access",
        "A government department that issues Aadhaar cards",
        "A type of internet connection"
      ],
      "answer": 1,
      "explanation": "Cyber security is a broad practice combining people, processes, and technology to protect digital systems and data, not\njust one tool like antivirus software."
    },
    {
      "id": 2,
      "question": "Which of these best describes the CIA Triad in cyber security?",
      "options": [
        "Confidentiality, Integrity, Availability",
        "Computers, Internet, Antivirus",
        "Central Intelligence Agency",
        "Cyber, Identity, Access"
      ],
      "answer": 0,
      "explanation": "The CIA Triad — Confidentiality, Integrity, and Availability — is the foundational framework guiding how cyber security\nprofessionals protect information."
    },
    {
      "id": 3,
      "question": "In cyber security terms, what is a \"vulnerability\"?",
      "options": [
        "A criminal who commits cybercrime",
        "A weakness that a threat can exploit",
        "A type of antivirus software",
        "A government helpline number"
      ],
      "answer": 1,
      "explanation": "A vulnerability is a weak point, such as outdated software, that a threat like malware or a hacker can take advantage of to\ncause harm.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 2 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 4,
      "question": "Which of the following is an example of malware that disguises itself as legitimate software?",
      "options": [
        "Worm",
        "Trojan Horse",
        "Firewall",
        "VPN✅"
      ],
      "answer": 1,
      "explanation": "A Trojan Horse hides malicious code inside what looks like a genuine, useful application to trick users into installing it."
    },
    {
      "id": 5,
      "question": "What is the main difference between a computer virus and a worm?",
      "options": [
        "There is no difference",
        "A virus needs a host file to spread; a worm spreads independently across networks",
        "A worm only affects mobile phones",
        "A virus is always harmless"
      ],
      "answer": 1,
      "explanation": "Viruses attach themselves to files and need user action to spread, while worms can replicate and spread across networks\non their own."
    },
    {
      "id": 6,
      "question": "Ramesh receives a call from someone claiming to be a police officer, saying he must stay on a video call or be arrested.\nWhat is this scam called?",
      "options": [
        "Smishing",
        "Digital arrest scam",
        "Firewall breach",
        "Data breach✅"
      ],
      "answer": 1,
      "explanation": "This is a \"digital arrest\" scam — no genuine Indian law enforcement agency ever conducts arrests or investigations over a\nvideo call.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 3 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 7,
      "question": "What should you do if a caller claiming to be from your bank asks for your OTP?",
      "options": [
        "Share it immediately since banks need it for verification",
        "Never share it — banks never ask for OTPs over a call",
        "Share only the last two digits",
        "Ask them to call back later"
      ],
      "answer": 1,
      "explanation": "Banks never ask customers for OTPs, PINs, or CVVs under any circumstance — any such request is a clear sign of fraud."
    },
    {
      "id": 8,
      "question": "Which term describes fraud carried out through fake SMS messages?",
      "options": [
        "Phishing",
        "Vishing",
        "Smishing",
        "Trolling✅"
      ],
      "answer": 2,
      "explanation": "Smishing is phishing conducted via SMS, often using fake links about deliveries, KYC updates, or bill payments."
    },
    {
      "id": 9,
      "question": "What is \"social engineering\" in the context of cybercrime?",
      "options": [
        "Building social media platforms",
        "Psychological manipulation of people to bypass normal security procedures",
        "A government welfare scheme",
        "A method of encrypting data"
      ],
      "answer": 1,
      "explanation": "Social engineering exploits human trust, fear, or urgency rather than technical vulnerabilities, making it the basis of most\nscams today.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 4 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 10,
      "question": "Which Indian agency is the national nodal agency for cyber incident response?",
      "options": [
        "RBI",
        "CERT-In",
        "UIDAI",
        "NPCI✅"
      ],
      "answer": 1,
      "explanation": "CERT-In (Indian Computer Emergency Response Team), under MeitY, is designated as India's national agency for cyber\nincident response under Section 70B of the IT Act."
    },
    {
      "id": 11,
      "question": "What is the toll-free number for reporting cybercrime in India?",
      "options": [
        "100",
        "108",
        "1930",
        "181✅"
      ],
      "answer": 2,
      "explanation": "1930 is India's dedicated 24x7 cybercrime helpline, especially useful for reporting financial fraud quickly."
    },
    {
      "id": 12,
      "question": "Which section of the IT Act, 2000, deals with identity theft?",
      "options": [
        "Section 43",
        "Section 66C",
        "Section 67",
        "Section 72✅"
      ],
      "answer": 1,
      "explanation": "Section 66C specifically punishes identity theft, including the fraudulent use of another person's password, unique\nidentification, or digital signature.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 5 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 13,
      "question": "A fraudster tricks a victim into merging a call with the bank's real OTP verification line to steal the OTP. What is this\ncalled?",
      "options": [
        "Ransomware attack",
        "Call-merge fraud",
        "DDoS attack",
        "Cyberbullying✅"
      ],
      "answer": 1,
      "explanation": "Call-merge fraud tricks victims into connecting a fraudulent call with a genuine bank verification line so the scammer can\ncapture the OTP read aloud."
    },
    {
      "id": 14,
      "question": "What does \"ransomware\" do to a victim's files?",
      "options": [
        "Deletes them permanently",
        "Locks or encrypts them and demands payment for their release",
        "Copies them to a public website",
        "Improves their security"
      ],
      "answer": 1,
      "explanation": "Ransomware encrypts or locks a victim's files or systems, demanding a ransom payment in exchange for restoring access."
    },
    {
      "id": 15,
      "question": "Which of these is a legitimate best practice for password safety?",
      "options": [
        "Use the same password for every account",
        "Share your password with close family members",
        "Use strong, unique passwords for every account",
        "Write your password on a sticky note on your monitor"
      ],
      "answer": 2,
      "explanation": "Using strong, unique passwords for each account prevents a single data breach from compromising all your other\naccounts.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 6 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 16,
      "question": "What is the primary risk of installing an APK file sent directly via WhatsApp instead of from the Play Store?",
      "options": [
        "It uses more mobile data",
        "It bypasses Play Store's security review and may contain malware",
        "It automatically deletes your contacts",
        "It is always slower to install"
      ],
      "answer": 1,
      "explanation": "APKs shared outside official app stores skip Google's security screening process, making them a common way trojans and\nmalware spread in India."
    },
    {
      "id": 17,
      "question": "Which of the following is classified as \"sensitive personal data\"?",
      "options": [
        "Your favourite colour",
        "Biometric data, health records, and financial details",
        "Your city of residence",
        "Your job title✅"
      ],
      "answer": 1,
      "explanation": "Sensitive personal data includes information that carries higher risk if misused, such as biometrics, health records,\npasswords, and financial details."
    },
    {
      "id": 18,
      "question": "What is the correct response to receiving a message claiming your parcel is undeliverable and asking you to pay a small\n\"re-delivery fee\" via a link?",
      "options": [
        "Click the link immediately to avoid losing the parcel",
        "Ignore or verify independently through the courier's official app, since this is a common smishing pattern",
        "Reply to the message asking for more details",
        "Forward it to friends to warn them"
      ],
      "answer": 1,
      "explanation": "Fake delivery-fee messages are a classic smishing tactic; verifying through the courier's official channel avoids falling for\nthe scam.\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 7 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 19,
      "question": "Which of the following best defines a \"zero-day vulnerability\"?",
      "options": [
        "A vulnerability discovered and patched on the same day",
        "A security flaw unknown to the software maker, exploited before a fix exists",
        "A virus that only activates at midnight",
        "A vulnerability found only in outdated hardware"
      ],
      "answer": 1,
      "explanation": "A zero-day vulnerability is a flaw the software vendor doesn't yet know about, giving attackers a window to exploit it before\na patch is released."
    },
    {
      "id": 20,
      "question": "What is the recommended first step after realising you've shared your OTP with a fraudster and lost money?",
      "options": [
        "Wait a few days to see if the bank notices",
        "Call your bank and 1930 immediately",
        "Change your social media password",
        "Ignore it since nothing can be done"
      ],
      "answer": 1,
      "explanation": "Speed matters — contacting your bank and the 1930 helpline immediately gives the best chance of freezing the stolen\nfunds during the \"golden hour.\""
    },
    {
      "id": 21,
      "question": "Priya's antivirus is active, but she still lost money after sharing her UPI PIN with a caller pretending to be a bank\nemployee. What does this best illustrate?",
      "options": [
        "Antivirus software is completely useless",
        "Antivirus protects against malware, not against social engineering and voluntarily shared information",
        "Her phone was hacked",
        "UPI is not a secure payment system"
      ],
      "answer": 1,
      "explanation": "Antivirus software defends against malicious code, but it cannot stop a person from voluntarily giving away sensitive\ninformation to a scammer.\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 8 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 22,
      "question": "Which of these scenarios best represents a \"digital footprint\" concern in cyber security?",
      "options": [
        "Installing a firewall",
        "Posting personal travel plans publicly on social media",
        "Enabling two-factor authentication",
        "Using a strong password"
      ],
      "answer": 1,
      "explanation": "Publicly sharing details like travel plans expands your digital footprint and can be exploited by criminals monitoring social\nmedia."
    },
    {
      "id": 23,
      "question": "A senior citizen receives a call from someone claiming to be from \"customs\" saying a parcel with illegal items was\nbooked in her name. What is the safest response?",
      "options": [
        "Follow the instructions to avoid arrest",
        "Share her Aadhaar and bank details to prove her innocence",
        "Disconnect immediately and report it, since this is a digital arrest scam pattern",
        "Stay on the call until it resolves itself"
      ],
      "answer": 2,
      "explanation": "This matches the well-documented \"digital arrest\" scam pattern; the correct response is to disconnect immediately and\nreport it, never comply."
    },
    {
      "id": 24,
      "question": "Which of the following is NOT one of the common cyber security triggers scammers exploit?",
      "options": [
        "Urgency",
        "Fear",
        "Software updates",
        "Greed✅"
      ],
      "answer": 2,
      "explanation": "Scammers rely on urgency, fear, greed, authority, and curiosity to manipulate victims — software updates are a defensive\npractice, not a manipulation trigger.\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 9 of 168 • JanGyan — Learn Without Limits"
    },
    {
      "id": 25,
      "question": "What does \"cyber hygiene\" mean?",
      "options": [
        "Cleaning your computer screen regularly",
        "Regular, repeated safe habits that keep devices and accounts secure",
        "A government scheme for internet access",
        "A type of antivirus subscription"
      ],
      "answer": 1,
      "explanation": "Cyber hygiene refers to consistent safe practices — like updating software and avoiding suspicious links — that protect you\nover time, not a one-time fix."
    }
  ],
  "Government Services & Citizen Rights": [
    {
      "id": 1,
      "question": "How is India described in Article 1 of the Constitution?",
      "options": [
        "A federation of independent nations",
        "A Union of States",
        "A confederation with no central authority",
        "A monarchy with elected advisors"
      ],
      "answer": 1,
      "explanation": "Article 1 describes India as \"a Union of States,\" reflecting its distinctive, largely indestructible federal structure."
    },
    {
      "id": 2,
      "question": "What are the three levels of government in India?",
      "options": [
        "Central, State, and Local",
        "Central, Regional, and District only",
        "Federal and Provincial only",
        "National and International"
      ],
      "answer": 0,
      "explanation": "India's governance operates across Central (Union), State, and Local (Panchayats/Municipalities) levels, each with distinct\nresponsibilities."
    },
    {
      "id": 3,
      "question": "What are the three branches of government?",
      "options": [
        "Executive, Judiciary, and Media",
        "Legislature, Executive, and Judiciary",
        "Central, State, and Local",
        "President, Governor, and Mayor"
      ],
      "answer": 1,
      "explanation": "The Legislature makes laws, the Executive implements them, and the Judiciary interprets laws and delivers justice.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 2 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 4,
      "question": "Who is the ceremonial Head of State at the Central level?",
      "options": [
        "The Prime Minister",
        "The President",
        "The Chief Justice",
        "The Speaker of the Lok Sabha"
      ],
      "answer": 1,
      "explanation": "The President serves as India's constitutional Head of State, while real executive power rests with the Prime Minister and\nCouncil of Ministers."
    },
    {
      "id": 5,
      "question": "Who holds the real executive power at the Union level?",
      "options": [
        "The President alone",
        "The Prime Minister and Council of Ministers",
        "The Chief Justice of India",
        "The Speaker of the Lok Sabha"
      ],
      "answer": 1,
      "explanation": "While the President's role is largely ceremonial, the Prime Minister and Council of Ministers exercise the actual executive\nauthority."
    },
    {
      "id": 6,
      "question": "What are the two houses of India's Parliament?",
      "options": [
        "Lok Sabha and Vidhan Sabha",
        "Lok Sabha and Rajya Sabha",
        "Rajya Sabha and Vidhan Parishad",
        "Vidhan Sabha and Vidhan Parishad"
      ],
      "answer": 1,
      "explanation": "Parliament consists of the Lok Sabha (directly elected) and the Rajya Sabha (representing the states).\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 3 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 7,
      "question": "Who is the ceremonial Head of State at the State level?",
      "options": [
        "The Chief Minister",
        "The Governor",
        "The Speaker of the Vidhan Sabha",
        "The District Collector"
      ],
      "answer": 1,
      "explanation": "The Governor, appointed by the President, serves as the state-level constitutional head, mirroring the President's role at\nthe Centre."
    },
    {
      "id": 8,
      "question": "What establishes the three-tier Panchayati Raj system for rural local government?",
      "options": [
        "The 42nd Constitutional Amendment",
        "The 73rd Constitutional Amendment, 1992",
        "The 74th Constitutional Amendment, 1992",
        "The 86th Constitutional Amendment"
      ],
      "answer": 1,
      "explanation": "The 73rd Amendment of 1992 formally established the modern Panchayati Raj structure across rural India."
    },
    {
      "id": 9,
      "question": "What establishes urban local bodies like Municipal Corporations?",
      "options": [
        "The 73rd Constitutional Amendment",
        "The 74th Constitutional Amendment, 1992",
        "The 42nd Constitutional Amendment",
        "The 44th Constitutional Amendment"
      ],
      "answer": 1,
      "explanation": "The 74th Amendment of 1992 established the framework for Municipal Corporations, Councils, and Nagar Panchayats.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 4 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 10,
      "question": "What are the three tiers of the Panchayati Raj system?",
      "options": [
        "Gram Panchayat, Panchayat Samiti, Zilla Parishad",
        "Municipal Corporation, Council, Nagar Panchayat",
        "Lok Sabha, Rajya Sabha, Vidhan Sabha",
        "President, Governor, Mayor"
      ],
      "answer": 0,
      "explanation": "Rural local government operates through Gram Panchayat (village), Panchayat Samiti (block), and Zilla Parishad (district)\nlevels."
    },
    {
      "id": 11,
      "question": "Which of these is a State List subject, meaning states legislate on it?",
      "options": [
        "Defence",
        "Police",
        "Foreign affairs",
        "Currency✅"
      ],
      "answer": 1,
      "explanation": "Police is a State List subject under the Seventh Schedule, meaning individual states are responsible for legislating and\nadministering it."
    },
    {
      "id": 12,
      "question": "Which of these is a Union List subject?",
      "options": [
        "Local government",
        "Public health",
        "Defence",
        "Agriculture✅"
      ],
      "answer": 2,
      "explanation": "Defence is a Union List subject, meaning only Parliament has the authority to legislate on it.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 5 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 13,
      "question": "What does the \"Concurrent List\" allow?",
      "options": [
        "Only the Centre can legislate on these subjects",
        "Both the Centre and States can legislate, with Union law prevailing in conflict",
        "Only states can legislate on these subjects",
        "Local bodies exclusively legislate on these subjects"
      ],
      "answer": 1,
      "explanation": "The Concurrent List, covering subjects like education, allows both Centre and States to legislate, with the Union law taking\nprecedence in case of conflict."
    },
    {
      "id": 14,
      "question": "Ramesh has a complaint about a broken streetlight in his neighbourhood. Which level of government should he\napproach?",
      "options": [
        "The central government",
        "His state's chief minister directly",
        "His local Municipal Corporation or Gram Panchayat",
        "The Supreme Court"
      ],
      "answer": 2,
      "explanation": "Streetlights and local infrastructure are local government responsibilities, making the Municipal Corporation or Gram\nPanchayat the correct point of contact."
    },
    {
      "id": 15,
      "question": "Which body would a citizen approach for a passport application?",
      "options": [
        "Local Gram Panchayat",
        "State police department",
        "Central Government (Ministry of External Affairs)",
        "Municipal Corporation"
      ],
      "answer": 2,
      "explanation": "Passports are a Central Government (Union List) subject, handled through the Ministry of External Affairs.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 6 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 16,
      "question": "What is the \"Seventh Schedule\" of the Constitution?",
      "options": [
        "A list of fundamental rights",
        "The section dividing law-making subjects into Union, State, and Concurrent Lists",
        "A schedule of court holidays",
        "A list of political parties"
      ],
      "answer": 1,
      "explanation": "The Seventh Schedule organises legislative subjects into three lists, clarifying which level of government legislates on\nwhat."
    },
    {
      "id": 17,
      "question": "What is the concept of \"checks and balances\" meant to prevent?",
      "options": [
        "Citizens from voting freely",
        "Any single branch of government from becoming too powerful",
        "States from having their own governments",
        "Local bodies from functioning at all"
      ],
      "answer": 1,
      "explanation": "Checks and balances ensure that the Legislature, Executive, and Judiciary each limit and are accountable to one another."
    },
    {
      "id": 18,
      "question": "Can the Judiciary create new laws like the Legislature does?",
      "options": [
        "Yes, courts frequently create entirely new laws",
        "No, courts interpret and apply laws; law-making is the Legislature's constitutional role",
        "Only the Supreme Court can create laws",
        "Only High Courts can create laws"
      ],
      "answer": 1,
      "explanation": "The Judiciary's role is to interpret and apply existing laws, while the Legislature holds the constitutional authority to make\nnew laws.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 7 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 19,
      "question": "Which of these best reflects why some national schemes are described as \"designed centrally but implemented\nthrough state and local governments\"?",
      "options": [
        "Central schemes never involve states at all",
        "Central funding and guidelines often rely on state and local bodies to actually deliver services to citizens",
        "Only local governments design and implement schemes",
        "National schemes are always implemented by international agencies"
      ],
      "answer": 1,
      "explanation": "Many centrally sponsored schemes rely on state departments and local bodies for actual delivery, even though policy and\nfunding originate centrally."
    },
    {
      "id": 20,
      "question": "Which of the following government levels is typically responsible for birth and death registration?",
      "options": [
        "Central Government",
        "State Government exclusively",
        "Local government (Municipal Corporation or Gram Panchayat)",
        "The Supreme Court"
      ],
      "answer": 2,
      "explanation": "Birth and death registration is handled at the local government level, making it one of the clearest examples of a purely\nlocal service."
    },
    {
      "id": 21,
      "question": "Priya wants to file a police complaint about a theft. Which level of government is responsible for police services?",
      "options": [
        "Central Government",
        "State Government",
        "Local Government",
        "The judiciary directly, bypassing police entirely"
      ],
      "answer": 1,
      "explanation": "Police is a State List subject, meaning state governments are responsible for law enforcement and police administration.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 8 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 22,
      "question": "What is the primary function of the \"Legislature\"?",
      "options": [
        "Implementing and enforcing laws",
        "Making laws",
        "Interpreting laws and delivering justice",
        "Collecting taxes directly from citizens"
      ],
      "answer": 1,
      "explanation": "The Legislature — Parliament at the Centre and State Legislatures at the state level — is responsible for making laws."
    },
    {
      "id": 23,
      "question": "What is the primary function of the \"Executive\"?",
      "options": [
        "Making laws",
        "Implementing and enforcing laws and policies",
        "Interpreting the Constitution exclusively",
        "Conducting elections"
      ],
      "answer": 1,
      "explanation": "The Executive — the President/Governor, PM/CM, and Council of Ministers — is responsible for implementing and\nenforcing laws and policies."
    },
    {
      "id": 24,
      "question": "Which of these correctly identifies the \"Vidhan Sabha\"?",
      "options": [
        "India's national Parliament",
        "A state's Legislative Assembly",
        "A type of municipal court",
        "A central government ministry"
      ],
      "answer": 1,
      "explanation": "The Vidhan Sabha is the Legislative Assembly present in every Indian state, forming part of the state legislature.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 9 of 165 • JanGyan — Learn Without Limits"
    },
    {
      "id": 25,
      "question": "Which urban local body typically governs a large city?",
      "options": [
        "Gram Panchayat",
        "Zilla Parishad",
        "Municipal Corporation",
        "Panchayat Samiti"
      ],
      "answer": 2,
      "explanation": "Municipal Corporations are the urban local bodies established to govern large cities under the 74th Constitutional\nAmendment framework."
    }
  ],
  "Road Safety & Public Safety": [
    {
      "id": 1,
      "question": "What is the primary goal of road safety as a discipline?",
      "options": [
        "Increasing traffic speed",
        "Reducing the risk of death, injury, or damage on roads",
        "Reducing the number of vehicles on the road",
        "Increasing the number of traffic police"
      ],
      "answer": 1,
      "explanation": "Road safety refers to the practices, rules, and systems designed to reduce the risk of death, injury, or damage on roads for everyone who uses them."
    },
    {
      "id": 2,
      "question": "According to MoRTH, which factor was linked to the highest share of road accident deaths in India in 2023?",
      "options": [
        "Drunk driving",
        "Overspeeding",
        "Wrong-side driving",
        "Mobile phone use"
      ],
      "answer": 1,
      "explanation": "MoRTH's 2023 report found that overspeeding alone was linked to about 68% of road accident deaths, making it the single largest cause."
    },
    {
      "id": 3,
      "question": "Approximately how many road accidents did India record in 2023, according to MoRTH?",
      "options": [
        "Around 3 lakh",
        "Around 4.8 lakh",
        "Around 6 lakh",
        "Around 8 lakh"
      ],
      "answer": 1,
      "explanation": "MoRTH recorded 4,80,583 road accidents in 2023, the highest number of fatalities ever recorded in a single year in India."
    },
    {
      "id": 4,
      "question": "Which road-user group accounted for the highest share of road accident deaths in India in 2023?",
      "options": [
        "Pedestrians",
        "Cyclists",
        "Two-wheeler riders",
        "Car occupants"
      ],
      "answer": 2,
      "explanation": "Two-wheeler riders accounted for the largest share of road accident deaths in 2023, at around 45%, followed by pedestrians."
    },
    {
      "id": 5,
      "question": "Highways make up roughly what share of India's total road network, yet account for over half of all accidents?",
      "options": [
        "Around 1%",
        "Around 5%",
        "Around 15%",
        "Around 25%"
      ],
      "answer": 1,
      "explanation": "Highways account for only around 5% of India's total road network but were responsible for over 53% of accidents and 59% of fatalities in 2023, reflecting the impact of higher speeds.\n\n\n\n\n\n Page 2 of 115 · JanGyan — Learn Without Limits"
    },
    {
      "id": 6,
      "question": "A road safety officer wants to reduce fatalities on a stretch of highway where speed is the dominant risk factor but human error cannot be fully eliminated. Which\nprinciple best supports redesigning the road itself rather than only targeting driver behaviour?",
      "options": [
        "The Right of Way principle",
        "The Safe System (Safe System Approach)",
        "The Golden Hour concept",
        "The compoundable offence principle"
      ],
      "answer": 1,
      "explanation": "The Safe System Approach holds that since humans will inevitably make mistakes, the road system itself should be designed so that those mistakes do not result in death or serious injury."
    },
    {
      "id": 7,
      "question": "What does the term 'Black Spot' refer to in road safety?",
      "options": [
        "A pothole on the road",
        "A road stretch with a history of frequent or severe accidents",
        "A poorly lit street lamp",
        "A damaged traffic signal"
      ],
      "answer": 1,
      "explanation": "A black spot is a specific stretch of road with a documented history of frequent or severe accidents, often targeted for engineering improvements."
    },
    {
      "id": 8,
      "question": "Which age group accounted for around 66% of road accident victims in India, according to MoRTH data?",
      "options": [
        "Below 18 years",
        "18–45 years",
        "46–60 years",
        "Above 60 years"
      ],
      "answer": 1,
      "explanation": "MoRTH data shows that the 18–45 age group, often the working-age population, accounted for around 66% of road accident victims."
    },
    {
      "id": 9,
      "question": "What is the 'Golden Hour' in the context of road accidents?",
      "options": [
        "The busiest traffic hour of the day",
        "The first hour after a traumatic injury, critical for survival",
        "The hour when most accidents are reported",
        "The hour reserved for road safety awareness campaigns"
      ],
      "answer": 1,
      "explanation": "The Golden Hour is legally defined as the first hour after a traumatic injury, during which prompt medical treatment greatly improves the chances of survival."
    },
    {
      "id": 10,
      "question": "Which Indian state became the first to formally adopt a Vision Zero road safety programme?",
      "options": [
        "Tamil Nadu",
        "Kerala",
        "Haryana",
        "Gujarat"
      ],
      "answer": 2,
      "explanation": "Haryana launched India's first state-level Vision Zero programme in 2017, initially across ten districts before expanding statewide.\n\n\n\n\n Page 3 of 115 · JanGyan — Learn Without Limits"
    },
    {
      "id": 11,
      "question": "A city wants to align its local road safety strategy with the philosophy behind Vision Zero. Which statement best reflects that philosophy?",
      "options": [
        "Traffic fines should be increased until violations stop completely",
        "No loss of life on the road is acceptable, and deaths are preventable, not inevitable",
        "Only professional drivers should be allowed on public roads",
        "Road speed limits should be maximised to reduce congestion"
      ],
      "answer": 1,
      "explanation": "Vision Zero is built on the principle that no traffic death is acceptable and that such deaths and serious injuries are preventable through better systems, not simply an unavoidable cost of\n mobility."
    },
    {
      "id": 12,
      "question": "Under the Motor Vehicles Act, which section makes helmet-wearing compulsory for riders and pillion passengers on two-wheelers?",
      "options": [
        "Section 112",
        "Section 129",
        "Section 146",
        "Section 185"
      ],
      "answer": 1,
      "explanation": "Section 129 of the Motor Vehicles Act makes wearing a protective helmet compulsory for both the rider and pillion passenger on a two-wheeler."
    },
    {
      "id": 13,
      "question": "What is the legal blood alcohol limit for driving in India under Section 185 of the Motor Vehicles Act?",
      "options": [
        "10 mg per 100 ml of blood",
        "30 mg per 100 ml of blood",
        "50 mg per 100 ml of blood",
        "80 mg per 100 ml of blood"
      ],
      "answer": 1,
      "explanation": "Section 185 sets the legal blood alcohol limit at 30 mg per 100 ml of blood; driving above this limit is an offence."
    },
    {
      "id": 14,
      "question": "What is the minimum age to obtain a licence to drive a car or geared two-wheeler in India?",
      "options": [
        "16 years",
        "18 years",
        "20 years",
        "21 years"
      ],
      "answer": 1,
      "explanation": "The minimum age to hold a licence for a car or a geared two-wheeler is 18 years, while a limited licence for a gearless two-wheeler up to 50cc may be issued from age 16."
    },
    {
      "id": 15,
      "question": "Who is legally protected from harassment under India's Good Samaritan guidelines?",
      "options": [
        "Only doctors who treat accident victims",
        "Any bystander who voluntarily helps an accident victim",
        "Only the driver responsible for the accident",
        "Only police officers at the scene"
      ],
      "answer": 1,
      "explanation": "Good Samaritan guidelines protect any bystander who voluntarily helps an accident victim from legal harassment, repeated questioning, or being forced to disclose their identity.\n\n\n\n\n Page 4 of 115 · JanGyan — Learn Without Limits"
    },
    {
      "id": 16,
      "question": "What does the Cashless Treatment Scheme, 2025 primarily guarantee to road accident victims?",
      "options": [
        "Free lifetime healthcare",
        "Free treatment up to ₹1.5 lakh for the first seven days at designated hospitals",
        "A one-time cash payment of ₹1.5 lakh",
        "Free vehicle repair after an accident"
      ],
      "answer": 1,
      "explanation": "The Cashless Treatment Scheme, 2025 guarantees cashless emergency treatment of up to ₹1.5 lakh for the first seven days after an accident, at designated hospitals."
    },
    {
      "id": 17,
      "question": "Approximately what percentage of road accidents in 2022 occurred between 6 PM and 9 PM, according to MoRTH?",
      "options": [
        "About 5%",
        "About 10%",
        "About 20%",
        "About 35%"
      ],
      "answer": 2,
      "explanation": "MoRTH data for 2022 shows that around 20.4% of accidents occurred between 6 PM and 9 PM, making it the busiest and riskiest window of the day."
    },
    {
      "id": 18,
      "question": "Which of these is generally considered the most vulnerable type of road user, with no physical protection at all?",
      "options": [
        "Bus passengers",
        "Car drivers",
        "Pedestrians",
        "Truck drivers"
      ],
      "answer": 2,
      "explanation": "Pedestrians have no physical protective shell around them, making them among the most vulnerable road users during any collision."
    },
    {
      "id": 19,
      "question": "When is India's National Road Safety Month observed each year?",
      "options": [
        "January",
        "March",
        "July",
        "November"
      ],
      "answer": 0,
      "explanation": "MoRTH observes National Road Safety Month every January to raise public awareness about safe road behaviour and traffic rules.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 5 of 115 · JanGyan — Learn Without Limits"
    },
    {
      "id": 20,
      "question": "MoRTH data shows that rural areas accounted for about 68% of road deaths in 2022, compared to 32% in urban areas. What is the most reasonable explanation\nconsistent with other MoRTH findings covered in this series?",
      "options": [
        "Rural roads have far more traffic police than urban roads",
        "Higher-speed highway stretches run largely through rural and semi-urban areas",
        "Urban areas have no traffic laws",
        "Rural residents do not use helmets or seatbelts at all"
      ],
      "answer": 1,
      "explanation": "consistent with other MoRTH findings covered in this series?\n\nA. Rural roads have far more traffic police than urban roads\n\nB. Higher-speed highway stretches run largely through rural and semi-urban areas\n\nC. Urban areas have no traffic laws\n\nD. Rural residents do not use helmets or seatbelts at all\n\n\n Correct Answer: Option (B)\n Short Explanation:\n\n Since highways carry a disproportionate share of accidents and fatalities due to higher speeds, and much of the highway network passes through rural and semi-urban stretches, this helps\n explain the higher rural share of deaths."
    },
    {
      "id": 21,
      "question": "Under the Motor Vehicles (Amendment) Act, 2019, what is the minimum compensation for an accident death, up from the earlier ₹25,000?",
      "options": [
        "₹50,000",
        "₹1 lakh",
        "₹2 lakh",
        "₹5 lakh"
      ],
      "answer": 2,
      "explanation": "The 2019 amendment raised the minimum compensation for accident death to ₹2 lakh, a significant increase from the earlier ₹25,000."
    },
    {
      "id": 22,
      "question": "Which Indian city recorded the highest number of road accidents among million-plus population cities in 2022?",
      "options": [
        "Mumbai",
        "Bengaluru",
        "Delhi",
        "Chennai"
      ],
      "answer": 2,
      "explanation": "Delhi recorded the highest number of road accidents (5,652) among Indian million-plus cities in 2022, and remains the only such city with over 1,000 road accident deaths in a year."
    },
    {
      "id": 23,
      "question": "What is a 'Road Accident' generally defined as?",
      "options": [
        "Any vehicle breakdown on a public road",
        "An unplanned, unexpected event on a public road resulting in death, injury, or damage",
        "Any traffic jam lasting more than 30 minutes",
        "Only accidents involving two or more vehicles"
      ],
      "answer": 1,
      "explanation": "A road accident is defined as an unplanned, unexpected event on a public road that results in death, injury, or damage.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Page 6 of 115 · JanGyan — Learn Without Limits"
    },
    {
      "id": 24,
      "question": "What was the total number of road accident deaths recorded in India in 2023?",
      "options": [
        "1,53,972",
        "1,68,491",
        "1,72,890",
        "1,80,320"
      ],
      "answer": 2,
      "explanation": "India recorded 1,72,890 road accident deaths in 2023, the highest ever recorded in a single year according to MoRTH."
    },
    {
      "id": 25,
      "question": "A district administration is choosing between two interventions with a fixed budget: better street lighting on a rural highway stretch, or a public awareness campaign\non helmet use in the same district. Based on MoRTH's cause-of-accident data, which single intervention is most likely to have the largest direct impact on fatalities, all\nelse equal?",
      "options": [
        "The awareness campaign, since overspeeding is a behavioural issue unrelated to lighting",
        "The lighting improvement, since darkness is the leading cause of all accidents",
        "Neither, since black spot rectification is the only effective measure",
        "It depends on whether the stretch is also a high-speed corridor, since overspeeding remains the leading cause nationally"
      ],
      "answer": 3,
      "explanation": "Since overspeeding is consistently the largest single contributor to road deaths, the effectiveness of either intervention depends heavily on whether excessive speed is also a major factor on\n that specific stretch — engineering and behavioural measures often need to be combined for the type of road involved."
    }
  ],
  "Health & Emergency Awareness": [
    {
      "id": 1,
      "question": "A public health campaign eliminates stagnant water across an entire town rather than treating dengue cases\nindividually. What principle does this reflect?",
      "options": [
        "Tertiary prevention focused on individuals",
        "Population-level primary prevention addressing a shared risk factor",
        "A purely curative approach",
        "An approach with no measurable public health value"
      ],
      "answer": 1,
      "explanation": "Addressing a shared environmental risk factor across a whole population is a hallmark of population-level primary\nprevention."
    },
    {
      "id": 2,
      "question": "Why might treating 'feeling fine' as equivalent to 'being healthy' be especially risky for hypertension-prone\nindividuals?",
      "options": [
        "Hypertension always causes early, obvious symptoms",
        "Hypertension often has no symptoms, so it can progress silently without regular checks",
        "Hypertension is not linked to any serious complications",
        "Feeling fine guarantees normal blood pressure"
      ],
      "answer": 1,
      "explanation": "Because hypertension frequently has no symptoms, relying on how one feels rather than screening can allow it to progress\nundetected."
    },
    {
      "id": 3,
      "question": "What does a 'vector-borne disease' mean?",
      "options": [
        "A disease passed only through water",
        "A disease transmitted by a living organism such as a mosquito",
        "A disease caused by poor diet",
        "A hereditary disease"
      ],
      "answer": 1,
      "explanation": "A vector-borne disease is transmitted through a living organism, such as a mosquito, as seen in dengue or malaria."
    },
    {
      "id": 4,
      "question": "What is a key advantage of preventive healthcare compared to waiting until disease is advanced?",
      "options": [
        "Higher long-term treatment costs",
        "Lower long-term costs and better quality of life",
        "No difference in outcomes",
        "Preventive care always takes longer"
      ],
      "answer": 1,
      "explanation": "Preventive healthcare typically leads to lower long-term costs, earlier detection, and better overall quality of life."
    },
    {
      "id": 5,
      "question": "In India, which number connects a caller to unified emergency response, including police, fire, and medical help?",
      "options": [
        "100",
        "112",
        "101",
        "102"
      ],
      "answer": 1,
      "explanation": "112 is India's unified emergency number, connecting citizens to police, fire, and medical emergency services.\n\n\n\n\n\n\n\n\n\n\n\n Page 2 of 104 · JanGyan — Learn Without Limits"
    },
    {
      "id": 6,
      "question": "How long should a person wash their hands with soap to effectively remove germs?",
      "options": [
        "2 seconds",
        "At least 20 seconds",
        "5 minutes",
        "Only when visibly dirty"
      ],
      "answer": 1,
      "explanation": "Washing hands with soap for at least 20 seconds, covering all surfaces, is the standard effective hygiene practice."
    },
    {
      "id": 7,
      "question": "How does the 'Chain of Survival' concept in general health thinking relate to the idea of interconnected\nprevention levels?",
      "options": [
        "It is unrelated to prevention entirely",
        "Both emphasise that early action at each stage strongly influences the final outcome",
        "It only applies to hospitals, not communities",
        "It replaces the need for primary prevention"
      ],
      "answer": 1,
      "explanation": "Similar to prevention levels, frameworks like the Chain of Survival stress that early, appropriate action at each stage\nimproves final outcomes."
    },
    {
      "id": 8,
      "question": "Why does India's National Health Policy, 2017 emphasise preventive and promotive healthcare?",
      "options": [
        "Because curative care is always cheaper",
        "Because prevention is generally more cost-effective than treating advanced disease",
        "Because it eliminates the need for hospitals",
        "Because it only applies to rural areas"
      ],
      "answer": 1,
      "explanation": "The policy prioritises prevention because catching or avoiding illness early is typically far less costly than treating\nadvanced disease."
    },
    {
      "id": 9,
      "question": "Why does India's shift from mostly communicable to NCD-dominant deaths matter for public health planning?",
      "options": [
        "It suggests healthcare systems should stop focusing on vaccination entirely",
        "It signals a need to balance infectious disease control with lifestyle disease prevention",
        "It means communicable diseases are no longer a concern anywhere",
        "It has no implications for government health policy"
      ],
      "answer": 1,
      "explanation": "Because both disease types remain relevant, health systems must balance continued infectious disease control with rising\nlifestyle disease prevention."
    },
    {
      "id": 10,
      "question": "Which of these best fits the 'about half the plate' portion in the Balanced Indian Thali model?",
      "options": [
        "Fried snacks",
        "Vegetables and fruits",
        "Sugary drinks",
        "Refined oil"
      ],
      "answer": 1,
      "explanation": "The Balanced Indian Thali model recommends filling about half the plate with vegetables and fruits.\n\n\n\n\n\n\n\n\n\n\n\n Page 3 of 104 · JanGyan — Learn Without Limits"
    },
    {
      "id": 11,
      "question": "Why is it inaccurate to say 'if I don't feel sick, I am completely healthy'?",
      "options": [
        "Because feeling unwell is always visible",
        "Because health also includes mental and social well-being, which may be affected without physical symptoms",
        "Because doctors always disagree with patients",
        "Because illness is impossible to detect without lab tests"
      ],
      "answer": 1,
      "explanation": "A person can feel physically fine yet still lack complete health if their mental or social well-being is compromised."
    },
    {
      "id": 12,
      "question": "What is the recommended amount of moderate physical activity for adults, according to general public health\nguidance?",
      "options": [
        "10 minutes a week",
        "30 minutes on most days",
        "2 hours daily",
        "Only on weekends"
      ],
      "answer": 1,
      "explanation": "Around 30 minutes of moderate activity, such as brisk walking, on most days is a standard general guideline for adults."
    },
    {
      "id": 13,
      "question": "What is the main idea behind describing health as a 'spectrum' rather than a fixed label?",
      "options": [
        "Health never changes once achieved",
        "A person moves between wellness and illness depending on daily choices",
        "Only doctors can judge someone's health",
        "Health has no connection to daily habits"
      ],
      "answer": 1,
      "explanation": "Viewing health as a spectrum reflects that daily choices continually shift a person between greater wellness and greater\nrisk of illness."
    },
    {
      "id": 14,
      "question": "A citizen assumes that because their locality has clean water, personal hygiene practices like handwashing are\nno longer necessary. Why is this reasoning flawed?",
      "options": [
        "Clean water alone eliminates all disease transmission routes",
        "Hygiene practices address multiple transmission routes beyond water alone, such as direct contact",
        "Handwashing is only relevant in areas without clean water",
        "Personal hygiene has no scientific basis"
      ],
      "answer": 1,
      "explanation": "Clean water reduces waterborne risk, but hygiene practices like handwashing address other transmission routes, such as\ndirect contact, that water quality alone doesn't solve."
    },
    {
      "id": 15,
      "question": "A citizen wants to reduce their own long-term risk of NCDs using only free or low-cost actions. Which\ncombination best reflects primary prevention?",
      "options": [
        "Waiting for symptoms, then visiting a specialist",
        "Balanced diet, physical activity, and avoiding tobacco",
        "Buying expensive supplements only",
        "Ignoring family history entirely"
      ],
      "answer": 1,
      "explanation": "A balanced diet, regular activity, and avoiding tobacco are low-cost primary prevention actions that reduce long-term NCD\nrisk.\n\n\n\n\n\n\n\n Page 4 of 104 · JanGyan — Learn Without Limits"
    },
    {
      "id": 16,
      "question": "Which of the following is NOT one of the three core dimensions of health described by the WHO definition?",
      "options": [
        "Physical",
        "Mental",
        "Social",
        "Financial"
      ],
      "answer": 3,
      "explanation": "The WHO definition of health centres on physical, mental, and social well-being — financial status is not one of these core\ndimensions."
    },
    {
      "id": 17,
      "question": "Why does the National Health Policy 2017 support Universal Health Coverage?",
      "options": [
        "To ensure citizens don't face financial hardship while accessing healthcare",
        "To make all healthcare private",
        "To eliminate government hospitals",
        "To reduce the number of doctors in India"
      ],
      "answer": 0,
      "explanation": "Universal Health Coverage under the policy aims to ensure citizens can access healthcare without facing financial\nhardship."
    },
    {
      "id": 18,
      "question": "What is 'public health' primarily concerned with?",
      "options": [
        "Only treating wealthy individuals",
        "Protecting and improving the health of entire communities",
        "Selling private health insurance",
        "Building luxury hospitals"
      ],
      "answer": 1,
      "explanation": "Public health focuses on protecting and improving the health of whole communities, not just individual patients."
    },
    {
      "id": 19,
      "question": "Which of these is an example of a Non-Communicable Disease (NCD)?",
      "options": [
        "Dengue",
        "Tuberculosis",
        "Diabetes",
        "Malaria"
      ],
      "answer": 2,
      "explanation": "Diabetes is a non-communicable disease, developing from lifestyle and genetic factors rather than spreading between\npeople."
    },
    {
      "id": 20,
      "question": "What does eSanjeevani primarily provide to citizens?",
      "options": [
        "Free ambulance services",
        "Online doctor consultations via telemedicine",
        "Government job listings",
        "Free school admissions"
      ],
      "answer": 1,
      "explanation": "eSanjeevani is a national telemedicine platform that provides free online doctor consultations, especially valuable in rural\nareas.\n\n\n\n\n\n\n\n\n\n\n\n\n Page 5 of 104 · JanGyan — Learn Without Limits"
    },
    {
      "id": 21,
      "question": "A person constantly relies on packaged, processed food due to a busy schedule. What is the most likely long-\nterm health risk?",
      "options": [
        "Improved nutrition over time",
        "Increased risk of lifestyle-related NCDs",
        "Guaranteed weight loss",
        "No health impact at all"
      ],
      "answer": 1,
      "explanation": "Frequent reliance on processed food, often high in salt, sugar, and unhealthy fats, raises long-term risk of NCDs like\ndiabetes and hypertension."
    },
    {
      "id": 22,
      "question": "What is the National Health Mission (NHM) primarily responsible for?",
      "options": [
        "Only urban hospitals",
        "Strengthening public healthcare infrastructure across India",
        "Private hospital insurance",
        "Only child vaccination"
      ],
      "answer": 1,
      "explanation": "The National Health Mission strengthens public healthcare infrastructure across both rural and urban India."
    },
    {
      "id": 23,
      "question": "Which statement best reflects the relationship between the three dimensions of health?",
      "options": [
        "They function completely independently of each other",
        "Poor sleep, for example, can affect mood and relationships, showing they're interconnected",
        "Only physical health matters in daily life",
        "Mental health has no impact on physical health"
      ],
      "answer": 1,
      "explanation": "The three dimensions are interconnected — for example, poor sleep (physical) can affect mood (mental) and relationships\n(social)."
    },
    {
      "id": 24,
      "question": "What does the term 'preventive healthcare' mean?",
      "options": [
        "Treating a disease after symptoms appear",
        "Actions taken to stop illness before it starts",
        "Only visiting a hospital in an emergency",
        "Buying health insurance"
      ],
      "answer": 1,
      "explanation": "Preventive healthcare focuses on avoiding illness in advance, such as vaccination and healthy habits, rather than treating\ndisease afterward."
    },
    {
      "id": 25,
      "question": "A factory worker eats fried snacks daily, rarely exercises, and has a family history of diabetes. Which type of\ndisease is he at highest risk for?",
      "options": [
        "Communicable disease",
        "Non-communicable disease",
        "Vector-borne disease",
        "Waterborne disease"
      ],
      "answer": 1,
      "explanation": "His lifestyle pattern and family history point to elevated risk of a non-communicable disease such as diabetes.\n\n\n\n\n\n\n\n\n\n\n Page 6 of 104 · JanGyan — Learn Without Limits"
    }
  ],
  "Financial Literacy & Digital Finance": [
    {
      "id": 1,
      "question": "A financial goal to build an emergency fund within the next 8 months is best classified as:",
      "options": [
        "A long-term goal",
        "A medium-term goal",
        "A short-term goal",
        "Not a financial goal at all"
      ],
      "answer": 2,
      "explanation": "Short-term goals are typically defined as those to be achieved within one year, making an 8-month emergency fund target a\nshort-term goal."
    },
    {
      "id": 2,
      "question": "Approximately how many NPS and Atal Pension Yojana subscribers did India have combined, as of July 2026?",
      "options": [
        "Around 1 crore",
        "Around 5 crore",
        "Around 10.11 crore",
        "Around 50 crore"
      ],
      "answer": 2,
      "explanation": "NPS and Atal Pension Yojana together had approximately 10.11 crore subscribers as of July 2026, with assets under\nmanagement of about ₹18.14 lakh crore."
    },
    {
      "id": 3,
      "question": "What is a \"mutual fund\"?",
      "options": [
        "A single company's stock",
        "A pooled investment that professionally manages money across stocks, bonds, or other assets",
        "A type of savings account offered only by post offices",
        "A government tax refund scheme"
      ],
      "answer": 1,
      "explanation": "A mutual fund pools money from many investors and invests it in a diversified mix of assets, managed by a professional fund\nmanager."
    },
    {
      "id": 4,
      "question": "Which of the following is an example of an unsecured loan?",
      "options": [
        "Home loan",
        "Gold loan",
        "Personal loan",
        "Car loan"
      ],
      "answer": 2,
      "explanation": "A personal loan is unsecured, meaning it requires no collateral, unlike home, gold, or car loans which are backed by an asset."
    },
    {
      "id": 5,
      "question": "Which of these best illustrates \"goal-based saving\" applied practically?",
      "options": [
        "Saving money with no plan for its future use",
        "Opening a Recurring Deposit specifically earmarked for an upcoming wedding expense",
        "Spending all income immediately upon receipt",
        "Avoiding any form of bank deposit"
      ],
      "answer": 1,
      "explanation": "Opening a Recurring Deposit earmarked specifically for a wedding is a clear example of goal-based saving tied to a defined\npurpose.\n\n\n\n Page 1 of 100 • JanGyan — Learn Without Limits"
    },
    {
      "id": 6,
      "question": "What was the approximate EPF interest rate for FY 2025-26?",
      "options": [
        "2%",
        "8.25%",
        "15%",
        "25%"
      ],
      "answer": 1,
      "explanation": "EPF offered an interest rate of approximately 8.25% per annum for FY 2025-26, benefiting over 7 crore contributing members."
    },
    {
      "id": 7,
      "question": "What is a common misconception about NPS returns?",
      "options": [
        "That NPS returns are fixed and guaranteed",
        "That NPS returns are always zero",
        "That NPS has no regulatory oversight",
        "That NPS is only for government employees"
      ],
      "answer": 0,
      "explanation": "A common misconception is that NPS returns are fixed and guaranteed, when in reality they are market-linked and depend on\nthe investment choices made within the scheme."
    },
    {
      "id": 8,
      "question": "Which of the following best describes the \"A\" in the JAM Trinity?",
      "options": [
        "Automated Teller Machine access",
        "Aadhaar, providing a unique verified identity for beneficiaries",
        "Asset ownership records",
        "Annual income declaration"
      ],
      "answer": 1,
      "explanation": "The \"A\" in the JAM Trinity stands for Aadhaar, which provides a unique, verified identity that supports accurate benefit delivery."
    },
    {
      "id": 9,
      "question": "Which of the following best describes why \"digital arrest\" style scams (fraudsters posing as officials over video call\ndemanding money) are always fraudulent?",
      "options": [
        "Indian law enforcement regularly makes arrests and collects fines over video calls",
        "No Indian law enforcement agency conducts arrests, investigations, or fine collection via video or phone call",
        "This type of scam is only fraudulent if the caller doesn't show a uniform",
        "This is a legitimate legal process reserved for serious crimes"
      ],
      "answer": 1,
      "explanation": "No Indian law enforcement agency conducts arrests, investigations, or fine collection via video or phone call — any such claim is\nalways a scam."
    },
    {
      "id": 10,
      "question": "A person receives a bonus and is unsure how to use it. What does a financially disciplined approach suggest?",
      "options": [
        "Spend the entire bonus immediately on wants",
        "Split it between a savings goal or emergency fund and some discretionary enjoyment",
        "Ignore the bonus and leave it unused indefinitely",
        "Use the entire bonus to make a high-risk, unverified investment"
      ],
      "answer": 1,
      "explanation": "A financially disciplined approach splits a bonus between savings/goals and some enjoyment, rather than spending it all at once\nor letting it sit idle.\n\n\n\n Page 2 of 100 • JanGyan — Learn Without Limits"
    },
    {
      "id": 11,
      "question": "A person avoids ever learning about budgeting because they believe \"financial literacy is only for accountants.\" What is\nthe risk of this belief?",
      "options": [
        "There is no risk; the belief is accurate",
        "They may make costly financial decisions due to lack of basic money management skills",
        "It guarantees they will never face financial difficulty",
        "It automatically qualifies them for government schemes"
      ],
      "answer": 1,
      "explanation": "Believing financial literacy is only for professionals can lead to costly mistakes, since everyday money management applies to\neveryone."
    },
    {
      "id": 12,
      "question": "What is an \"overdraft\" facility?",
      "options": [
        "A facility allowing withdrawal beyond the account balance, up to an approved limit",
        "A type of insurance product",
        "A facility only available on Fixed Deposits",
        "A mandatory fee charged on every withdrawal"
      ],
      "answer": 0,
      "explanation": "An overdraft allows a customer to withdraw more than their account balance, up to a pre-approved limit, functioning like a\nshort-term credit line."
    },
    {
      "id": 13,
      "question": "A family delays reviewing its financial goals for several years despite major life changes like a new child. What risk does\nthis create?",
      "options": [
        "No risk, as goals never need revisiting",
        "The financial plan may no longer match the family's actual needs and circumstances",
        "It automatically increases their credit score",
        "It has no bearing on financial planning"
      ],
      "answer": 1,
      "explanation": "Failing to revisit financial goals after major life changes risks a mismatch between the plan and the family's actual current\nneeds."
    },
    {
      "id": 14,
      "question": "What is the safest response to a message threatening legal action or account suspension unless immediate payment is\nmade?",
      "options": [
        "Pay immediately to avoid the threatened consequence",
        "Pause, verify independently through official channels, and avoid acting out of panic",
        "Reply to the message asking for more details",
        "Forward the payment request to a friend for a second opinion before paying"
      ],
      "answer": 1,
      "explanation": "Urgency and fear-based threats are common fraud tactics; the safest response is to pause and verify independently through\nofficial channels rather than reacting immediately."
    },
    {
      "id": 15,
      "question": "A 25-year-old starts contributing to a retirement scheme, while a 40-year-old starts with the same monthly amount. Why\ndoes the 25-year-old likely end up with a significantly larger corpus at retirement?",
      "options": [
        "Age has no bearing on the final retirement corpus",
        "The 25-year-old benefits from many more years of compounding on their contributions",
        "Younger contributors always receive higher interest rates",
        "Older contributors are legally required to contribute less"
      ],
      "answer": 1,
      "explanation": "Starting earlier gives contributions many more years to benefit from compounding, resulting in a significantly larger corpus\neven with the same contribution amount.\n\n\n\n Page 3 of 100 • JanGyan — Learn Without Limits"
    },
    {
      "id": 16,
      "question": "What is a \"premium\" in an insurance policy?",
      "options": [
        "The amount payable by the insurer upon a claim",
        "The amount paid, usually annually or monthly, to keep an insurance policy active",
        "A bonus given only to long-term policyholders",
        "The total value of an insured asset"
      ],
      "answer": 1,
      "explanation": "A premium is the regular amount paid, monthly or annually, to keep an insurance policy active and in force."
    },
    {
      "id": 17,
      "question": "What does IRDAI regulate?",
      "options": [
        "Only life insurance companies",
        "All insurers in India, protecting policyholder interests across life and general insurance",
        "Only government-run insurance schemes",
        "Only vehicle insurance premiums"
      ],
      "answer": 1,
      "explanation": "IRDAI (Insurance Regulatory and Development Authority of India) regulates all insurers in India and protects policyholder\ninterests broadly."
    },
    {
      "id": 18,
      "question": "A person receives a missed call from an unknown number and worries their UPI account could be compromised. What is\nthe accurate assessment?",
      "options": [
        "A missed call alone can steal UPI funds",
        "A missed call alone cannot access their account; money only moves after MPIN authorisation",
        "They must immediately delete their UPI app",
        "Missed calls always drain bank balances instantly"
      ],
      "answer": 1,
      "explanation": "A missed or blank call alone cannot access UPI funds — money only moves once the account holder authorises a transaction\nwith their MPIN."
    },
    {
      "id": 19,
      "question": "What is a \"passbook\" used for?",
      "options": [
        "Applying for a loan",
        "A record of all transactions in a savings account",
        "Filing income tax returns",
        "Making UPI payments"
      ],
      "answer": 1,
      "explanation": "A passbook is a physical or digital record of all transactions in a savings account, updated at a branch or via an app."
    },
    {
      "id": 20,
      "question": "What percentage of Indian adults were found to be financially literate among women, according to the NCFE survey?",
      "options": [
        "Approximately 21%",
        "Approximately 45%",
        "Approximately 60%",
        "Approximately 90%"
      ],
      "answer": 0,
      "explanation": "The NCFE survey found financial literacy among women in India to be approximately 21%, compared to approximately 29%\namong men.\n\n\n\n Page 4 of 100 • JanGyan — Learn Without Limits"
    },
    {
      "id": 21,
      "question": "What is the Digital Rupee (e₹)?",
      "options": [
        "A cryptocurrency created by a private company",
        "A digital form of official currency issued directly by the RBI (Central Bank Digital Currency)",
        "A type of UPI-linked credit card",
        "A tax refund mechanism"
      ],
      "answer": 1,
      "explanation": "The Digital Rupee (e₹) is a Central Bank Digital Currency, a digital form of official currency issued directly by the RBI, distinct\nfrom UPI or private cryptocurrencies."
    },
    {
      "id": 22,
      "question": "What is the meaning of \"sum insured\" in a health insurance policy?",
      "options": [
        "The monthly premium amount",
        "The maximum amount the insurer will pay for covered medical expenses in a policy year",
        "The hospital's registration number",
        "The number of family members covered"
      ],
      "answer": 1,
      "explanation": "The sum insured is the maximum amount an insurer will pay toward covered medical expenses within a policy year."
    },
    {
      "id": 23,
      "question": "Who contributes to an individual's Employees' Provident Fund (EPF) account each month?",
      "options": [
        "Only the government",
        "Both the employer and the employee",
        "Only the employee",
        "Only the employer"
      ],
      "answer": 1,
      "explanation": "Both the employer and the employee contribute a fixed percentage of salary each month to an individual's EPF account."
    },
    {
      "id": 24,
      "question": "A customer wants to send a very large payment and is asked by the bank to confirm cheque details electronically before it\nis processed. What system does this describe?",
      "options": [
        "NEFT batch processing",
        "Positive Pay System",
        "IMPS verification",
        "RuPay authentication"
      ],
      "answer": 1,
      "explanation": "The Positive Pay System requires the cheque issuer to confirm key details electronically before a high-value cheque is\nhonoured, reducing fraud risk."
    },
    {
      "id": 25,
      "question": "What is the main reason RBI mandates security measures like card tokenisation for online transactions?",
      "options": [
        "To make online payments more complicated for no reason",
        "To reduce the risk of card data theft if a merchant's systems are compromised",
        "To eliminate the need for OTPs entirely",
        "To increase transaction fees for consumers"
      ],
      "answer": 1,
      "explanation": "Tokenisation replaces stored card details with secure tokens, reducing the risk of card data theft if a merchant's systems are\never compromised.\n\n\n\n Page 5 of 100 • JanGyan — Learn Without Limits"
    }
  ],
  "Environment & Civic Responsibility": [
    {
      "id": 1,
      "question": "What does the term 'environment' primarily refer to?",
      "options": [
        "Only the plants and animals in an area",
        "Everything living and non-living that surrounds and sustains life",
        "Only man-made structures",
        "Only the atmosphere"
      ],
      "answer": 1,
      "explanation": "The environment includes both biotic (living) and abiotic (non-living) components that together sustain life."
    },
    {
      "id": 2,
      "question": "Which of the following is an abiotic component of the environment?",
      "options": [
        "Bacteria",
        "Sunlight",
        "Fungi",
        "Trees"
      ],
      "answer": 1,
      "explanation": "Abiotic components are non-living physical and chemical factors such as sunlight, air, water, and soil."
    },
    {
      "id": 3,
      "question": "Which of the following best defines an ecosystem?",
      "options": [
        "A single species living alone",
        "A community of organisms interacting with each other and their physical environment",
        "A protected forest area only",
        "A man-made park"
      ],
      "answer": 1,
      "explanation": "An ecosystem is a functional unit where living organisms interact with each other and their non-living surroundings."
    },
    {
      "id": 4,
      "question": "Biodiversity refers to variety of life at which levels?",
      "options": [
        "Only species level",
        "Genetic, species, and ecosystem levels",
        "Only genetic level",
        "Only ecosystem level"
      ],
      "answer": 1,
      "explanation": "Biodiversity operates at three interconnected levels: genetic, species, and ecosystem diversity.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 2  JanGyan — Learn Without Limits"
    },
    {
      "id": 5,
      "question": "Which commission first defined 'sustainable development'?",
      "options": [
        "Swaran Singh Committee",
        "Brundtland Commission",
        "Justice Verma Committee",
        "Chipko Committee"
      ],
      "answer": 1,
      "explanation": "The Brundtland Commission (1987) defined sustainable development as meeting present needs without\n compromising future generations' ability to meet theirs."
    },
    {
      "id": 6,
      "question": "What are the three pillars of sustainable development?",
      "options": [
        "Political, Social, Cultural",
        "Environmental, Social, Economic",
        "Legal, Environmental, Technical",
        "Economic, Political, Legal"
      ],
      "answer": 1,
      "explanation": "Sustainable development balances Environmental protection, Social equity, and Economic viability together."
    },
    {
      "id": 7,
      "question": "India is classified internationally as a:",
      "options": [
        "Water-rich nation only",
        "Megadiverse country",
        "Desert nation",
        "Non-biodiverse country"
      ],
      "answer": 1,
      "explanation": "India is one of only 17 globally recognised megadiverse countries, home to a disproportionate share of the world's\n species."
    },
    {
      "id": 8,
      "question": "How many globally recognised biodiversity hotspots does India host?",
      "options": [
        "Two",
        "Three",
        "Four",
        "Six"
      ],
      "answer": 2,
      "explanation": "India hosts four biodiversity hotspots: the Himalayas, Western Ghats, Indo-Burma region, and Sundaland.\n\n\n\n\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 3  JanGyan — Learn Without Limits"
    },
    {
      "id": 9,
      "question": "Which of the following is an example of a natural resource?",
      "options": [
        "Plastic bottle",
        "Sunlight",
        "Mobile phone",
        "Synthetic fabric"
      ],
      "answer": 1,
      "explanation": "Sunlight is a naturally occurring energy source that humans use directly, making it a natural resource."
    },
    {
      "id": 10,
      "question": "The maximum population an ecosystem can sustainably support is called its:",
      "options": [
        "Ecological footprint",
        "Carrying capacity",
        "Biomass index",
        "Resource ceiling"
      ],
      "answer": 1,
      "explanation": "Carrying capacity refers to the maximum population size an ecosystem can support without degrading."
    },
    {
      "id": 11,
      "question": "Which SDG specifically addresses 'Clean Water and Sanitation'?",
      "options": [
        "SDG 6",
        "SDG 7",
        "SDG 11",
        "SDG 13"
      ],
      "answer": 0,
      "explanation": "SDG 6 of the United Nations Sustainable Development Goals focuses on ensuring availability of clean water and\n sanitation for all."
    },
    {
      "id": 12,
      "question": "Which SDG focuses on 'Climate Action'?",
      "options": [
        "SDG 11",
        "SDG 12",
        "SDG 13",
        "SDG 15"
      ],
      "answer": 2,
      "explanation": "SDG 13 specifically calls for urgent action to combat climate change and its impacts.\n\n\n\n\n\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 4  JanGyan — Learn Without Limits"
    },
    {
      "id": 13,
      "question": "What is the 'ecological footprint' of an individual or nation?",
      "options": [
        "The area of forest they own",
        "A measure of land and resources consumed relative to what nature can regenerate",
        "The number of endangered species they protect",
        "Their total population size"
      ],
      "answer": 1,
      "explanation": "Ecological footprint measures how much productive land and resources are used relative to nature's regenerative\n capacity."
    },
    {
      "id": 14,
      "question": "Which Indian law is considered the 'umbrella legislation' for environmental protection?",
      "options": [
        "Wildlife Protection Act, 1972",
        "Environment (Protection) Act, 1986",
        "Forest Act, 1927",
        "Water Act, 1974"
      ],
      "answer": 1,
      "explanation": "The Environment (Protection) Act, 1986 empowers the government to regulate and act against any activity harming\n the environment, making it the umbrella law."
    },
    {
      "id": 15,
      "question": "The Environment (Protection) Act, 1986 was enacted largely in response to which event?",
      "options": [
        "Chipko Movement",
        "Bhopal Gas Tragedy",
        "Silent Valley Movement",
        "Namami Gange launch"
      ],
      "answer": 1,
      "explanation": "The Act was passed in the aftermath of the 1984 Bhopal Gas Tragedy to strengthen India's environmental\n regulatory framework."
    },
    {
      "id": 16,
      "question": "Which body is India's national pollution monitoring and standard-setting authority?",
      "options": [
        "NDMA",
        "Central Pollution Control Board (CPCB)",
        "NTCA",
        "BEE"
      ],
      "answer": 1,
      "explanation": "The CPCB sets and enforces national standards for air and water quality across India.\n\n\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 5  JanGyan — Learn Without Limits"
    },
    {
      "id": 17,
      "question": "Which of the following is a producer in an ecosystem's food chain?",
      "options": [
        "Lion",
        "Deer",
        "Grass",
        "Vulture"
      ],
      "answer": 2,
      "explanation": "Producers, such as grass and other plants, convert sunlight into energy through photosynthesis, forming the base of\n the food chain."
    },
    {
      "id": 18,
      "question": "Decomposers in an ecosystem primarily function to:",
      "options": [
        "Hunt herbivores",
        "Break down dead organic matter and recycle nutrients",
        "Produce oxygen only",
        "Store water underground"
      ],
      "answer": 1,
      "explanation": "Decomposers like fungi and bacteria break down dead matter, returning nutrients to the soil for reuse."
    },
    {
      "id": 19,
      "question": "What is the 'precautionary principle' in environmental policy?",
      "options": [
        "Acting only after scientific certainty is proven",
        "Acting to prevent environmental harm even without full scientific certainty",
        "Ignoring environmental risks until proven harmful",
        "Delaying all environmental regulation"
      ],
      "answer": 1,
      "explanation": "The precautionary principle supports taking preventive action against environmental harm even when scientific\n evidence is not yet fully conclusive."
    },
    {
      "id": 20,
      "question": "Which of the following best describes 'habitat fragmentation'?",
      "options": [
        "Combining small habitats into one large reserve",
        "Breaking up large continuous habitats into smaller isolated patches",
        "Planting new forests",
        "Restoring wetlands"
      ],
      "answer": 1,
      "explanation": "Habitat fragmentation occurs when large habitats are divided into smaller, disconnected patches, often due to\n human development.\n\n\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 6  JanGyan — Learn Without Limits"
    },
    {
      "id": 21,
      "question": "According to the India State of Forest Report 2023, what is India's total forest and tree cover as a\n share of geographical area?",
      "options": [
        "15.17%",
        "20.17%",
        "25.17%",
        "33.17%"
      ],
      "answer": 2,
      "explanation": "The ISFR 2023 recorded India's combined forest and tree cover at 25.17% of the country's total geographical area."
    },
    {
      "id": 22,
      "question": "What is India's National Forest Policy target for forest cover?",
      "options": [
        "20% of geographical area",
        "25% of geographical area",
        "33% of geographical area",
        "50% of geographical area"
      ],
      "answer": 2,
      "explanation": "The National Forest Policy sets a target of 33% forest cover, a goal India has not yet fully achieved."
    },
    {
      "id": 23,
      "question": "Which of the following is NOT one of India's four biodiversity hotspots?",
      "options": [
        "Western Ghats",
        "Himalayas",
        "Indo-Burma region",
        "Amazon Basin"
      ],
      "answer": 3,
      "explanation": "The Amazon Basin is located in South America, not India; India's hotspots are the Himalayas, Western Ghats,\n Indo-Burma, and Sundaland."
    },
    {
      "id": 24,
      "question": "A citizen wants to reduce their environmental impact most effectively as a first step. What should\n they prioritise?",
      "options": [
        "Recycling everything they buy",
        "Reducing overall consumption before reusing or recycling",
        "Buying more eco-labelled products",
        "Ignoring packaging waste"
      ],
      "answer": 1,
      "explanation": "The waste hierarchy prioritises reducing consumption first, since preventing waste is more effective than managing\n it after the fact.\n\n\n\n\n\n\n\n\nJanGyan | MCQ Handbook — Environment & Civic Responsibility Page 7  JanGyan — Learn Without Limits"
    },
    {
      "id": 25,
      "question": "Which of the following ecosystem services is provided by forests?",
      "options": [
        "Manufacturing electronics",
        "Water cycle regulation",
        "Currency production",
        "Internet connectivity"
      ],
      "answer": 1,
      "explanation": "Forests play a critical role in regulating the water cycle, including rainfall patterns and groundwater recharge."
    }
  ]
};
