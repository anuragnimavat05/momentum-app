# Momentum - Your Personal Growth Operating System

<p align="center">
  <img src="assets/icons/app_icon.png" alt="Momentum Logo" width="120"/>
</p>

Momentum is a futuristic, emotionally intelligent productivity app designed to help users overcome procrastination, build consistent habits, and maintain daily momentum toward their goals.

## ✨ Features

### 🤖 AI Coach
- Intelligent motivation based on user context
- Breaks overwhelming tasks into tiny actions
- Detects procrastination patterns
- Provides emotional support during setbacks

### 🎯 Smart Momentum System
- Dynamic momentum score (0-100)
- Streak tracking with protection
- XP and leveling system
- Achievement badges

### ⏱️ Focus Mode
- Pomodoro timer with customizable durations
- Ambient sounds (Rain, Forest, Lo-Fi)
- Breathing animations
- Session tracking

### 📊 Advanced Analytics
- Momentum trends
- Focus time graphs
- Consistency heatmaps
- Weekly insights

### ✅ Habit Tracking
- Daily habits with streaks
- Completion history
- Category organization
- Smart reminders

### 📱 Additional Features
- Goals with "WHY" journaling
- Task management with tiny action suggestions
- Future Me messages
- Smart notifications

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Backend**: Firebase
  - Authentication
  - Firestore Database
  - Cloud Messaging
  - Cloud Storage
- **State Management**: Provider
- **Charts**: fl_chart
- **Animations**: flutter_animate

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants, quotes
│   ├── services/        # Firebase, AI, Notifications
│   ├── theme/           # App theme and colors
│   └── widgets/         # Reusable UI components
├── data/
│   └── models/          # Data models
└── presentation/
    ├── providers/        # State management
    └── screens/          # UI screens
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Firebase project

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/momentum.git
cd momentum
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add Android/iOS apps
   - Download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
   - Place in respective directories

4. (Optional) Add OpenAI API key for advanced AI:
```bash
flutter run --dart-define=OPENAI_API_KEY=your_key
```

5. Run the app:
```bash
flutter run
```

## 🎨 Design System

### Colors
- **Primary**: Electric Blue (#00D4FF)
- **Secondary**: Neon Purple (#8B5CF6)
- **Accent**: Cyan (#00FFE5)
- **Background**: Deep Black (#0A0A0F)
- **Surface**: Charcoal (#16162A)

### Typography
- **Font**: Inter (Google Fonts)
- **Headings**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12px

## 🔐 Security

- Firebase Authentication with secure session management
- Firestore Security Rules
- Encrypted local storage via SharedPreferences
- No sensitive data stored in code

## 📄 License

MIT License - See LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenAI for AI capabilities
- Design inspiration from Iron Man HUD, Notion, Duolingo

---

<p align="center">
Built with ❤️ for personal growth
</p>
