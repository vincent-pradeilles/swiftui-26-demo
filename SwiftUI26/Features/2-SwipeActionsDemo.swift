import SwiftUI

/// **Swipe Actions Anywhere** (SDK 27)
///
/// `swipeActions` used to work only inside a `List`. Now it works in any
/// scrollable container once you mark that container with
/// `.swipeActionsContainer()`. The per-row `swipeActions` modifier is
/// unchanged. The new `onPresentationChanged` callback reports when a row's
/// actions are revealed or hidden.
struct SwipeActionsDemo: View {
    @State private var reminders = Reminder.sample
    @State private var revealedID: Reminder.ID?

    var body: some View {
        ScrollView {
            Text("Swipe a row left to delete, or right to flag — all inside a "
                 + "plain ScrollView + LazyVStack.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            LazyVStack(spacing: 0) {
                ForEach(reminders) { reminder in
                    ReminderRow(
                        reminder: reminder,
                        isRevealed: revealedID == reminder.id
                    )
                    .swipeActions(edge: .leading) {
                        Button {
                            toggleFlag(reminder)
                        } label: {
                            Label("Flag", systemImage: "flag")
                        }
                        .tint(.orange)
                    } onPresentationChanged: { isPresented in
                        revealedID = isPresented ? reminder.id : nil
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            delete(reminder)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }

                    Divider()
                }
            }
        }
        .swipeActionsContainer()
        .navigationTitle("Swipe Actions")
    }

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

    static let sample: [Reminder] = [
        Reminder(title: "Water the plants"),
        Reminder(title: "Reply to Sam"),
        Reminder(title: "Book flights", isFlagged: true),
        Reminder(title: "Renew library card"),
        Reminder(title: "Buy birthday gift"),
        Reminder(title: "Schedule dentist")
    ]
}

private struct ReminderRow: View {
    let reminder: Reminder
    let isRevealed: Bool

    var body: some View {
        HStack {
            if reminder.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.orange)
            }
            Text(reminder.title)
            Spacer()
            if isRevealed {
                Text("Actions shown")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .background(.background)
    }
}

#Preview {
    NavigationStack { SwipeActionsDemo() }
}
