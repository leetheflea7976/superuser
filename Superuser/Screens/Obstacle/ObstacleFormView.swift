//
//  ObstacleFormView.swift
//  Superuser
//
//  Created by Phi on 2021-01-17.
//

import SwiftUI

//
//  AreaFormView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct EditObstacleFormView: View {
    @ObservedObject var obstacle: Obstacle
    
    @State var title = ""
    @State var emoji = ""
    @State var severity: Int16 = 5
    @State var priority: Int16 = 5
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    private func addArea() {
        withAnimation {
            obstacle.emoji = emoji
            obstacle.title = title
            obstacle.priority = priority
            obstacle.severity = severity
            
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
        ObstacleFormView(title: $title, emoji: $emoji, severity: $severity, priority: $priority, isEdit: true, handleSubmit: {
            presentationMode.wrappedValue.dismiss()
            withAnimation {
                obstacle.lastModified = Date()
                obstacle.emoji = emoji
                obstacle.title = title
                obstacle.priority = priority
                obstacle.severity = severity
                try? viewContext.save()
            }
        })
        .onAppear {
            title = obstacle.title!
            emoji = obstacle.emoji!
            severity = obstacle.severity
            priority = obstacle.priority
        }
    }
}

struct NewObstacleFormView: View {
    @State var title = ""
    @State var emoji = ""
    @State var severity: Int16 = 5
    @State var priority: Int16 = 5
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ObstacleFormView(title: $title, emoji: $emoji, severity: $severity, priority: $priority, isEdit: false, handleSubmit: {
            presentationMode.wrappedValue.dismiss()
            withAnimation {
                viewContext.perform {
                    let newArea = Obstacle(context: viewContext)
                    newArea.id = UUID()
                    newArea.createdAt = Date()
                    newArea.lastModified = Date()
                    newArea.emoji = emoji
                    newArea.title = title
                    newArea.priority = priority
                    newArea.severity = severity
                    try? viewContext.save()
                }
            }
        })
    }
}

struct ObstacleFormView: View {
    @Binding var title: String
    @Binding var emoji: String
    @Binding var severity: Int16
    @Binding var priority: Int16
    var isEdit: Bool
    var handleSubmit: () -> Void
    
    var body: some View {
        Text(isEdit ? "Edit Area" : "Add New Area")
            .fontWeight(.bold)
            .font(.title)
            .padding(.top, 24)
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Emoji", text: $emoji)
            }
            
            Section {
                TitleSegmentedNumberPicker(end: 10, title: SeverityData.label, color: SeverityData.color, selection: $severity)
                TitleSegmentedNumberPicker(end: 10, title: PriorityData.label, color: PriorityData.color, selection: $priority)
            }
            
            Section {
                Button {
                    handleSubmit()
                } label: {
                    Text(isEdit ? "Save" : "Add Area")
                }
            }
        }
    }
}

struct ObstacleFormView_Previews: PreviewProvider {
    static var previews: some View {
//        ObstacleFormView()
        EmptyView()
    }
}
