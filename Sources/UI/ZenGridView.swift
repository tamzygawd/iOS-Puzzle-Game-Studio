import SwiftUI

/// ZenGridView: A minimalist, responsive grid layout for 'Aura Logic'.
/// Optimizes interaction for the 'Thumb Zone' on all iPhone sizes.
/// Implements 'Tactile Zen' feedback via HapticManager.
public struct ZenGridView: View {
    
    // MARK: - State Management
    @ObservedObject var engine: AuraLogicEngine
    
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
            Text(engine.currentLevel?.id.uppercased() ?? "LEVEL")
                .font(ThemeEngine.Typography.body())
                .foregroundColor(ThemeEngine.Palette.secondaryText)
            
            Text("Aura Logic")
                .font(ThemeEngine.Typography.title())
                .foregroundColor(ThemeEngine.Palette.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var gridView: some View {
        let gridSize = engine.currentLevel?.size ?? 5
        
        // Optimized for iPhone size/aspect ratio
        return GeometryReader { geo in
            let totalWidth = geo.size.width
            let cellSize = (totalWidth - (CGFloat(gridSize - 1) * ThemeEngine.Layout.gridSpacing)) / CGFloat(gridSize)
            
            VStack(spacing: ThemeEngine.Layout.gridSpacing) {
                ForEach(0..<gridSize, id: \.self) { row in
                    HStack(spacing: ThemeEngine.Layout.gridSpacing) {
                        ForEach(0..<gridSize, id: \.self) { col in
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
        let pos = GridPosition(row, col)
        let content = engine.grid[pos] ?? .empty
        
        return ZStack {
            Rectangle()
                .fill(ThemeEngine.Palette.grid)
                .cornerRadius(4)
                .frame(width: size, height: size)
            
            // Interaction Overlay
            switch content {
            case .star:
                starIcon(size: size * 0.6)
            case .mark:
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
            
            Text("Goal: \(engine.currentLevel?.starsPerConstraint ?? 1) Stars")
                .font(ThemeEngine.Typography.body())
                .foregroundColor(ThemeEngine.Palette.secondaryText)
            
            Spacer()
            
            Button(action: { engine.reset() }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundColor(ThemeEngine.Palette.secondaryText)
            }
        }
    }
    
    // MARK: - Logic
    private func handleInteraction(row: Int, col: Int) {
        let pos = GridPosition(row, col)
        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
            engine.handleInput(at: pos)
        }
        
        // Haptic Feedback Loop
        let content = engine.grid[pos] ?? .empty
        switch content {
        case .star:
            HapticManager.shared.triggerStarPlaced()
        case .mark:
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
