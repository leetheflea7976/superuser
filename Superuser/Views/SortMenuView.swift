//
//  SortMenuView.swift
//  Superuser
//
//  Created by Phi on 2021-01-18.
//

import SwiftUI

struct SortMenu: View {
    @Binding var selectedSortOptionIndex: Int
    var sortOptions: [SortOption]
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        Menu {
            ForEach(sortOptions.indices) { i in
                Button(sortOptions[i].label, action: {
                    selectedSortOptionIndex = i
                })
            }
        } label: {
            HStack {
                Text(sortOptions[selectedSortOptionIndex].label)
                    .fontWeight(.medium)
                    .foregroundColor(sortOptions[selectedSortOptionIndex].color)
                Image(systemName: "arrow.up")
                    .foregroundColor(sortOptions[selectedSortOptionIndex].color)
            }
        }
        .onTapGesture {
            hapticImpact.impactOccurred()
        }
    }
}

struct SortMenuView_Previews: PreviewProvider {
    static var previews: some View {
//        SortMenuView()
        EmptyView()
    }
}
