//
//  CreateTaskButton.swift
//  BulletJournalTodos
//
//  Created by Claude on 10/25/25.
//

import SwiftUI

struct CreateTaskButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text("+ Create task")
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(white: 0.9))
            .cornerRadius(20)
        }
    }
}

#Preview {
    CreateTaskButton {
        print("Create task tapped")
    }
    .padding()
}
