//
//  ContentView.swift
//  Superuser
//
//  Created by Phi on 2021-01-14.
//

import SwiftUI
import CoreData

struct SortOption: Identifiable {
    var id = UUID()
    var label: String
    var color: Color
    var sort: [NSSortDescriptor]
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var showModal = false
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    @State var selectedSortOption = 0
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
            VStack {
                HStack(spacing: 1) {
                    Button {
                        hapticImpact.impactOccurred()
                        showModal = true
                    } label: {
                        Label("Add Area", systemImage: "plus")
                    }
                    Spacer()
                    Menu {
                        ForEach(sortOptions.indices) { i in
                            Button(sortOptions[i].label, action: {
                                selectedSortOption = i
                            })
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(sortOptions[selectedSortOption].label)
                                .fontWeight(.medium)
                                .foregroundColor(sortOptions[selectedSortOption].color)
                            Image(systemName: "arrow.up")
                                .foregroundColor(sortOptions[selectedSortOption].color)
                        }
                        .frame(maxWidth: 200)
                    }
                    .onTapGesture {
                        hapticImpact.impactOccurred()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 20)
                AreaListView(sortDescriptors: sortOptions[selectedSortOption].sort)
            }.navigationBarTitle("Areas")
        }
        .sheet(isPresented: $showModal, content: {
            AreaFormView()
        })
    }
}

struct AreaListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var areas: FetchedResults<Area>
    
    init(sortDescriptors: [NSSortDescriptor]) {
        _areas = .init(entity: Area.entity(),
                       sortDescriptors: sortDescriptors,
                       animation: .default)
    }
    
    var body: some View {
        List {
            ForEach(areas) { area in
                HStack {
                    AreaView(area: area)
                }
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

struct ProgressCircleView: View {
    var progress: CGFloat
    var circleSize: CGFloat
    var lineWidth: CGFloat
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)
                .frame(width: circleSize, height: circleSize)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress / 10, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .frame(width: circleSize, height: circleSize)
        }
    }
}

struct ProgressBar: View {
    var health: Int16
    var priority: Int16
    var outerCircleSize: CGFloat = 28
    var innerCircleSize: CGFloat = 16
    var lineWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            ProgressCircleView(progress: CGFloat(priority), circleSize: outerCircleSize, lineWidth: lineWidth, color: Color.red)
            ProgressCircleView(progress: CGFloat(health), circleSize: innerCircleSize, lineWidth: lineWidth, color: Color.green)
        }
    }
}

struct AreaView: View {
    var area: Area
    var body: some View {
        HStack {
            Text(area.emoji!)
            Text(area.title!)
                .font(.system(.body, design: .serif))
                .padding(.leading, 4)
            Spacer()
            ProgressBar(health: area.health, priority: area.priority)
        }
    }
}

struct AreaFormView: View {
    @State var title = ""
    @State var emoji = ""
    @State var health: Int16 = 5
    @State var priority: Int16 = 5
    @State var type = "Personal"
    var types = ["Personal", "Professional"]
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    private func addArea() {
        withAnimation {
            let newArea = Area(context: viewContext)
            newArea.id = UUID()
            newArea.createdAt = Date()
            newArea.emoji = emoji
            newArea.title = title
            newArea.priority = priority
            newArea.health = health

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
    
    var body: some View {
        Text("Add New Area")
            .fontWeight(.bold)
            .font(.title)
            .padding(.top, 24)
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Emoji", text: $emoji)
                TitleSegmentedNumberPicker(end: 10, title: "Health", selection: $health)
                TitleSegmentedNumberPicker(end: 10, title: "Priority", selection: $priority)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Button {
                presentationMode.wrappedValue.dismiss()
                addArea()
            } label: {
                Label("Add Area", systemImage: "plus")
            }
        }
    }
}

struct TitleSegmentedNumberPicker: View {
    var end: Int16
    var title: String
    @Binding var selection: Int16

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
