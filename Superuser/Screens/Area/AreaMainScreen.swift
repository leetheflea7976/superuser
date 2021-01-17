//
//  AreaMainScreen.swift
//  Superuser
//
//  Created by Phi on 2021-01-15.
//

import SwiftUI
import CoreData

struct SortOption: Identifiable {
    var id = UUID()
    var label: String
    var color: Color
    var sort: [NSSortDescriptor]
}

struct AreaMainScreen: View {
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
        SortOption(label: "Priority", color: Color.red, sort: [
            NSSortDescriptor(key: "priority", ascending: false),
            NSSortDescriptor(key: "health", ascending: true)
        ]),
        SortOption(label: "Health", color: Color.green, sort: [
            NSSortDescriptor(key: "health", ascending: false),
            NSSortDescriptor(key: "priority", ascending: true)
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
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
                        Menu {
                            ForEach(sortOptions.indices) { i in
                                Button(sortOptions[i].label, action: {
                                    selectedSortOptionIndex = i
                                })
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text(sortOptions[selectedSortOptionIndex].label)
                                    .fontWeight(.medium)
                                    .foregroundColor(sortOptions[selectedSortOptionIndex].color)
                                Image(systemName: "arrow.up")
                                    .foregroundColor(sortOptions[selectedSortOptionIndex].color)
                            }
                            .frame(maxWidth: 200)
                        }
                        .onTapGesture {
                            hapticImpact.impactOccurred()
                        }
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
            }
            .navigationBarTitle("Areas")
        }
        .sheet(isPresented: $showModal, content: {
            AreaFormView()
        })
    }
}

struct AreaMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
