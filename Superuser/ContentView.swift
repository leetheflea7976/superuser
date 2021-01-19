//
//  ContentView.swift
//  Superuser
//
//  Created by Phi on 2021-01-14.
//

import SwiftUI
import CoreData

struct DummyScreen: View {
    var screenName = ""
    
    var body: some View {
        Text(screenName)
    }
}

struct ContentView: View {
    @State private var selection = "Areas"
    @Environment(\.managedObjectContext) private var viewContext
    var haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        TabView (selection: $selection) {
            TabItem(
                selection: $selection,
                title: "Areas",
                selectedIcon: "square.grid.2x2.fill",
                unselectedIcon: "square.grid.2x2",
                content: AreaMainView().environment(\.managedObjectContext, viewContext)
            )
            TabItem(
                selection: $selection,
                title: "Skills",
                selectedIcon: "paintpalette.fill",
                unselectedIcon: "paintpalette",
                content: DummyScreen(screenName: "Skills tab")
            )
            TabItem(
                selection: $selection,
                title: "Obstacles",
                selectedIcon: "exclamationmark.triangle.fill",
                unselectedIcon: "exclamationmark.triangle",
                content: ObstacleMainView().environment(\.managedObjectContext, viewContext)
            )
            TabItem(
                selection: $selection,
                title: "Principles",
                selectedIcon: "scroll.fill",
                unselectedIcon: "scroll",
                content: DummyScreen(screenName: "Principles tab")
            )
            TabItem(
                selection: $selection,
                title: "Do",
                selectedIcon: "figure.walk.circle.fill",
                unselectedIcon: "figure.walk.circle",
                content: DummyScreen(screenName: "Do tab")
            )
        }
    }
}

struct TabItem<Content: View>: View {
    @Binding var selection: String
    var title: String
    var selectedIcon: String
    var unselectedIcon: String
    var content: Content
    
    var body: some View {
        content
            .tabItem {
                Image(systemName: selection == title ? selectedIcon : unselectedIcon)
                Text(title)
            }.tag(title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
