import SwiftUI

struct ContentView: View {
    @StateObject private var engine: AuraLogicEngine
    
    init() {
        // Initialize with BundleLevelProvider to load levels from resources
        let provider = BundleLevelProvider()
        _engine = StateObject(wrappedValue: AuraLogicEngine(levelProvider: provider))
    }
    
    var body: some View {
        ZStack {
            // Background theme
            Color(red: 0.05, green: 0.05, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Logic & Chill")
                    .font(.system(size: 32, weight: .thin, design: .serif))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 40)
                
                // The main game grid
                ZenGridView(engine: engine)
                    .padding()
                
                Spacer()
                
                if case .won(let duration) = engine.state {
                    VStack {
                        Text("Level Complete!")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text(String(format: "Time: %.1fs", duration))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Button("Next Level") {
                            Task {
                                await engine.loadNextLevel()
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            Task {
                await engine.loadNextLevel()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
