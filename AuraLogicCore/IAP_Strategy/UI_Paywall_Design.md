# UI Paywall Design: Aura Logic 'Zen' Unlock

## 1. Aesthetic Philosophy
The paywall should feel like a natural extension of the gameplay experience, not an interruption.
- **Background:** Soft, blurred gradient (consistent with the Aura Logic core UI).
- **Typography:** Modern, light weights (SF Pro Display).
- **Icons:** Minimalist, thin-line glyphs.
- **Interaction:** Gentle haptic feedback on the purchase button.

## 2. Layout Structure (Top-Down)

### Header
- **Icon:** A delicate padlock icon that glows and transforms into an open lock as the user interacts.
- **Title:** "Elevate Your Focus"
- **Subtitle:** "Experience the full depth of Aura Logic."

### The Promise (Benefits List)
1.  **Unlock All Levels:** "Gain instant access to 500+ handcrafted puzzles."
2.  **All Difficulties:** "From Easy to Insane. No gates, no limits."
3.  **Future Challenges:** "Get every new level pack we ever release, automatically."
4.  **Lifetime Access:** "One-time purchase. Your focus, unlocked forever."

### Call to Action (CTA)
- **Primary Button:** Large, rounded rectangle with a subtle glassmorphism effect.
    - **Text:** "Unlock Lifetime Access - [Price]"
- **Secondary Actions:**
    - "Restore Purchase" (Standard Apple Requirement)
    - "Maybe Later" (Dismiss)

### Footer (Required Legal)
- **Small Print:** "This is a one-time purchase. No subscriptions. Privacy Policy | Terms of Service."

## 3. High-Conversion Messaging Strategy
The tone is not "buy this," but "invest in your mental clarity."

| Instead of... | Use... |
| :--- | :--- |
| "Buy Full Version" | "Unlock Your Potential" |
| "Remove Ads & Paywall" | "Eternal Zen Access" |
| "New Levels Coming Soon" | "All Future Challenges Included" |
| "Click to Purchase" | "Continue Your Journey" |

## 4. UI Implementation (SwiftUI Preview Snippet)

```swift
struct ZenPaywallView: View {
    @ObservedObject var storeManager: StoreManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Background: Aura Logic Soft Gradient
            Color.auraBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 60, weight: .ultraLight))
                    .foregroundColor(.accentColor)
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("Elevate Your Focus")
                        .font(.title2.bold())
                    Text("Experience the full depth of Aura Logic.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Features
                VStack(alignment: .leading, spacing: 20) {
                    FeatureRow(icon: "sparkles", text: "500+ Handcrafted Puzzles")
                    FeatureRow(icon: "infinity", text: "Lifetime Access & Updates")
                    FeatureRow(icon: "calendar", text: "All Future Level Packs Free")
                }
                .padding(.horizontal, 40)

                Spacer()

                // CTA Button
                Button(action: {
                    Task {
                        try? await storeManager.purchase()
                        dismiss()
                    }
                }) {
                    Text("Unlock Lifetime Access - \(storeManager.products.first?.displayPrice ?? "$2.99")")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Capsule().fill(Color.accentColor))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)

                Button("Restore Purchases") {
                    Task {
                        await storeManager.updateCustomerProductStatus()
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            }
        }
    }
}
```
