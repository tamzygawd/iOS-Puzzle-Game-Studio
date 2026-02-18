import SwiftUI

/// ZenGridView: A minimalist, responsive grid layout for 'Aura Logic'.
/// Optimizes interaction for the 'Thumb Zone' on all iPhone sizes.
/// Implements 'Tactile Zen' feedback via HapticManager.
public struct ZenGridView: View {
    
    // MARK: - State Management
    // For prototype purposes, let's simulate a 5x5 grid
    @State private var gridState: [[CellStatus]] = Array(repeating: Array(repeating: .empty, count: 5), count: 5)
    
    // MARK: - Types
    public enum CellStatus {
        case empty      // Default
        case marked     // Negative space ('X')
        case star       // Goal element
        
        mutating func cycle() {
            switch self {
            case .empty: self = .star
            case .star: self = .marked
            case .marked: self = .empty
            }
        }
    }
    
    // MARK: - View
    public var body: some View {
        ZStack {
            ThemeEngine.Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header - Focused, No Clutter
                header
                
                // The Grid - Centerpiece
                gridView
                
                Spacer()
                
                // Interaction Layer - Thumb Zone focus
                footerControls
            }
            .padding(.horizontal, 24)
            .padding(.bottom, ThemeEngine.Layout.thumbZoneBottomPadding)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("LEVEL 1")
                .font(ThemeEngine.Typography.body())
                .foregroundColor(ThemeEngine.Palette.secondaryText)
            
            Text("Aura Logic")
                .font(ThemeEngine.Typography.title())
                .foregroundColor(ThemeEngine.Palette.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var gridView: some View {
        // Optimized for iPhone size/aspect ratio
        GeometryReader { geo in
            let size = geo.size.width
            let cellSize = (size - (4 * ThemeEngine.Layout.gridSpacing)) / 5
            
            VStack(spacing: ThemeEngine.Layout.gridSpacing) {
                ForEach(0..<5) { row in
                    HStack(spacing: ThemeEngine.Layout.gridSpacing) {
                        ForEach(0..<5) { col in
                            cellView(row: row, col: col, size: cellSize)
                                .onTapGesture {
                                    handleInteraction(row: row, col: col)
                                }
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func cellView(row: Int, col: Int, size: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(ThemeEngine.Palette.grid)
                .cornerRadius(4)
                .frame(width: size, height: size)
            
            // Interaction Overlay
            switch gridState[row][col] {
            case .star:
                starIcon(size: size * 0.6)
            case .marked:
                markedIcon(size: size * 0.3)
            case .empty:
                EmptyView()
            }
        }
    }
    
    private func starIcon(size: CGFloat) -> some View {
        Image(systemName: "sparkles") // SFSymbols for zero-latency, vector rendering
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(ThemeEngine.Palette.accent)
            .transition(.scale.combined(with: .opacity))
    }
    
    private func markedIcon(size: CGFloat) -> some View {
        Circle()
            .fill(ThemeEngine.Palette.secondary)
            .frame(width: size, height: size)
            .opacity(0.4)
    }
    
    private var footerControls: some View {
        HStack {
            Button(action: { /* Logic for hint */ }) {
                Image(systemName: "lightbulb")
                    .font(.title2)
                    .foregroundColor(ThemeEngine.Palette.secondaryText)
            }
            
            Spacer()
            
            Text("Goal: 5 Stars")
                .font(ThemeEngine.Typography.body())
                .foregroundColor(ThemeEngine.Palette.secondaryText)
            
            Spacer()
            
            Button(action: { /* Logic for restart */ }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundColor(ThemeEngine.Palette.secondaryText)
            }
        }
    }
    
    // MARK: - Logic
    private func handleInteraction(row: Int, col: Int) {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
            gridState[row][col].cycle()
        }
        
        // Haptic Feedback Loop
        switch gridState[row][col] {
        case .star:
            HapticManager.shared.triggerStarPlaced()
        case .marked:
            HapticManager.shared.triggerCellMarked()
        case .empty:
            HapticManager.shared.triggerCellMarked() // Subtle 'remove' click
        }
    }
}

// MARK: - Preview
struct ZenGridView_Previews: PreviewProvider {
    static var previews: some View {
        ZenGridView()
            .preferredColorScheme(.dark)
    }
}
