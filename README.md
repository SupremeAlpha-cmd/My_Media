# My Media (Pro-Media Toolkit)

**My Media** is a zero-latency broadcast camera and intercom application designed specifically for live church production environments. Built with Flutter, it transforms standard Android devices into professional network cameras and walkie-talkies.

## 🚀 Features

- **Studio Link (Live Streaming):** Broadcasts a zero-latency RTMP feed directly to OBS Studio or vMix over local Wi-Fi.
- **Tally Light Integration:** Receives live tally states (Preview/Live) from the switcher so camera operators know exactly when they are on air.
- **Local Intercom (Comms):** A built-in, low-latency UDP push-to-talk radio system. Talk directly to the Director with zero delay, featuring automatic Bluetooth routing for earpieces.
- **Media Gallery:** Simultaneously record 4K raw backup footage locally to the device while broadcasting the compressed stream over the network.
- **Volunteer Onboarding:** Includes a built-in guide and onboarding carousel to bring new camera operators up to speed in seconds without technical supervision.

## 🛠️ Architecture Highlights

- **No Heavy C++ Bloat:** Avoids massive WebRTC packages in favor of ultra-lightweight UDP streams (`RawDatagramSocket`) to ensure absolute stability on spotty Wi-Fi.
- **Native Android Playback:** Utilizes a custom native Kotlin bridge directly to Android's `AudioTrack` for instant audio playback, bypassing Flutter's standard audio engine latency.
- **State Management:** Uses `provider` to actively track network state, connection latency, and UI rendering.

## 📦 Getting Started

### Prerequisites
- Flutter SDK (v3.11.5+)
- Android SDK (v36, NDK required for native compilation)

### Running Locally
To test the UI without hardware constraints, the app features a built-in mock engine for Web deployment:
```bash
flutter run -d web-server
```

To build for production (Android):
```bash
flutter build apk --release
```

## 🌐 Network Setup
1. Connect the mobile device and the Studio PC (vMix/OBS) to the **same Local Area Network**.
2. In the app Settings, enter the Studio PC's IPv4 address.
3. Tap "Live Channel" to begin intercom routing, or tap the Camera screen to push the RTMP stream.

## 🤝 Contributing
Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for details on how to set up the dev environment and submit pull requests.
