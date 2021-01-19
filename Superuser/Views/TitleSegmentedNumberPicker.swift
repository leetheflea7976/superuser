//
//  TitleSegmentedNumberPicker.swift
//  Superuser
//
//  Created by Phi on 2021-01-17.
//

import SwiftUI

struct TitleSegmentedNumberPicker: View {
    var end: Int16
    var title: String
    var color: Color
    @Binding var selection: Int16

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(color)
                .fontWeight(.bold)
                .padding(.bottom, 6)
            Picker(title, selection: $selection) {
                ForEach(1...end, id: \.self) { i in
                    Text(String(i)).tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 6)
    }
}

struct TitleSegmentedNumberPicker_Previews: PreviewProvider {
    static var previews: some View {
//        TitleSegmentedNumberPicker()
        EmptyView()
    }
}

