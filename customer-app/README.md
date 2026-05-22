# 📱 Workla Customer Mobile Application (Flutter)

Welcome to the **Workla Customer Mobile Application**, migrated to a robust, premium-grade **Flutter (Dart)** application. This repository houses the complete cross-platform mobile frontend that interfaces with the Workla Fastify REST backend, real-time socket trackers, and Supabase infrastructure.

---

## 🌟 Key Features

*   **🔒 Secure Authentication**: Integrated with Supabase Auth (PKCE flow) and features auto-refreshing JWT session states.
*   **📡 Resilient REST Client**: Handled in Dart via clean interceptor wrappers that inject authorization headers, enforce 15-second limits, and utilize fallback options if backend containers cold-start.
*   **🔌 Background-Aware Socket.IO**: Auto-disconnects sockets when the app is minimized/paused and seamlessly re-connects on foreground resume, ensuring optimal performance and avoiding OS-level lifecycle termination.
*   **📍 Geolocated Address Detection**: Integrates Geolocator and Geocoding to identify coordinates and auto-switch to closest saved addresses matching a 150-meter proximity threshold.
*   **🗺️ Live Maps Explorer**: Renders nearby service professionals on Google Maps with custom markers and a swipeable bottom details sheet.
*   **⚙️ Multi-Step Wizard Booking**: An interactive checkout wizard walking customers through category selections, address locks, slot timings, and summary calculations.
*   **🚗 Real-Time Tracking**: Features real-time Socket.IO subscriptions that stream provider locations and update marker positions on the map as they arrive.
*   **🪙 Premium Profile & Perks**: Interactive wallet dashboards, shareable referral sheets, and tier-based premium Workla Gold upgrades.

---

## 📂 Codebase Directory Layout

The codebase has been refactored under a clean-architecture pattern inside the `lib/` directory:

```
customer-app/
├── lib/
│   ├── main.dart              # Main application entry point & GoRouter path definitions
│   ├── core/                  # Visual styling systems, API, socket, and storage hooks
│   │   ├── api.dart           # Resilient REST Client (http wrapper)
│   │   ├── socket.dart        # Background-aware Socket.IO lifecycle listener
│   │   ├── supabase.dart      # Supabase initialization & stream listeners
│   │   ├── theme.dart         # Outfit/Inter typography, borders, and category color constants
│   │   └── storage.dart       # SharedPreferences caching manager
│   ├── models/                # Typed Dart models for JSON serialization
│   │   ├── address.dart
│   │   ├── booking.dart
│   │   ├── service.dart
│   │   └── user.dart
│   ├── state/                 # State management using Riverpod notifiers
│   │   ├── address_provider.dart
│   │   ├── booking_provider.dart
│   │   └── auth_provider.dart
│   ├── screens/               # Complete navigation interfaces (12+ primary routes)
│   │   ├── onboarding_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── tab_container.dart
│   │   ├── home_tab.dart
│   │   ├── explore_tab.dart
│   │   ├── search_tab.dart
│   │   ├── bookings_tab.dart
│   │   ├── profile_tab.dart
│   │   ├── chat_screen.dart
│   │   ├── booking_workflow_screen.dart
│   │   ├── tracking_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── addresses_screen.dart
│   │   ├── wallet_screen.dart
│   │   ├── referral_screen.dart
│   │   ├── workla_gold_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/               # Reusable UI widgets
│       ├── common/            # Empty state panels, loaders, and toast feedbacks
│       ├── home/              # Carousels, dynamic grids, and headers
│       └── bookings/          # Cancellation forms, reschedule modals, and cards
├── pubspec.yaml               # Flutter package definition and assets mapping
└── README.md                  # Developer instructions and guide
```

---

## 🚀 Local Execution & Setup Guide

### 📋 Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.2.0`) installed on your system.
*   Either an Android Emulator, iOS Simulator, or a physical device connected to your workstation.

### 1. Retrieve Packages
Execute this command in the `customer-app` directory to acquire all libraries:
```bash
flutter pub get
```

### 2. Configure Environment Parameters
Rather than committing secrets to files, pass your backend addresses and Supabase credentials securely using `--dart-define` parameters during execution:

```bash
flutter run \
  --dart-define=API_URL=http://localhost:8000 \
  --dart-define=SUPABASE_URL=https://your-supabase-url.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key
```

### 3. Verify Code Quality
Ensure the codebase complies with structural standards:
```bash
# Code layout formatting
flutter format lib/

# Static code analysis
flutter analyze
```

---

## 🔒 Security Recommendations

*   **Google Maps Integration**: Set up restrictions on your API keys inside the Google Cloud Console to only allow calls originating from your app's bundle identifier (`com.workla.customer`).
*   **Transport Layer Security (TLS)**: Ensure production endpoints always use `https` and `wss` schemes.
*   **Environment Safety**: Do not commit keys directly into the `pubspec.yaml` or Dart files. Keep secret setups confined to compiled arguments or encrypted native keys.
