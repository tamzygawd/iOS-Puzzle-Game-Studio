import Foundation

/// StarBattleSolver script to be used for level validation.
/// Deterministic solver utilizing backtracking with constraint propagation.
public class StarBattleSolver {
    let size: Int
    let starsPerConstraint: Int
    let regionMap: [Int: [AuraLogicEngine.GridPosition]] // Region index -> [Positions]
    let posToRegion: [AuraLogicEngine.GridPosition: Int]
    
    public init(level: AuraLogicEngine.Level) {
        self.size = level.size
        self.starsPerConstraint = level.starsPerConstraint
        var regionMap = [Int: [AuraLogicEngine.GridPosition]]()
        var posToRegion = [AuraLogicEngine.GridPosition: Int]()
        for (index, region) in level.regions.enumerated() {
            regionMap[index] = region
            for pos in region {
                posToRegion[pos] = index
            }
        }
        self.regionMap = regionMap
        self.posToRegion = posToRegion
    }

    /// Solves the level and returns the first solution found.
    public func solve() -> [AuraLogicEngine.GridPosition]? {
        var solution = [AuraLogicEngine.GridPosition]()
        if backtrack(row: 0, starsInRows: Array(repeating: 0, count: size),
                     starsInCols: Array(repeating: 0, count: size),
                     starsInRegions: Array(repeating: 0, count: regionMap.count),
                     allStars: &solution) {
            return solution
        }
        return nil
    }

    private func backtrack(row: Int, starsInRows: [Int], starsInCols: [Int], starsInRegions: [Int], allStars: inout [AuraLogicEngine.GridPosition]) -> Bool {
        // Goal reached: All rows have the correct number of stars.
        if row == size {
            return true
        }

        let currentStarsInRow = starsInRows[row]
        
        // If row already has enough stars, move to next row
        if currentStarsInRow == starsPerConstraint {
            return backtrack(row: row + 1, starsInRows: starsInRows, starsInCols: starsInCols, starsInRegions: starsInRegions, allStars: &allStars)
        }

        // Try placing a star in each column of the current row
        for col in 0..<size {
            let pos = AuraLogicEngine.GridPosition(row, col)
            let regionIndex = posToRegion[pos]!
            
            // Check constraints
            if canPlaceStar(at: pos, currentStars: allStars, starsInCols: starsInCols, starsInRegions: starsInRegions, regionIndex: regionIndex) {
                // Place star
                allStars.append(pos)
                var nextStarsInRows = starsInRows
                nextStarsInRows[row] += 1
                var nextStarsInCols = starsInCols
                nextStarsInCols[col] += 1
                var nextStarsInRegions = starsInRegions
                nextStarsInRegions[regionIndex] += 1
                
                if backtrack(row: row, starsInRows: nextStarsInRows, starsInCols: nextStarsInCols, starsInRegions: nextStarsInRegions, allStars: &allStars) {
                    return true
                }
                
                // Backtrack
                allStars.removeLast()
            }
        }
        
        return false
    }

    private func canPlaceStar(at pos: AuraLogicEngine.GridPosition, currentStars: [AuraLogicEngine.GridPosition], starsInCols: [Int], starsInRegions: [Int], regionIndex: Int) -> Bool {
        // 1. Column constraint
        if starsInCols[pos.col] >= starsPerConstraint { return false }
        
        // 2. Region constraint
        if starsInRegions[regionIndex] >= starsPerConstraint { return false }
        
        // 3. No-Touch Rule
        for s in currentStars {
            if abs(s.row - pos.row) <= 1 && abs(s.col - pos.col) <= 1 {
                return false
            }
        }
        
        return true
    }
}
