import Foundation

/// A concrete implementation of LevelProvider using a static registry.
public final class StaticLevelProvider: LevelProvider {
    private var currentIndex = 0
    
    private let levels: [AuraLevel] = [
        AuraLevel(id: "lvl_001", size: 6, regions: [
            [GridPosition(0,0), GridPosition(0,1), GridPosition(1,0), GridPosition(1,1)],
            [GridPosition(0,2), GridPosition(0,3), GridPosition(1,2), GridPosition(1,3)],
            [GridPosition(0,4), GridPosition(0,5), GridPosition(1,4), GridPosition(1,5)],
            [GridPosition(2,0), GridPosition(2,1), GridPosition(3,0), GridPosition(3,1)],
            [GridPosition(2,2), GridPosition(2,3), GridPosition(3,2), GridPosition(3,3)],
            [GridPosition(2,4), GridPosition(2,5), GridPosition(3,4), GridPosition(3,5)],
            [GridPosition(4,0), GridPosition(4,1), GridPosition(5,0), GridPosition(5,1)],
            [GridPosition(4,2), GridPosition(4,3), GridPosition(5,2), GridPosition(5,3)],
            [GridPosition(4,4), GridPosition(4,5), GridPosition(5,4), GridPosition(5,5)]
        ], starsPerConstraint: 2)
    ]
    
    public init() {}
    
    public func getLevel(id: String) async throws -> LevelProtocol {
        guard let level = levels.first(where: { $0.id == id }) else {
            throw NSError(domain: "AuraLogic", code: 404, userInfo: [NSLocalizedDescriptionKey: "Level not found"])
        }
        return level
    }
    
    public func getNextLevel() async throws -> LevelProtocol {
        let level = levels[currentIndex % levels.count]
        currentIndex += 1
        return level
    }
}

/// A provider that generates levels on-the-fly.
public final class ProceduralLevelProvider: LevelProvider {
    private let generator: LevelGenerator
    
    public init(size: Int, stars: Int = 2) {
        self.generator = LevelGenerator(size: size, starsPerConstraint: stars)
    }
    
    public func getLevel(id: String) async throws -> LevelProtocol {
        // For procedural, we just generate a new one regardless of ID for now
        return generator.generateValidated()
    }
    
    public func getNextLevel() async throws -> LevelProtocol {
        return generator.generateValidated()
    }
}
