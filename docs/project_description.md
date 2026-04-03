# FinWise - Project Description

## What I Built

FinWise is a comprehensive personal finance management app built with Flutter. It goes beyond simple expense tracking to provide a complete financial toolkit: transaction management, budgeting, savings goals, net worth tracking, investment portfolios, debt payoff planning, AI-powered insights, and a gamified achievement system -- all running offline on the user's device.

The app manages 32 distinct features across a layered Clean Architecture with BLoC state management. It uses a local SQLite database (via Drift) with 21 tables, supports multi-profile usage, and implements a freemium monetization model with feature gates.

## How I Built It

I followed a **spec-driven development** approach, planning each phase before writing code:

1. **Scope & Architecture First** -- Defined the project scope, constraints, and Clean Architecture rules before writing a single widget. Every feature follows the same `UI -> BLoC -> UseCase -> Repository -> DataSource` flow.

2. **Phased Delivery** -- Built the app in 5 incremental phases:
   - Phase 1: Foundation (DI, database, routing, theming)
   - Phase 2: Core financial features (transactions, accounts, budgets, goals)
   - Phase 3: Gamification (achievements, wellness score, onboarding)
   - Phase 4: Advanced features (investments, net worth, debt planning, AI insights)
   - Phase 5: Monetization & polish (feature gates, security, privacy mode)

3. **AI-Assisted with Claude Code** -- Used Claude Code as a building assistant throughout development. Claude helped generate boilerplate for the Clean Architecture layers, implement algorithms (debt payoff strategies, anomaly detection, wellness scoring), and maintain consistency across 32 features. The spec-driven approach -- writing scope docs and requirements before implementation -- was critical for keeping the AI focused and the codebase coherent.

4. **Strict Architectural Rules** -- Enforced via `.claude/rules/` files covering architecture, state management, routing, theming, error handling, testing, and code style. These rules ensured that every feature, whether written by hand or with AI assistance, followed the same patterns.

## What I Learned

**Specs save more time than they cost.** Writing a scope document and PRD before touching code felt slow at first, but it eliminated entire categories of rework. When the AI assistant had a clear spec, it produced code that fit the architecture on the first try. Without a spec, it would generate plausible but inconsistent code that required manual correction.

**Layer discipline compounds.** Clean Architecture felt like overhead in Phase 1 when there were only 3 features. By Phase 4 with 25+ features, the strict separation meant I could add investments, debt planning, and AI insights without touching existing transaction or budget code. Each feature was isolated and independently testable.

**Feature gates should be designed early, not bolted on.** Adding the freemium model in Phase 5 was straightforward because the architecture already isolated features. If the features had been tightly coupled, gating would have required a painful refactor.

**AI works best with constraints.** The `.claude/rules/` files were the single most impactful productivity decision. They turned the AI from a code generator into a team member that understood and followed the project's conventions. Rules like "no mutable instance variables in BLoC" and "no error strings in state" prevented entire classes of bugs.

## Tech Stack

- **Flutter** (Dart 3.11.1+) -- cross-platform mobile framework
- **BLoC** -- predictable state management with event transformers
- **Drift** -- type-safe SQLite ORM with code generation
- **GetIt + Injectable** -- dependency injection with annotation-based registration
- **GoRouter** -- declarative routing with nested navigation
- **fpdart** -- functional error handling with Either types
- **fl_chart** -- interactive financial charts and visualizations
- **Freezed** -- immutable data models with code generation
- **Material 3** -- modern design system with light/dark theme support
