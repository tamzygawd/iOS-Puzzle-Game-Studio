import Foundation

/// A LevelProvider that loads levels from a JSON file in the app bundle.
public final class BundleLevelProvider: LevelProvider {
    private var levels: [AuraLevel] = []
    private var currentIndex = 0
    
    public init(fileName: String = "levels_v1") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not find \(fileName).json in bundle.")
            return
        }
        
        do {
            // Mapping the JSON structure to AuraLevel
            let decoder = JSONDecoder()
            let rawData = try decoder.decode([String: [RawLevel]].self, from: data)
            
            if let easyLevels = rawData["easy"] {
                self.levels = easyLevels.map { raw in
                    AuraLevel(
                        id: raw.id,
                        size: raw.size,
                        regions: raw.regions.map { region in
                            region.map { GridPosition($0.r, $0.c) }
                        },
                        starsPerConstraint: raw.stars
                    )
                }
            }
        } catch {
            print("Error decoding levels: \(error)")
        }
    }
    
    public func getLevel(id: String) async throws -> LevelProtocol {
        guard let level = levels.first(where: { $0.id == id }) else {
            throw NSError(domain: "AuraLogic", code: 404, userInfo: [NSLocalizedDescriptionKey: "Level not found"])
        }
        return level
    }
    
    public func getNextLevel() async throws -> LevelProtocol {
        guard !levels.isEmpty else {
            throw NSError(domain: "AuraLogic", code: 500, userInfo: [NSLocalizedDescriptionKey: "No levels loaded"])
        }
        let level = levels[currentIndex % levels.count]
        currentIndex += 1
        return level
    }
    
    // Helper structures for decoding
    private struct RawLevel: Codable {
        let id: String
        let size: Int
        let stars: Int
        let regions: [[RawCoord]]
    }
    
    private struct RawCoord: Codable {
        let r: Int
        let c: Int
    }
}
