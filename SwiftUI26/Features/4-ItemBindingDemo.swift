import SwiftUI

/// **Item-Bound Dialogs** (SDK 27)
///
/// `confirmationDialog` and `alert` gain overloads that take an
/// `item: Binding<T?>` — the same shape as `sheet(item:)`. The dialog
/// presents while the binding is non-nil, and the unwrapped value is passed
/// to the `actions` and `message` closures. No separate `Bool` flag, no
/// `presenting:` argument, and `T` need not be `Identifiable`.
struct ItemBindingDemo: View {
    @State private var files = FileItem.sample

    // Setting one of these to a value presents its dialog; SwiftUI resets it
    // to nil on dismiss.
    @State private var fileToDelete: FileItem?
    @State private var fileToRename: FileItem?

    var body: some View {
        List {
            ForEach(files) { file in
                HStack {
                    Image(systemName: "doc.fill")
                        .foregroundStyle(.tint)
                    Text(file.name)
                    Spacer()
                    Button("Rename") { fileToRename = file }
                        .buttonStyle(.borderless)
                    Button("Delete", role: .destructive) { fileToDelete = file }
                        .buttonStyle(.borderless)
                }
            }
        }
        .navigationTitle("Item Dialogs")
        // confirmationDialog driven by an optional item.
        .confirmationDialog("Delete file?", item: $fileToDelete) { file in
            Button("Delete \(file.name)", role: .destructive) {
                delete(file)
            }
        } message: { file in
            Text("\(file.name) will be removed permanently.")
        }
        // alert driven by an optional item.
        .alert("Rename file", item: $fileToRename) { file in
            Button("Make a Copy") { duplicate(file) }
            Button("Cancel", role: .cancel) {}
        } message: { file in
            Text("Create a copy of \(file.name)?")
        }
    }

    private func delete(_ file: FileItem) {
        files.removeAll { $0.id == file.id }
    }

    private func duplicate(_ file: FileItem) {
        guard let index = files.firstIndex(where: { $0.id == file.id }) else { return }
        files.insert(FileItem(name: file.name + " copy"), at: index + 1)
    }
}

struct FileItem: Identifiable {
    let id = UUID()
    var name: String

    static let sample: [FileItem] = [
        FileItem(name: "Report.pdf"),
        FileItem(name: "Budget.numbers"),
        FileItem(name: "Notes.txt"),
        FileItem(name: "Logo.png")
    ]
}

#Preview {
    NavigationStack { ItemBindingDemo() }
}
