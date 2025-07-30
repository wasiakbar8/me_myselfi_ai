
# MeMyselfI.ai 🧠

**MeMyselfI.ai** is a modular, AI-powered productivity and self-management platform. It leverages a **Python-based microservices backend** deployed on **AWS Cloud Services**, paired with a **Flutter/Dart** mobile frontend. This architecture enables scalable, intelligent features like voice control, smart scheduling, unified communication, and secure document storage.

---

## 📚 Table of Contents

- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Screenshots](#screenshots)
- [Microservices](#microservices)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)

---

## 🚀 Features

- Voice-based journaling and task execution
- Smart calendar with AI-assisted scheduling
- Unified inbox (WhatsApp, Email, SMS)
- AI-powered phone call handler and assistant
- Secure document vault with biometric + OTP verification
- Budget tracking (weekly/monthly)
- Notifications and alerts
- Personal vs. business profile switching
- Mobile UI built with Flutter

---

## 🧩 Architecture Overview

MeMyselfI.ai follows a **microservices architecture**, where each service is implemented using **Python** and deployed independently via **AWS** (using Lambda, API Gateway, DynamoDB, etc.). The frontend is built in **Flutter** for a responsive and native mobile experience.

---

## 📸 Screenshots

![App Screenshot](https://github.com/AbdullahRafiq463/me_myselfi_ai/blob/main/IMG-20250728-WA0017.jpg)

---

## 🔧 Microservices

Each of the following services is written in **Python** and deployed to **AWS**:

1. **Diary Service**
   - Manage daily journal entries (voice/text)
   - AWS: Lambda, DynamoDB, Whisper API

2. **Calendar Service**
   - Smart scheduling and reminders
   - AWS: Lambda, DynamoDB

3. **Inbox Service**
   - Unified inbox with AI replies
   - AWS: Lambda, GPT-4, External APIs

4. **Voice Assistant**
   - Capture and interpret user voice commands
   - AWS: Lambda, Whisper API, GPT-4

5. **AI Call Agent**
   - Answer and schedule via voice calls
   - AWS: Lambda, Twilio, DynamoDB

6. **Vault Service**
   - Secure document upload, fetch, and OTP/PIN verification
   - AWS: S3, Lambda, DynamoDB

7. **Budgeting Service**
   - Budget creation, listing, and update
   - AWS: Lambda, DynamoDB

8. **Notification Service**
   - Push alerts for events and reminders
   - AWS: SNS, Lambda

9. **API Integration Service**
   - Manage and refresh external API tokens
   - AWS: Secrets Manager, Lambda

10. **Business Profile Service**
    - Toggle between personal and business dashboards
    - AWS: Lambda, DynamoDB

---

## 🧠 Tech Stack

| Component      | Technology                             |
|----------------|-----------------------------------------|
| Frontend       | Flutter, Dart                           |
| Backend        | Python (Microservices)                  |
| Cloud Services | AWS Lambda, API Gateway, DynamoDB, S3, SNS, Secrets Manager |
| AI/ML          | OpenAI GPT-4, Whisper API               |
| Telephony      | Twilio                                  |

---

## 📦 Setup Instructions

> **Pre-requisites:** Python 3.8+, Flutter SDK, AWS CLI, OpenAI API key, Twilio account

1. **Clone the Repository:**
```bash
git clone https://github.com/yourusername/memyselfi.ai.git
cd memyselfi.ai
```

2. **Install Python dependencies:**
```bash
pip install -r requirements.txt
```

3. **Configure Environment:**
Create a `.env` file:
```
OPENAI_API_KEY=your_key
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
```

4. **Deploy microservices to AWS (example using Zappa, Serverless, or CDK):**
```bash
cd services/diary
zappa deploy dev
```

5. **Run Flutter frontend:**
```bash
cd frontend_flutter
flutter run
```

---

## 🗂 Folder Structure

```
memyselfi.ai/
├── services/
│   ├── diary/
│   ├── calendar/
│   ├── inbox/
│   ├── voice_assistant/
│   ├── ai_call_agent/
│   ├── vault/
│   ├── budgeting/
│   ├── notifications/
│   ├── api_integrations/
│   └── profile/
├── frontend_flutter/
│   ├── lib/
│   ├── assets/
├── shared/
│   ├── utils/
│   └── auth/
├── requirements.txt
└── .env
```

---

## 📢 Optimization Notes

- Use AWS Lambda for cost-efficient scalability
- Cache frequently used data with AWS ElastiCache (optional)
- Queue intensive tasks using SQS (if needed)
- Secure secrets via AWS Secrets Manager

---

## 🤝 Contributing

1. Fork this repo
2. Create a new branch:
```bash
git checkout -b feature/your-feature
```
3. Commit and push:
```bash
git commit -m "Added a new feature"
git push origin feature/your-feature
```
4. Submit a Pull Request

---

## 📄 License

Licensed under the MIT License. See `LICENSE` for details.

---

> Built with ❤️ using Python, AWS, and Flutter
