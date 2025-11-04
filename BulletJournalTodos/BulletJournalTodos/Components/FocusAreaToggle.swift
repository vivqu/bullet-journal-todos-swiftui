//
//  FocusAreaToggle.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 11/4/25.
//

import SwiftUI

struct FocusAreaToggle: View {
    @Binding var selectedFocusArea: FocusArea

    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                selectedFocusArea = .life
            }) {
                Text("LIFE")
                    .foregroundColor(selectedFocusArea == .life ? .blue : .black)
                    .font(.system(size: 17, weight: .regular))
            }

            Text("/")
                .foregroundColor(.black)

            Button(action: {
                selectedFocusArea = .work
            }) {
                Text("WORK")
                    .foregroundColor(selectedFocusArea == .work ? .blue : .black)
                    .font(.system(size: 17, weight: .regular))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FocusAreaToggle(selectedFocusArea: .constant(.life))
        FocusAreaToggle(selectedFocusArea: .constant(.work))
    }
    .padding()
}
