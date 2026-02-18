import Foundation

/// StarBattleSolver utilizes a deterministic backtracking algorithm.
/// Complies with App Store policies by ensuring predictable validation without non-deterministic AI.
public final class StarBattleSolver {
    private let size: Int
    private let starsPerConstraint: Int
    private let posToRegion: [GridPosition: Int]
    private let regionCount: Int
    
    public init(level: LevelProtocol) {
        self.size = level.size
        self.starsPerConstraint = level.starsPerConstraint
        self.regionCount = level.regions.count
        
        var mapping = [GridPosition: Int]()
        for (index, region) in level.regions.enumerated() {
            for pos in region {
                mapping[pos] = index
            }
        }
        self.posToRegion = mapping
    }

    /// Finds a solution if one exists.
    public func solve() -> [GridPosition]? {
        var solution = [GridPosition]()
        let solved = backtrack(
            row: 0,
            starsInRows: Array(repeating: 0, count: size),
            starsInCols: Array(repeating: 0, count: size),
            starsInRegions: Array(repeating: 0, count: regionCount),
            allStars: &solution
        )
        return solved ? solution : nil
    }

    private func backtrack(
        row: Int,
        starsInRows: [Int],
        starsInCols: [Int],
        starsInRegions: [Int],
        allStars: inout [GridPosition]
    ) -> Bool {
        if row == size { return true }

        if starsInRows[row] == starsPerConstraint {
            return backtrack(row: row + 1, starsInRows: starsInRows, starsInCols: starsInCols, starsInRegions: starsInRegions, allStars: &allStars)
        }

        for col in 0..<size {
            let pos = GridPosition(row, col)
            guard let regionIndex = posToRegion[pos] else { continue }
            
            if canPlaceStar(at: pos, currentStars: allStars, starsInCols: starsInCols, starsInRegions: starsInRegions, regionIndex: regionIndex) {
                allStars.append(pos)
                
                var nextRows = starsInRows
                nextRows[row] += 1
                var nextCols = starsInCols
                nextCols[pos.col] += 1
                var nextRegions = starsInRegions
                nextRegions[regionIndex] += 1
                
                if backtrack(row: row, starsInRows: nextRows, starsInCols: nextCols, starsInRegions: nextRegions, allStars: &allStars) {
                    return true
                }
                
                allStars.removeLast()
            }
        }
        
        return false
    }

    private func canPlaceStar(at pos: GridPosition, currentStars: [GridPosition], starsInCols: [Int], starsInRegions: [Int], regionIndex: Int) -> Bool {
        if starsInCols[pos.col] >= starsPerConstraint { return false }
        if starsInRegions[regionIndex] >= starsPerConstraint { return false }
        
        // No-Touch Rule
        for s in currentStars {
            if abs(s.row - pos.row) <= 1 && abs(s.col - pos.col) <= 1 {
                return false
            }
        }
        
        return true
    }
}
