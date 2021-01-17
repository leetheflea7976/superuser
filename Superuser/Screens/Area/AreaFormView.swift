//
//  AreaFormView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct AreaFormView: View {
    @State var title = ""
    @State var emoji = ""
    @State var health: Int16 = 5
    @State var priority: Int16 = 5
    @State var type = "Personal"
    
    
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
            newArea.isProfessional = type == "Professional"

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
            }
            
            Section {
                TitleSegmentedNumberPicker(end: 10, title: "Health", selection: $health)
                TitleSegmentedNumberPicker(end: 10, title: "Priority", selection: $priority)
            }
            
            Section {
                PersonalProfessionalPicker(type: $type)
            }
            
            Section {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    addArea()
                } label: {
                    Text("Add Area")
                }
            }
        }
    }
}

struct PersonalProfessionalPicker: View {
    @Binding var type: String
    var withAll = false
    var types = ["Personal", "Professional"]
    
    var body: some View {
        Picker("Type", selection: $type) {
            ForEach((withAll ? ["All"] : []) + types, id: \.self) { type in
                Text(type).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
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

struct AreaFormView_Previews: PreviewProvider {
    static var previews: some View {
        AreaFormView()
    }
}

