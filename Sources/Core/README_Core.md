# Aura Logic

**Constraint-based Star Battle (Two-Not-Touch) Puzzle Engine**
Developed by Logic and Chill.

## Core Rules
1. **Two Stars Per Row**: Every row must contain exactly two stars.
2. **Two Stars Per Column**: Every column must contain exactly two stars.
3. **Two Stars Per Region**: Every colored region must contain exactly two stars.
4. **No-Touch Rule**: Stars cannot touch each other, even diagonally.

## Deliverables
- `StarBattleSolver.swift`: Deterministic solver for level validation.
- `GameEngine.swift`: Swift/SwiftUI core logic for grid state and validation.
- `LevelGenerator.swift`: Minimalist level generation and region partitioning logic.

## Technical Standards
- Clean, minimalist logic.
- Deterministic and reproducible outcomes.
- Vector-aligned UI data structures.
