import SwiftUI

/// **Swipe Actions Anywhere** (SDK 27)
///
/// `swipeActions` used to work only inside a `List`. Now it works in any
/// scrollable container once you mark that container with
/// `.swipeActionsContainer()`. The per-row `swipeActions` modifier is
/// unchanged: swipe from the trailing edge by default, or pass `edge:` for
/// the leading edge.
///
struct SwipeActionsDemo: View {
    
    @State private var reminders = Reminder.samples

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(reminders) { reminder in
                    ReminderRow(reminder: reminder)
                        .swipeActions(edge: .leading) {
                            Button {
                                toggleFlag(reminder)
                            } label: {
                                Label("Flag", systemImage: "flag")
                            }
                            .tint(.orange)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                delete(reminder)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
        .swipeActionsContainer()
        .navigationTitle("Swipe Actions")
    }
}

extension SwipeActionsDemo {
    private func delete(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }

    private func toggleFlag(_ reminder: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index].isFlagged.toggle()
    }
}

struct Reminder: Identifiable {
    let id = UUID()
    var title: String
    var isFlagged = false

    static let samples = [
        Reminder(title: "Water the plants"),
        Reminder(title: "Reply to Sam"),
        Reminder(title: "Book flights", isFlagged: true),
        Reminder(title: "Renew library card")
    ]
}

private struct ReminderRow: View {
    let reminder: Reminder

    var body: some View {
        HStack {
            if reminder.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.orange)
            }
            Text(reminder.title)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: .rect(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .contentShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack { SwipeActionsDemo() }
}
