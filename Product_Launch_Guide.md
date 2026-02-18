# iOS Game Studio: Product Launch Guide
## Prepared for: David
## Role: Senior Product Manager (AI-Subagent)
## Date: 2026-02-18

---

### 1. Developer Readiness Checklist
To transition from a hobbyist to a professional iOS game studio, the following infrastructure must be established. Tamzy (your AI assistant) can write code and manage logic, but these physical and legal assets require your direct action.

#### **A. Apple Developer Program**
*   **Account Type:** Individual (if solo) or Organization (if you have a registered legal entity).
*   **Cost:** $99 USD per year.
*   **Requirements:** 
    *   A valid Apple ID with Two-Factor Authentication enabled.
    *   A D-U-N-S Number (only required for Organization accounts).
*   **Purpose:** Required to distribute games via the App Store, use TestFlight, and access advanced APIs (Game Center, In-App Purchases).

#### **B. Hardware Requirements**
*   **The Mac:** You must have a machine running macOS (MacBook Pro, Air, or Mac Mini). 
    *   *Minimum:* Apple Silicon (M1/M2/M3 chip) with 16GB RAM for efficient compiling.
*   **Xcode:** The IDE (Integrated Development Environment) provided by Apple. It is free but requires ~40GB of disk space.
*   **Test Devices:** At least one physical iPhone or iPad. While the Simulator is good, puzzle games need "touch-and-feel" testing on real hardware to ensure performance and battery efficiency.

#### **C. Essential Development Tools**
Choose your engine based on the complexity of your puzzle games:
1.  **Swift + SwiftUI / SpriteKit (Native):**
    *   *Pros:* Best battery life, smallest file size, 100% Apple-native feel.
    *   *Best for:* 2D grid-based puzzles (Sudoku, Word games).
2.  **Unity (Cross-platform):**
    *   *Pros:* Largest asset store, easy to port to Android later.
    *   *Best for:* Physics-based puzzles, 3D puzzles.
3.  **Godot (Open Source):**
    *   *Pros:* Lightweight, no licensing fees, great for 2D.
    *   *Best for:* Indie developers who want a balance of power and simplicity.

#### **D. Account & Integration Setup**
*   **App Store Connect:** Where you manage your app’s metadata, screenshots, pricing, and submission.
*   **TestFlight:** Apple’s beta testing platform. Essential for sending builds to friends/testers before the public release.
*   **GitHub / GitLab:** Private repository hosting. Tamzy needs this to push/pull code. Ensure you set up a "Personal Access Token" for secure AI integration.

---

### 2. Product Development Lifecycle (MVP to App Store)

This roadmap outlines the professional journey of a single puzzle game from concept to the hands of users.

#### **Phase 1: Discovery & MVP Definition**
*   **Core Mechanic:** Define the "one thing" that makes the puzzle fun (e.g., "sliding blocks to clear a path").
*   **Prototype:** Build a "Grey-box" version—no art, just the logic. Does it work? Is it fun?
*   **Technical Spec:** Define the data structure for levels (JSON or Plist).

#### **Phase 2: Development & Infrastructure**
*   **Sprint 1:** Core game logic + UI layout.
*   **Sprint 2:** Level loading system + Save State (User Defaults/CloudKit).
*   **Sprint 3:** Visual Polish (Animations, Haptics, Sound FX).
*   **Integrate Game Center:** Implement Leaderboards or Achievements to increase retention.

#### **Phase 3: Quality Assurance (The "TestFlight" Phase)**
*   **Internal Testing:** Deploy to your own device via Xcode.
*   **External Testing:** Invite 5-10 "External Testers" via TestFlight to find edge-case bugs and UI friction.

#### **Phase 4: Store Presence & Metadata**
*   **Creative Assets:** 
    *   App Icon (1024x1024).
    *   Screenshots for all iPhone sizes (6.5" and 5.5").
    *   App Store Video Preview (highly recommended for puzzle games).
*   **Legal:** Privacy Policy URL (required for App Store submission).

#### **Phase 5: Submission & Review**
*   **Archive & Upload:** Build the release version in Xcode and upload to App Store Connect.
*   **App Review:** Apple's team will manually test your game (usually takes 24-48 hours).
*   **Launch:** Once "Ready for Sale," hit the button to go live globally.

---

### 3. Immediate Next Steps for David
1.  **Register:** Sign up for the [Apple Developer Program](https://developer.apple.com/programs/).
2.  **Hardware Check:** Ensure you have an Apple Silicon Mac with the latest version of Xcode installed.
3.  **GitHub Repository:** Create a new private repo for your first project and provide the link to Tamzy.
