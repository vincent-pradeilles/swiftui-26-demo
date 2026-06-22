import SwiftUI

/// **Reorderable Containers** (SDK 27)
///
/// Drag-to-reorder now works in *any* container, not just `List`. You add
/// `.reorderable()` to the `ForEach` and `.reorderContainer(for:)` to the
/// enclosing container. When a drag ends, SwiftUI hands you a
/// `ReorderDifference` describing the move, which you apply to your data.
struct ReorderableDemo: View {
    @State private var tiles = Tile.sample

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    var body: some View {
        ScrollView {
            Text("Touch and hold a tile, then drag it to a new spot.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(tiles) { tile in
                    TileView(tile: tile)
                }
                .reorderable()
            }
            .reorderContainer(for: Tile.self) { difference in
                difference.apply(to: &tiles)
            }
            .padding()
        }
        .navigationTitle("Reorderable")
    }
}

/// A colored tile. `Identifiable` is required by `reorderContainer(for:)`.
struct Tile: Identifiable {
    let id = UUID()
    var label: String
    var color: Color

    static let sample: [Tile] = [
        Tile(label: "1", color: .red),
        Tile(label: "2", color: .orange),
        Tile(label: "3", color: .yellow),
        Tile(label: "4", color: .green),
        Tile(label: "5", color: .mint),
        Tile(label: "6", color: .teal),
        Tile(label: "7", color: .blue),
        Tile(label: "8", color: .indigo),
        Tile(label: "9", color: .purple)
    ]
}

private struct TileView: View {
    let tile: Tile

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(tile.color.gradient)
            .frame(height: 90)
            .overlay {
                Text(tile.label)
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            // Match the lifted drag preview to the tile's rounded shape so the
            // system's preview platter doesn't show white corners behind it.
            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 16))
    }
}

/// Applies a single-collection `ReorderDifference` to an array in one pass.
/// Reusable for any container whose elements are `Identifiable`.
extension ReorderDifference where CollectionID == ReorderableSingleCollectionIdentifier {
    func apply<C>(to collection: inout C)
    where C: RangeReplaceableCollection,
          C.Element: Identifiable,
          C.Element.ID == ItemID {
        let moving = Set(sources)
        guard !moving.isEmpty else { return }

        // Remove the moved items, capturing them in their current order.
        var moved: [C.Element] = []
        moved.reserveCapacity(moving.count)
        collection.removeAll { element in
            guard moving.contains(element.id) else { return false }
            moved.append(element)
            return true
        }

        // Re-insert them at the destination.
        switch destination.position {
        case .before(let id):
            let index = collection.firstIndex { $0.id == id } ?? collection.endIndex
            collection.insert(contentsOf: moved, at: index)
        case .end:
            collection.append(contentsOf: moved)
        }
    }
}

#Preview {
    NavigationStack { ReorderableDemo() }
}
