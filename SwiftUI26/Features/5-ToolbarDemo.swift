import SwiftUI

/// **Toolbar Controls** (SDK 27)
///
/// When a toolbar runs out of room, the system moves items into a trailing
/// overflow menu. The new SDK gives you control over that behavior. This demo
/// uses several of the new APIs together:
///
/// * `visibilityPriority(.high)` — keep an item in the bar under pressure.
/// * `ToolbarOverflowMenu` — items that always live in the overflow menu.
/// * `.topBarPinnedTrailing` — an item pinned to the trailing edge.
/// * `toolbarMinimizeBehavior(.onScrollDown)` — shrink the bar while scrolling.
/// * `ForEach` inside the `toolbar` builder — generate items from data.
struct ToolbarDemo: View {
    @State private var lastAction = "Nothing yet"

    // Drives the `ForEach` toolbar items.
    private let quickActions = ["Star", "Tag", "Pin"]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Label("Last action: \(lastAction)", systemImage: "cursorarrow.click")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.quinary, in: RoundedRectangle(cornerRadius: 12))

                Text("Try resizing the window or rotating to see items move into "
                     + "the overflow menu. Scroll down to watch the bar minimize.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Filler so there is something to scroll.
                ForEach(0..<20) { row in
                    Text("Row \(row + 1)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
        .navigationTitle("Toolbar")
        .toolbarMinimizeBehavior(.onScrollDown, for: .navigationBar)
        .toolbar {
            // Stays in the bar even when space is tight.
            ToolbarItemGroup {
                Button { lastAction = "Undo" } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                Button { lastAction = "Redo" } label: {
                    Image(systemName: "arrow.uturn.forward")
                }
            }
            .visibilityPriority(.high)

            // Dynamic items generated from a collection.
            ForEach(quickActions, id: \.self) { action in
                ToolbarItem {
                    Button(action) { lastAction = action }
                }
            }

            // Always presented in the overflow menu.
            ToolbarOverflowMenu {
                Button { lastAction = "Duplicate" } label: {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
                Button(role: .destructive) { lastAction = "Delete All" } label: {
                    Label("Delete All", systemImage: "trash")
                }
            }

            // Pinned to the trailing edge; never moves to the overflow menu.
            ToolbarItem(placement: .topBarPinnedTrailing) {
                Button { lastAction = "Share" } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NavigationStack { ToolbarDemo() }
}
