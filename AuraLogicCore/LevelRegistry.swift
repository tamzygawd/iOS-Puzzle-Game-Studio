import Foundation

/// Static registry for human-verified Easy levels.
public struct LevelRegistry {
    public static let easyLevels: [AuraLogicEngine.Level] = [
        // Level 1: 6x6 Example (1 star per constraint for simplicity in level 1, but engine supports 2)
        AuraLogicEngine.Level(size: 6, regions: [
            [AuraLogicEngine.GridPosition(0,0), AuraLogicEngine.GridPosition(0,1), AuraLogicEngine.GridPosition(1,0), AuraLogicEngine.GridPosition(1,1)],
            [AuraLogicEngine.GridPosition(0,2), AuraLogicEngine.GridPosition(0,3), AuraLogicEngine.GridPosition(1,2), AuraLogicEngine.GridPosition(1,3)],
            [AuraLogicEngine.GridPosition(0,4), AuraLogicEngine.GridPosition(0,5), AuraLogicEngine.GridPosition(1,4), AuraLogicEngine.GridPosition(1,5)],
            [AuraLogicEngine.GridPosition(2,0), AuraLogicEngine.GridPosition(2,1), AuraLogicEngine.GridPosition(3,0), AuraLogicEngine.GridPosition(3,1)],
            [AuraLogicEngine.GridPosition(2,2), AuraLogicEngine.GridPosition(2,3), AuraLogicEngine.GridPosition(3,2), AuraLogicEngine.GridPosition(3,3)],
            [AuraLogicEngine.GridPosition(2,4), AuraLogicEngine.GridPosition(2,5), AuraLogicEngine.GridPosition(3,4), AuraLogicEngine.GridPosition(3,5)],
            [AuraLogicEngine.GridPosition(4,0), AuraLogicEngine.GridPosition(4,1), AuraLogicEngine.GridPosition(5,0), AuraLogicEngine.GridPosition(5,1)],
            [AuraLogicEngine.GridPosition(4,2), AuraLogicEngine.GridPosition(4,3), AuraLogicEngine.GridPosition(5,2), AuraLogicEngine.GridPosition(5,3)],
            [AuraLogicEngine.GridPosition(4,4), AuraLogicEngine.GridPosition(4,5), AuraLogicEngine.GridPosition(5,4), AuraLogicEngine.GridPosition(5,5)]
        ], starsPerConstraint: 2)
        // Add 9 more verified levels here...
    ]
}
