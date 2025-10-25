//
//  WeekHeaderView.swift
//  BulletJournalTodos
//
//  Created on 2025-10-25.
//

import SwiftUI

struct WeekHeaderView: View {
    let weekStartDate: Date

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: weekStartDate)
    }

    var body: some View {
        HStack {
            Text("Week of \(formattedDate)")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

#Preview {
    WeekHeaderView(weekStartDate: Date())
}
