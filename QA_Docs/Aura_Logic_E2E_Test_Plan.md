# Aura Logic E2E Test Plan (MVP)

**Role:** Senior QA Engineer (Mobile UX & Logic Verification)
**Target:** David
**Date:** 2026-02-18

---

## 1. Logic Integrity: StarBattleSolver Validation
Ensure 100% logic accuracy for the initial 10 levels. No level should have multiple solutions or be unsolvable.

### Protocol:
1. **Tool Setup:** Navigate to the `StarBattleSolver` directory in the terminal.
2. **Level Input:** For each of the first 10 levels (1-10), extract the grid configuration (size, star count, and regions).
3. **Execution:** Run the solver:
   ```bash
   ./StarBattleSolver --level [LEVEL_ID] --verify-unique
   ```
4. **Pass Criteria:**
   - Solver must find exactly one valid solution.
   - Solution must match the internal level data.
   - Time to solve must be < 500ms (to ensure mobile device performance).

---

## 2. Offline-First Verification
Verify the app remains fully functional and visually stable without a network connection.

### Protocol:
1. **Initial Load:** Launch the app with an active connection to ensure initial cache is populated (if applicable).
2. **Airplane Mode:** Force 'Airplane Mode' (WiFi and Cellular OFF).
3. **Traversal:**
   - Open the Level Select screen.
   - Launch Levels 1 through 5.
   - Complete at least 2 levels.
4. **Pass Criteria:**
   - Zero "Asset Loading" errors.
   - No placeholder icons or "No Internet" popups.
   - Game logic (StarBattleSolver integration) works locally.

---

## 3. Sensory & Haptics QA: 'Tactile Zen' Feedback
Verify that the haptic feedback enhances the "Zen" experience without being intrusive or battery-draining.

### Checklist:
- [ ] **Interaction Tap:** A subtle, short 'Light' haptic (UISelectionFeedbackGenerator) when placing/removing a star.
- [ ] **Error Trigger:** A distinct 'Warning' haptic (UINotificationFeedbackGenerator) when a star violates a rule.
- [ ] **Victory Loop:** A rhythmic 'Success' haptic sequence that plays during the victory animation.
- [ ] **Latency:** Haptics must trigger within 10ms of the visual event (zero perceived delay).

---

## 4. Human Polish Pass: AI Smudge Audit
Visual audit to comply with Guideline 4.1, ensuring the UI looks handcrafted and professional, not "AI-generated/messy."

### Instructions:
1. **Zoom Test:** Inspect all icons (Star, X-mark, Menu) at 300% zoom.
2. **Symmetry Audit:** Ensure grid lines and star shapes have consistent stroke weights.
3. **Artifact Hunting:** Look for:
   - "Ghost" pixels or blurry edges in corners.
   - Inconsistent shading in the 'Zen' background gradients.
   - Text rendering issues (kerning or inconsistent font weights).
4. **Pass Criteria:** UI must look "crisp" and intentional. If an asset looks like it has "AI Smudge," it must be flagged for manual touch-up.

---

## 5. One-Handed Play (Thumb Zone Protocol)
Ensure the game is playable during high-speed sessions using only one hand (the 'Thumb Zone').

### Protocol:
1. **Grip:** Hold the device (iPhone 15 Pro or similar) naturally with one hand (left or right).
2. **Navigation:** Try to reach the "Menu" button and "Reset" button using only the thumb.
3. **Grid Interaction:** Tap the furthest corner of the 10x10 grid.
4. **Speed Test:** Play Level 1 as fast as possible using only the thumb.
5. **Pass Criteria:**
   - No "finger gymnastics" required for primary gameplay loop.
   - Interactive elements (stars/cells) are large enough to avoid mis-taps (min 44x44pt).
   - Bottom-weighted navigation (UI elements should be in the lower 2/3 of the screen).

---

## Final Compliance Checklist
- [ ] Logic Verified (1-10)
- [ ] Offline Ready
- [ ] Haptics Synced
- [ ] No AI Smudge
- [ ] One-Handed Validated

**Report generated for review by David.**
