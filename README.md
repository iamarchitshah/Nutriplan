# NutriPlan AI

NutriPlan AI is a modern, production-quality Flutter mobile application designed to help students and working professionals plan meals, track calorie intake, monitor nutrition goals, and analyze eating habits. It features an offline-first architecture utilizing Hive.

## Features

*   **Meal Planning:** Plan your breakfast, lunch, dinner, and snacks by dates.
*   **Food Entry:** Easily add custom foods with their macronutrient details.
*   **Daily Tracking:** Monitor your daily calorie intake and track your goal progress.
*   **Analytics Dashboard:** Visualize your macro breakdowns and get daily insights.
*   **Search & Filter:** Find past meals quickly with search functionality.
*   **Offline-First:** All data is securely stored locally using Hive for blazing-fast access and offline usage.
*   **Modern UI:** Built with Material 3, smooth animations, and a beautiful green and orange color scheme.

## Tech Stack

*   **Framework:** Flutter
*   **State Management:** Riverpod (`flutter_riverpod`)
*   **Routing:** GoRouter (`go_router`)
*   **Local Storage:** Hive (`hive_flutter`)
*   **Charts:** fl_chart
*   **Typography:** Google Fonts (Poppins)

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/nutriplan_ai.git
    cd nutriplan_ai
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Hive adapters:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## Architecture

The project follows a clean, modular architecture:
- `lib/core`: App-wide configuration, theming, and routing.
- `lib/data`: Local storage implementation and data models.
- `lib/providers`: Riverpod state notifiers.
- `lib/screens`: UI grouped by feature modules.
