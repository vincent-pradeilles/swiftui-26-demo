# What's New in SwiftUI 27

An educational iOS app that demonstrates the new SwiftUI APIs introduced in the
2027 SDKs (iOS 27). Each feature lives on its own screen with simple, readable
code, so you can browse the catalog and jump straight to a working example.

## Features

The home screen is a navigation list; tap any row to open a self-contained demo.

| # | Feature | What it shows |
|---|---------|---------------|
| 1 | **Reorderable Containers** | Drag-to-reorder in any container using `.reorderable()` + `.reorderContainer(for:)`, applying the resulting `ReorderDifference`. |
| 2 | **Swipe Actions Anywhere** | `swipeActions` outside of `List`, enabled by `.swipeActionsContainer()`, plus the new `onPresentationChanged` callback. |
| 3 | **AsyncImage Caching** | Loading images with the new `AsyncImage(request:)` initializer and a custom session via `.asyncImageURLSession(_:)`. |
| 4 | **Item-Bound Dialogs** | `confirmationDialog(_:item:)` and `alert(_:item:)` driven by a `Binding<T?>`. |
| 5 | **Toolbar Controls** | `visibilityPriority`, `ToolbarOverflowMenu`, `.topBarPinnedTrailing`, `toolbarMinimizeBehavior`, and `ForEach` inside a toolbar builder. |

## Requirements

- iOS 27 or later
- Xcode 27 or later

## Getting Started

1. Clone the repository.
2. Open `SwiftUI26.xcodeproj` in Xcode.
3. Select an iOS 27 simulator (or device) and run.

## Project Structure

```
SwiftUI26/
├── ContentView.swift          # App entry point and the navigation catalog
└── Features/
    ├── 1-ReorderableDemo.swift
    ├── 2-SwipeActionsDemo.swift
    ├── 3-AsyncImageDemo.swift
    ├── 4-ItemBindingDemo.swift
    └── 5-ToolbarDemo.swift
```

Feature files are numbered to match their order in the app's navigation. Each
file begins with a doc comment summarizing the API it demonstrates.
