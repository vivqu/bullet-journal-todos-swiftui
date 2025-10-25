//
//  ContentView.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Text("Bullet Journal Todos")
                .font(.largeTitle)
                .padding()

            Text("Phase 2: UI Implementation Coming Soon")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, Week.self, inMemory: true)
}
