//
//  AreaMainScreen.swift
//  Superuser
//
//  Created by Phi on 2021-01-15.
//

import SwiftUI
import CoreData

struct AreaMainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var showModal = false
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @FetchRequest(entity: Area.entity(),
                  sortDescriptors: [],
                  animation: .default)
    private var areas: FetchedResults<Area>
    
    @State var selectedSortOptionIndex = 0
    @State var selectedType = "All"
    var sortOptions = [
        SortOption(label: PriorityData.label, color: PriorityData.color, sort: [
            NSSortDescriptor(key: PriorityData.key, ascending: false),
            NSSortDescriptor(key: HealthData.key, ascending: true)
        ]),
        SortOption(label: HealthData.label, color: HealthData.color, sort: [
            NSSortDescriptor(key: HealthData.key, ascending: false),
            NSSortDescriptor(key: PriorityData.key, ascending: true)
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                if (areas.contains { $0.isProfessional }) {
                    PersonalProfessionalPicker(type: $selectedType, withAll: true)
                }
                
                HStack(spacing: 1) {
                    // MARK: ADD AREA BUTTON
                    Button {
                        hapticImpact.impactOccurred()
                        showModal = true
                    } label: {
                        Label("Add Area", systemImage: "plus")
                    }
                    
                    Spacer()
                    
                    // MARK: SORT MENU
                    if (areas.count > 0) {
                        SortMenu(selectedSortOptionIndex: $selectedSortOptionIndex, sortOptions: sortOptions)
                    }
                }
                .padding(.horizontal, 12)
                
                // MARK: AREA LIST VIEW
                AreaListView(
                    sortBy: sortOptions[selectedSortOptionIndex].sort,
                    transform: {
                        $0.filter {
                            if (selectedType == "All") {
                                return true
                            } else if (selectedType == "Personal") {
                                return !$0.isProfessional
                            } else {
                                return $0.isProfessional
                            }
                        }
                    }
                )
                .environment(\.managedObjectContext, viewContext)
            }
            .navigationBarTitle("Areas")
        }
        .sheet(isPresented: $showModal, content: {
            NewAreaFormView()
        })
    }
}

struct AreaMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
