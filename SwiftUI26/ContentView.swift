import SwiftUI

@main
struct SwiftUI26App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// Root screen: a navigable catalog of the new SwiftUI features in the
/// 2027 SDKs. Each row pushes a self-contained demo.
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                FeatureLink(
                    title: "Reorderable Containers",
                    subtitle: "Drag to reorder in any container",
                    systemImage: "arrow.up.arrow.down"
                ) { ReorderableDemo() }

                FeatureLink(
                    title: "Swipe Actions Anywhere",
                    subtitle: "Swipe rows outside of List",
                    systemImage: "hand.draw"
                ) { SwipeActionsDemo() }

                FeatureLink(
                    title: "AsyncImage Caching",
                    subtitle: "Per-request cache policy & sessions",
                    systemImage: "photo.on.rectangle"
                ) { AsyncImageDemo() }

                FeatureLink(
                    title: "Item-Bound Dialogs",
                    subtitle: "alert & confirmationDialog with item:",
                    systemImage: "exclamationmark.bubble"
                ) { ItemBindingDemo() }

                FeatureLink(
                    title: "Toolbar Controls",
                    subtitle: "Overflow, pinning & minimizing",
                    systemImage: "slider.horizontal.3"
                ) { ToolbarDemo() }
            }
            .navigationTitle("What's New in SwiftUI")
        }
    }
}

/// A reusable list row that links to one feature's screen.
private struct FeatureLink<Destination: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(.tint)
            }
        }
    }
}

#Preview {
    ContentView()
}
