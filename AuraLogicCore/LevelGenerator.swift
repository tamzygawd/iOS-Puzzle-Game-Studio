import Foundation

/// Handles generation of Star Battle regions and validates solvability.
public final class LevelGenerator {
    private let size: Int
    private let starsPerConstraint: Int
    
    public init(size: Int, starsPerConstraint: Int = 2) {
        self.size = size
        self.starsPerConstraint = starsPerConstraint
    }
    
    /// Generates a level that is guaranteed to have at least one solution.
    public func generateValidated() -> AuraLevel {
        while true {
            let regions = generateRegions()
            let level = AuraLevel(size: size, regions: regions, starsPerConstraint: starsPerConstraint)
            
            let solver = StarBattleSolver(level: level)
            if solver.solve() != nil {
                return level
            }
        }
    }
    
    private func generateRegions() -> [[GridPosition]] {
        var grid = Array(repeating: Array(repeating: -1, count: size), count: size)
        var regions = Array(repeating: [GridPosition](), count: size)
        
        // Seed regions
        var seeds = [GridPosition]()
        while seeds.count < size {
            let r = Int.random(in: 0..<size)
            let c = Int.random(in: 0..<size)
            let pos = GridPosition(r, c)
            if !seeds.contains(pos) {
                seeds.append(pos)
                grid[r][c] = seeds.count - 1
                regions[seeds.count - 1].append(pos)
            }
        }
        
        // Flood fill to complete grid
        var unassigned = [GridPosition]()
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == -1 { unassigned.append(GridPosition(r, c)) }
            }
        }
        
        while !unassigned.isEmpty {
            unassigned.shuffle()
            for (index, pos) in unassigned.enumerated() {
                let neighbors = [
                    (pos.row - 1, pos.col), (pos.row + 1, pos.col),
                    (pos.row, pos.col - 1), (pos.row, pos.col + 1)
                ]
                
                let validNeighborRegions = neighbors.compactMap { (r, c) -> Int? in
                    guard r >= 0, r < size, c >= 0, c < size, grid[r][c] != -1 else { return nil }
                    return grid[r][c]
                }
                
                if let chosenRegion = validNeighborRegions.randomElement() {
                    grid[pos.row][pos.col] = chosenRegion
                    regions[chosenRegion].append(pos)
                    unassigned.remove(at: index)
                    break
                }
            }
        }
        
        return regions
    }
}
