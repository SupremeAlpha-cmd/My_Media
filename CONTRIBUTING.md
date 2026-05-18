# Contributing to My Media

Thank you for your interest in contributing to My Media! Whether you are fixing a bug, adding a new feature, or improving documentation, your help is incredibly valuable in making this church production toolkit better.

## 🛠️ Development Workflow

1. **Fork the Repository:** Create your own branch (`git checkout -b feature/AmazingFeature`).
2. **Web Preview Mode:** If you are working purely on UI/UX, we highly recommend testing via the web server (`flutter run -d web-server`). The app has an internal mock engine that stubs out the native camera and UDP networking so you won't experience compile crashes in the browser.
3. **Android Native Testing:** If you are touching `CommsService` (UDP sockets) or `MainActivity.kt` (AudioTrack), you **must** test on a physical Android device. Emulators do not accurately reflect audio routing or local network latency.

## 🏗️ Architecture Guidelines

- **Native MethodChannels:** If you need to add complex hardware features (like audio routing), prefer writing lightweight native Kotlin/Swift bridges rather than installing heavy C++ Dart packages (like WebRTC). This keeps the NDK build times low and the app crash-free.
- **Theming:** All colors and typography must adhere to `ProMediaTheme` (`lib/theme/pro_media_theme.dart`). Do not use ad-hoc hex colors in the UI components.
- **State Management:** Use `Provider` (`lib/providers/app_state.dart`) for global state (like IP addresses and Tally status). 

## 📝 Submitting Changes

1. Ensure your code is properly formatted (`dart format .`).
2. Run the analyzer to catch syntax issues (`dart analyze`).
3. Commit your changes with clear, descriptive messages.
4. Push to the branch and open a Pull Request.

If you have any questions, feel free to open an Issue!
