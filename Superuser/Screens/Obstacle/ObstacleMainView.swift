//
//  ObstacleMainView.swift
//  Superuser
//
//  Created by Phi on 2021-01-15.
//

import SwiftUI
import CoreData

struct ObstacleMainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showModal = false
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @FetchRequest(entity: Obstacle.entity(),
                  sortDescriptors: [],
                  animation: .default)
    private var obstacles: FetchedResults<Obstacle>
    
    @State var selectedSortOptionIndex = 0
    @State var selectedType = "All"
    var sortOptions = [
        SortOption(label: PriorityData.label, color: PriorityData.color, sort: [
            NSSortDescriptor(key: PriorityData.key, ascending: false),
            NSSortDescriptor(key: SeverityData.key, ascending: false)
        ]),
        SortOption(label: SeverityData.label, color: SeverityData.color, sort: [
            NSSortDescriptor(key: SeverityData.key, ascending: false),
            NSSortDescriptor(key: PriorityData.key, ascending: false)
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 1) {
                    // MARK: ADD AREA BUTTON
                    Button {
                        hapticImpact.impactOccurred()
                        showModal = true
                    } label: {
                        Label("Add Obstacle", systemImage: "plus")
                    }
                    
                    Spacer()
                    
                    if (obstacles.count > 0) {
                        SortMenu(selectedSortOptionIndex: $selectedSortOptionIndex, sortOptions: sortOptions)
                    }
                }
                .padding(.horizontal, 12)
                
                // MARK: PRINCIPLES LIST VIEW
                ObstacleListView(sortBy: sortOptions[selectedSortOptionIndex].sort)
                    .environment(\.managedObjectContext, viewContext)
            }
            .navigationBarTitle("Obstacles")
        }
        .sheet(isPresented: $showModal, content: {
            NewObstacleFormView()
        })
    }
}

struct ObstacleMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
