import SwiftUI
import CoreHaptics

/// HapticManager: The tactile engine of Aura Logic.
/// Provides 'Zen' feedback loops to enhance satisfaction and perceived responsiveness.
public class HapticManager {
    public static let shared = HapticManager()
    
    private var engine: CHHapticEngine?
    
    private init() {
        prepareHaptics()
    }
    
    /// Pre-warms the engine for zero-latency feedback.
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            // Re-start if engine stops
            engine?.stoppedHandler = { reason in
                print("Haptic Engine Stopped: \(reason)")
                try? self.engine?.start()
            }
            
            engine?.resetHandler = {
                print("Haptic Engine Reset")
                try? self.engine?.start()
            }
        } catch {
            print("Failed to start haptics engine: \(error)")
        }
    }
    
    // MARK: - Tactical Feedback Events
    
    /// Triggered when placing a star. Sharp, precise, satisfying.
    public func triggerStarPlaced() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Triggered when marking a cell as empty. Lighter, subtle 'click'.
    public func triggerCellMarked() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Triggered when a rule is violated (e.g. two stars touching). Heavy warning.
    public func triggerViolation() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    /// The 'Zen' reward. A complex sequence for puzzle completion.
    public func triggerWinHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        // Custom transient pattern for 'Aura' expansion
        guard let engine = engine else { return }
        
        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play win haptic: \(error)")
        }
    }
}
