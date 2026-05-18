# Project Brief: My Media - Church Production Toolbox

## 1. Product Vision
**My Media** is a specialized production utility designed for church media and I.T. departments. It evolves the "smartphone as a webcam" concept (e.g., Iriun) into a purpose-built professional tool that integrates camera feeds, local communication, and instant media capture into a single, cohesive ecosystem.

## 2. Problem Statement
Church media teams often face several friction points:
*   **Blind Broadcasts:** Mobile camera operators don't always know when their feed is live on the main screens or stream.
*   **Lost Moments:** Capturing high-quality stills or clips during a live feed often interrupts the stream or requires a second device.
*   **Fragmented Comms:** Production teams rely on external, often consumer-grade, walkie-talkie apps that aren't integrated with their video tools.

## 3. Core Features & Screen Map

### 1. Splash Screen
*   **Purpose:** Branded entry point and system initialization.
*   **Requirements:** Professional "Pro-Tool" aesthetic, versioning info, and connection readiness check.

### 2. Toolbox Hub (Dashboard)
*   **Purpose:** Central navigation and system status overview.
*   **Requirements:** 
    *   One-tap access to Camera, Comms, and Gallery.
    *   System-wide hardware/network status indicator.
    *   Overview cards for active tools (e.g., current Comms channel).

### 3. Pro Camera Tool (Iriun Evolution)
*   **Purpose:** High-fidelity video feed for broadcast software (vMix/OBS).
*   **Key Capabilities:**
    *   **Live Tally Indicator:** A prominent "ON AIR" status bar triggered by external broadcast software.
    *   **Moment Capture:** Dedicated "Snapshot" and "Record" buttons for local saving without interrupting the stream.
    *   **Connection Status:** Real-time IP and connection status to vMix.
    *   **Live Controls:** Zoom, Bitrate, and FPS monitoring.

### 4. Local Comms (Intercom)
*   **Purpose:** Low-latency, room-based audio communication for the production crew.
*   **Key Capabilities:**
    *   **Push-to-Talk (PTT):** Large, tactile interface for instant voice relay.
    *   **Room Management:** Automatic local network room discovery (Host/Member architecture).
    *   **Member List:** Real-time visibility of who is active or listening.

### 5. Media Gallery
*   **Purpose:** Central repository for all locally captured content.
*   **Requirements:**
    *   Categorization by Photos and Videos.
    *   Detailed metadata for service recap and social media exports.

## 4. Visual Identity & Design System
*   **Theme:** "Pro-Media Utility System"
*   **Color Palette:** Dark Mode (Surface: #111317) with high-visibility accent colors (Primary: #ff3b30) for tally lights and critical status.
*   **Typography:** Inter (Sans-serif) for maximum legibility in high-pressure environments.
*   **Component Logic:** Large touch targets, high-contrast indicators, and a utility-first layout.

## 5. Technical Constraints
*   **Connectivity:** Operates over local Wi-Fi/Ethernet for zero-latency video/audio.
*   **Compatibility:** Designed for integration with vMix and similar broadcast ecosystems via standard protocols.
*   **Hardware:** Optimized for mobile sensors (camera/mic) with background processing for media encoding.
