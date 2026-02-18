import Foundation
import Combine

// MARK: - Core Protocols & State Models

/// Represents the possible contents of a grid cell.
public enum CellContent: Int, Codable {
    case empty = 0
    case star = 1
    case mark = 2 // "X" mark
}

/// A coordinate on the game grid.
public struct GridPosition: Hashable, Codable {
    public let row: Int
    public let col: Int
    
    public init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

/// Defines the structure of a Star Battle level.
public protocol LevelProtocol: Codable {
    var id: String { get }
    var size: Int { get }
    var regions: [[GridPosition]] { get }
    var starsPerConstraint: Int { get }
}

public struct AuraLevel: LevelProtocol {
    public let id: String
    public let size: Int
    public let regions: [[GridPosition]]
    public let starsPerConstraint: Int
    
    public init(id: String = UUID().uuidString, size: Int, regions: [[GridPosition]], starsPerConstraint: Int = 2) {
        self.id = id
        self.size = size
        self.regions = regions
        self.starsPerConstraint = starsPerConstraint
    }
}

/// Abstract provider for levels, allowing for local registry, remote API, or procedurally generated levels.
public protocol LevelProvider {
    func getLevel(id: String) async throws -> LevelProtocol
    func getNextLevel() async throws -> LevelProtocol
}

/// The various states of the game flow.
public enum GameState: Equatable {
    case loading
    case playing
    case paused
    case won(duration: TimeInterval)
    case error(String)
}

// MARK: - Game Engine Implementation

/// The view-agnostic core engine for Aura Logic.
/// It manages game state and logic independently of the UI framework.
public final class AuraLogicEngine: ObservableObject {
    
    // MARK: - Published State
    
    /// Current grid state: Position -> Content.
    @Published public private(set) var grid: [GridPosition: CellContent] = [:]
    
    /// Current game state (Loading, Playing, Won).
    @Published public private(set) var state: GameState = .loading
    
    /// The level currently being played.
    public private(set) var currentLevel: LevelProtocol?
    
    // MARK: - Dependencies
    
    private let levelProvider: LevelProvider
    private var startTime: Date?
    
    public init(levelProvider: LevelProvider) {
        self.levelProvider = levelProvider
    }
    
    // MARK: - Public API
    
    /// Loads the next available level from the provider.
    public func loadNextLevel() async {
        state = .loading
        do {
            let level = try await levelProvider.getNextLevel()
            self.currentLevel = level
            self.grid = [:]
            self.startTime = Date()
            self.state = .playing
        } catch {
            self.state = .error("Failed to load level: \(error.localizedDescription)")
        }
    }
    
    /// Toggles cell state: Empty -> Star -> Mark -> Empty.
    public func handleInput(at pos: GridPosition) {
        guard state == .playing else { return }
        
        let current = grid[pos] ?? .empty
        switch current {
        case .empty: grid[pos] = .star
        case .star:  grid[pos] = .mark
        case .mark:  grid[pos] = .empty
        }
        
        checkWinCondition()
    }
    
    public func reset() {
        grid = [:]
        startTime = Date()
        state = .playing
    }
    
    // MARK: - Private Logic
    
    private func checkWinCondition() {
        guard let level = currentLevel else { return }
        
        let stars = grid.filter { $0.value == .star }.keys
        
        // Rule 1: Correct star count
        guard stars.count == level.size * level.starsPerConstraint else { return }
        
        // Rule 2 & 3: Row and Column constraints
        for i in 0..<level.size {
            if stars.filter({ $0.row == i }).count != level.starsPerConstraint { return }
            if stars.filter({ $0.col == i }).count != level.starsPerConstraint { return }
        }
        
        // Rule 4: Region constraint
        for region in level.regions {
            let regionStars = stars.filter { region.contains($0) }.count
            if regionStars != level.starsPerConstraint { return }
        }
        
        // Rule 5: No-Touch Rule (Adjacency)
        for s1 in stars {
            for s2 in stars where s1 != s2 {
                if abs(s1.row - s2.row) <= 1 && abs(s1.col - s2.col) <= 1 {
                    return
                }
            }
        }
        
        // Transition to Won state
        let duration = Date().timeIntervalSince(startTime ?? Date())
        state = .won(duration: duration)
    }
}
