# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter habit tracking application (practice2) that allows users to create habits, track acknowledgments (acks), and monitor streak progress. The app implements a clean architecture with separation between entities, state management, UI screens, and widgets.

## Development Commands

### Running the app
```bash
flutter run
```

### Building
```bash
flutter build <platform>  # e.g., flutter build apk, flutter build web
```

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

### Dependencies
```bash
flutter pub get          # Install dependencies
flutter pub upgrade      # Upgrade dependencies
```

## Architecture

### Core Concepts

The application follows a **unidirectional data flow** pattern with a container-controller architecture:

1. **Entities** ([lib/features/entities/](lib/features/entities/)) - Domain models with business logic
   - `Habbit`: Immutable entity representing a habit with streak calculation logic
   - `HabbitAck`: Represents a single acknowledgment (timestamp when habit was performed)
   - `Streak`: Tracks consecutive acknowledgments within the habit's interval

2. **State Management** ([lib/features/state/](lib/features/state/))
   - `HabbitsContainer`: Central state container that implements `HabbitsController` interface
   - Manages the list of `Habbit` entities and screen navigation
   - Converts domain entities to view models (`HabbitModel`) for UI consumption
   - Uses dependency injection for `currentDateTime()` and `nextHabbitId()` functions

3. **Controller Interface** ([lib/features/widgets/habbits_controller.dart](lib/features/widgets/habbits_controller.dart))
   - `HabbitsController`: Abstract interface defining all operations (add, ack, remove habits, navigation)
   - Implemented by `HabbitsContainer`
   - Passed down to screens and widgets for communication back to state

4. **Screens** ([lib/features/screens/](lib/features/screens/))
   - `HabbitsListScreen`: Displays list of habits with FAB to add new ones
   - `HabbitFormScreen`: Form for creating new habits (currently supports name and interval)

5. **Widgets** ([lib/features/widgets/](lib/features/widgets/))
   - `HabbitsList`: ListView builder for rendering habits
   - `HabbitItem`: Individual habit display component

### Data Flow

```
User Action → Screen → Controller Interface → HabbitsContainer (setState) →
  Habbit Entity (immutable operations) → HabbitModel → Screen/Widget → UI Update
```

### Key Patterns

- **Immutability**: `Habbit` entities use `_copyWith` pattern - all modifications return new instances
- **Dependency Injection**: Time and ID generation are injected into `HabbitsContainer` for testability
- **View Models**: `HabbitModel` separates domain entities from UI concerns (streak lengths are pre-calculated)
- **Manual Navigation**: Screen switching is managed via enum `Screen` in `HabbitsContainer` instead of Flutter's Navigator

### Streak Calculation Logic

- `maxStreak`: Forward iteration through acks to find longest consecutive streak
- `currentStreak`: Reverse iteration to find current ongoing streak from most recent ack
- Streaks break if gap between acks exceeds the habit's `interval` duration

## Important Notes

- The app uses **stateful manual navigation** rather than Flutter's routing system - all navigation goes through `HabbitsController.showHabbitFormScreen()` / `showHabbitsListScreen()`
- Habits are currently stored in-memory only (no persistence layer)
- The interval is hardcoded to 1 day in `HabbitFormScreen` despite UI for time picker
- Entry point is [lib/main.dart](lib/main.dart) which wraps `HabbitsContainer` in a `MaterialApp`
