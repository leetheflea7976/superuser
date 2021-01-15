//
//  SuperuserApp.swift
//  Superuser
//
//  Created by Phi on 2021-01-14.
//

import SwiftUI

@main
struct SuperuserApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
