//
//  AreaDetailView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct AreaDetailView: View {
    @ObservedObject var area: Area
    @State var showModal = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            HPCirclesView(area: area, size: .large)
        }
        .navigationTitle(area.emoji! + " " + area.title!)
        .navigationBarItems(trailing:
            Button {
                showModal.toggle()
            } label: {
                Text("Edit")
                    .fontWeight(.regular)
            }
        )
        .sheet(isPresented: $showModal, content: {
            EditAreaFormView(area: area).environment(\.managedObjectContext, viewContext)
        })
    }
}

struct AreaDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        AreaDetailView()
        EmptyView()
    }
}

