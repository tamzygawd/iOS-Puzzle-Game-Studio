import SwiftUI

/// ThemeEngine: The visual soul of Aura Logic.
/// Focused on high-contrast legibility, 'Offline-First' performance, and minimalist aesthetics.
public enum ThemeEngine {
    
    // MARK: - Palette
    public enum Palette {
        // Deep background for focus
        static let background = Color(white: 0.05)
        // Primary interactive element (Stars/Aura)
        static let accent = Color(red: 0.4, green: 0.7, blue: 1.0) // Soothing Cyan
        // Secondary/Grid lines
        static let grid = Color(white: 0.2)
        // Tertiary/Marked cells (Negative space)
        static let secondary = Color(white: 0.4)
        // Success state
        static let success = Color(red: 0.2, green: 0.8, blue: 0.5)
        // Text/UI
        static let primaryText = Color.white
        static let secondaryText = Color.gray
    }
    
    // MARK: - Typography
    public enum Typography {
        /// Uses System-Native San Francisco for zero-latency, offline-first rendering.
        static func title() -> Font {
            .system(size: 28, weight: .bold, design: .rounded)
        }
        
        static func body() -> Font {
            .system(size: 18, weight: .medium, design: .monospaced)
        }
        
        static func gridNumber() -> Font {
            .system(size: 14, weight: .bold, design: .monospaced)
        }
    }
    
    // MARK: - Layout Constants
    public enum Layout {
        static let cornerRadius: CGFloat = 8
        static let gridSpacing: CGFloat = 2
        static let thumbZoneBottomPadding: CGFloat = 40
    }
}
