//
//  AreaListView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct AreaListView: View {
    private var _transform: (_: FetchedResults<Area>) -> Array<Area>
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var areas: FetchedResults<Area>
    
    init(sortBy: [NSSortDescriptor] = [], transform: @escaping (_: FetchedResults<Area>) -> Array<Area> = { Array($0) }) {
        _areas = .init(entity: Area.entity(),
                       sortDescriptors: sortBy,
                       animation: .default)
        _transform = transform
    }
    
    var body: some View {
        List {
            ForEach(_transform(areas)) { area in
                AreaListItemView(area: area)
            }
            .onDelete(perform: deleteAreas)
        }
        .listStyle(PlainListStyle())
        .animation(.easeInOut)
    }
    
    private func deleteAreas(offsets: IndexSet) {
        withAnimation {
            offsets.map { areas[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AreaListItemView: View {
    var area: Area
    var body: some View {
        HStack {
            Text(area.emoji!)
            Text(area.title!)
                .font(.system(.body, design: .serif))
                .padding(.leading, 4)
            Spacer()
            HealthPriorityDualCircleView(health: area.health, priority: area.priority)
        }
    }
}


struct AreaListView_Previews: PreviewProvider {
    static var previews: some View {
        AreaListView()
    }
}
