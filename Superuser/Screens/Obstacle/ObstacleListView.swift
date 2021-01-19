//
//  ObstacleListView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct ObstacleListView: View {
    private var _transform: (_: FetchedResults<Obstacle>) -> Array<Obstacle>
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var obstacles: FetchedResults<Obstacle>
    
    init(sortBy: [NSSortDescriptor] = [], transform: @escaping (_: FetchedResults<Obstacle>) -> Array<Obstacle> = { Array($0) }) {
        _obstacles = .init(entity: Obstacle.entity(),
                       sortDescriptors: sortBy,
                       animation: .default)
        _transform = transform
    }
    
    var body: some View {
        List {
            ForEach(_transform(obstacles)) { obstacle in
                ObstacleListItemView(obstacle: obstacle)
                    .environment(\.managedObjectContext, viewContext)
            }
            .onDelete(perform: deleteAreas)
        }
        .listStyle(PlainListStyle())
        .animation(Animation.easeInOut)
    }
    
    private func deleteAreas(offsets: IndexSet) {
        withAnimation {
            viewContext.perform {
                offsets.map { obstacles[$0] }.forEach(viewContext.delete)

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
}

struct ObstacleListItemView: View {
    @ObservedObject var obstacle: Obstacle
    @State private var isLinkActive = false
    @Environment(\.managedObjectContext) private var viewContext
    @State var moving = false
    
    var body: some View {
        Button {
            isLinkActive = true
        } label: {
            HStack {
                Text(obstacle.emoji ?? "")
                Text(obstacle.title ?? "")
                    .font(.system(.body, design: .serif))
                    .padding(.leading, 4)
                    .lineLimit(1)
                Spacer()
                SPCirclesView(obstacle: obstacle)
            }
        }
    }
}

struct MovingPiece: View {
    @State var moving = false
    
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .frame(width: UIScreen.main.bounds.size.width * 2, height: 30, alignment: .center)
            .offset(x: moving ? -UIScreen.main.bounds.size.width : -30)
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
            .onAppear {
                moving = true
            }
    }
}

struct ObstacleListView_Previews: PreviewProvider {
    static var previews: some View {
        AreaListView()
    }
}
