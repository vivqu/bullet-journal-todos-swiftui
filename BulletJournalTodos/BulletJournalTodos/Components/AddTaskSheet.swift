//
//  AddTaskSheet.swift
//  BulletJournalTodos
//
//  Created by Claude on 11/4/25.
//

import SwiftUI

struct AddTaskSheet: View {
    let task: Task?
    let onSubmit: (String) -> Void
    @State private var text: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("", text: $text)
                .font(.body)
                .focused($isTextFieldFocused)
                .submitLabel(.done)
                .onSubmit {
                    handleSubmit()
                }

            Button(action: {
                handleSubmit()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            // Initialize text from task if editing
            if let task = task {
                text = task.text
            }
            isTextFieldFocused = true
        }
    }

    private func handleSubmit() {
        onSubmit(text)
        text = ""
        dismiss()
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()

        VStack {
            Spacer()
            AddTaskSheet(task: nil) { text in
                print("Submit: \(text)")
            }
        }
    }
}
