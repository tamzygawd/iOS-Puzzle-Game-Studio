# App Store Connect Setup Guide: Aura Logic Full Unlock

To correctly set up the 'Full Unlock' In-App Purchase (IAP) for Aura Logic, follow these steps in App Store Connect.

## 1. Prerequisites
- **Admin or App Manager Access:** Ensure you have the permissions to create In-App Purchases.
- **Tax and Banking Agreements:** All active agreements (Paid Apps) must be signed and "Active" in the Agreements, Tax, and Banking section.

## 2. Creating the IAP Item

1.  **Select Your App:** Go to [App Store Connect](https://appstoreconnect.apple.com/), select 'My Apps', and then 'Aura Logic'.
2.  **In-App Purchases Section:** In the left sidebar, under 'Features', select **In-App Purchases**.
3.  **Create New:** Click the **+** (plus) button.
4.  **Select Type:** Choose **Non-Consumable**.
    *   *Reason:* This is a one-time purchase that does not expire and must be restorable.
5.  **Reference Name:** Enter `Full Unlock`. (This is for your internal reference only).
6.  **Product ID:** Enter `com.logicandchill.auralogic.fullunlock`.
    *   *Note:* This must exactly match the ID used in `StoreManager.swift`.

## 3. Product Details Configuration

### Availability
- Ensure **Cleared for Sale** is checked.
- Select all relevant countries/regions (Global availability is recommended).

### Pricing
- **Price Tier:** Select your target price (e.g., Tier 3 - $2.99 USD or Tier 5 - $4.99 USD).
- **Pricing Schedule:** Ensure it is set to "Starting Now" with no end date.

### App Store Localization (Display Info)
This is what users see on the App Store and in the purchase dialog.

- **English (U.S.) - Display Name:** `Full Unlock: All Levels & Future Content`
- **English (U.S.) - Description:** `Unlock 500+ puzzles across all difficulties, plus every future level pack we ever release. Experience the ultimate Zen challenge with a one-time lifetime purchase.`

## 4. Review Information (Mandatory)

Apple requires this information before they will approve the IAP.

- **Screenshot:** Upload a screenshot of the app's paywall (the `ZenPaywallView` from our design). 
    - *Requirement:* Must be 640 x 920 pixels or larger.
- **Review Note:** "This is a non-consumable purchase that unlocks all levels in the game (Easy through Insane). It also provides access to any future level packs added to the app. The first 20 levels (10 Easy, 10 Medium) are free to play."

## 5. Metadata for Submission

Once configured, the IAP status will be **'Ready to Submit'**. You must include this IAP item with your next app version submission for Apple to review and approve it simultaneously with the code changes.

### Checklist for David:
- [ ] Product ID matches code.
- [ ] Pricing set.
- [ ] Localization (Name & Description) entered.
- [ ] Paywall screenshot uploaded.
- [ ] IAP item added to the "In-App Purchases" section of the App Version page before clicking "Submit for Review".
