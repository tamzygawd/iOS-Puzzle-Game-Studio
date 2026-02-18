import Foundation

/// Core engine for Aura Logic (Star Battle).
/// Handles grid state, move validation, and win condition checks.
public class AuraLogicEngine: ObservableObject {
    public enum CellContent: Int, Codable {
        case empty = 0
        case star = 1
        case mark = 2 // For user-placed "X" marks (non-star)
    }

    public struct GridPosition: Hashable, Codable {
        public let row: Int
        public let col: Int
        
        public init(_ row: Int, _ col: Int) {
            self.row = row
            self.col = col
        }
    }

    public struct Level: Codable {
        public let size: Int
        public let regions: [[GridPosition]] // List of positions belonging to each region
        public let starsPerConstraint: Int // Standard is 2 for Aura Logic MVP
        
        public init(size: Int, regions: [[GridPosition]], starsPerConstraint: Int = 2) {
            self.size = size
            self.regions = regions
            self.starsPerConstraint = starsPerConstraint
        }
    }

    @Published public var grid: [GridPosition: CellContent] = [:]
    public let level: Level
    
    public init(level: Level) {
        self.level = level
        reset()
    }
    
    public func reset() {
        grid = [:]
    }
    
    public func toggleStar(at pos: GridPosition) {
        let current = grid[pos] ?? .empty
        switch current {
        case .empty: grid[pos] = .star
        case .star: grid[pos] = .mark
        case .mark: grid[pos] = .empty
        }
    }

    /// Validates the current grid state against Star Battle rules.
    public func checkWinCondition() -> Bool {
        let size = level.size
        let stars = grid.filter { $0.value == .star }.keys
        
        // 1. Check total star count (size * starsPerConstraint)
        guard stars.count == size * level.starsPerConstraint else { return false }
        
        // 2. Row constraint
        for r in 0..<size {
            let rowStars = stars.filter { $0.row == r }.count
            if rowStars != level.starsPerConstraint { return false }
        }
        
        // 3. Column constraint
        for c in 0..<size {
            let colStars = stars.filter { $0.col == c }.count
            if colStars != level.starsPerConstraint { return false }
        }
        
        // 4. Region constraint
        for region in level.regions {
            let regionStars = stars.filter { pos in region.contains(pos) }.count
            if regionStars != level.starsPerConstraint { return false }
        }
        
        // 5. No-Touch Rule (including diagonals)
        for s1 in stars {
            for s2 in stars {
                if s1 == s2 { continue }
                if abs(s1.row - s2.row) <= 1 && abs(s1.col - s2.col) <= 1 {
                    return false
                }
            }
        }
        
        return true
    }
}
