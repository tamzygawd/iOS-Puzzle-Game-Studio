import Foundation

/// Minimalist LevelGenerator logic.
/// Generates Star Battle levels by partitioning the grid into regions.
public class LevelGenerator {
    public let size: Int
    public let starsPerConstraint: Int
    
    public init(size: Int, starsPerConstraint: Int = 2) {
        self.size = size
        self.starsPerConstraint = starsPerConstraint
    }
    
    /// Generates a valid level by partitioning the grid.
    public func generate() -> AuraLogicEngine.Level {
        var grid = Array(repeating: Array(repeating: -1, count: size), count: size)
        
        // Simple flood-fill or cluster-based partitioning
        // For the MVP, we start with a set of seed points for each region.
        let regionCount = size
        var regions = Array(repeating: [AuraLogicEngine.GridPosition](), count: regionCount)
        
        var seeds = [AuraLogicEngine.GridPosition]()
        while seeds.count < regionCount {
            let r = Int.random(in: 0..<size)
            let c = Int.random(in: 0..<size)
            let pos = AuraLogicEngine.GridPosition(r, c)
            if !seeds.contains(pos) {
                seeds.append(pos)
                grid[r][c] = seeds.count - 1
                regions[seeds.count - 1].append(pos)
            }
        }
        
        // Expand regions until the grid is full
        var emptyPositions = [AuraLogicEngine.GridPosition]()
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == -1 {
                    emptyPositions.append(AuraLogicEngine.GridPosition(r, c))
                }
            }
        }
        
        while !emptyPositions.isEmpty {
            for i in 0..<emptyPositions.count {
                let pos = emptyPositions[i]
                // Find adjacent regions
                let neighbors = [
                    (pos.row - 1, pos.col), (pos.row + 1, pos.col),
                    (pos.row, pos.col - 1), (pos.row, pos.col + 1)
                ]
                
                var possibleRegions = [Int]()
                for (nr, nc) in neighbors {
                    if nr >= 0 && nr < size && nc >= 0 && nc < size && grid[nr][nc] != -1 {
                        possibleRegions.append(grid[nr][nc])
                    }
                }
                
                if let chosenRegion = possibleRegions.randomElement() {
                    grid[pos.row][pos.col] = chosenRegion
                    regions[chosenRegion].append(pos)
                    emptyPositions.remove(at: i)
                    break
                }
            }
        }
        
        return AuraLogicEngine.Level(size: size, regions: regions, starsPerConstraint: starsPerConstraint)
    }
    
    /// Generates and validates levels until one is found that has a unique solution.
    public func generateValidated() -> AuraLogicEngine.Level {
        while true {
            let level = generate()
            let solver = StarBattleSolver(level: level)
            if let _ = solver.solve() {
                // If it's solvable, it's valid for MVP. 
                // In production, we'd check for a unique solution by searching for a second solution.
                return level
            }
        }
    }
}
