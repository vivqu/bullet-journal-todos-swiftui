//
//  TaskRowView.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/26/25.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskViewModel

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: {
                task.isComplete.toggle()
            }) {
                Image(systemName: task.isComplete ? "checkmark.square" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)

            // Task text
            Text(task.text)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview Data

struct TaskViewModel {
    var text: String
    var isComplete: Bool
}

#Preview("Incomplete Task") {
    TaskRowView(task: .constant(TaskViewModel(text: "Example todo 1", isComplete: false)))
        .padding()
}

#Preview("Complete Task") {
    TaskRowView(task: .constant(TaskViewModel(text: "Example todo 2", isComplete: true)))
        .padding()
}

#Preview("Multiple Tasks") {
    VStack(alignment: .leading, spacing: 8) {
        TaskRowView(task: .constant(TaskViewModel(text: "Example todo 3", isComplete: false)))
        TaskRowView(task: .constant(TaskViewModel(text: "Example todo 2", isComplete: false)))
        TaskRowView(task: .constant(TaskViewModel(text: "Example todo 1", isComplete: true)))
    }
    .padding()
}
