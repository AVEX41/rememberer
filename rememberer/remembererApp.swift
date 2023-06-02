//
//  remembererApp.swift
//  rememberer
//
//  Created by Aleksander Hoff on 01/05/2023.
//
// Make an identifier, which is 128 bytes and use the UUID() to create for page, and when a task is created, it gets the page's identifier

import SwiftUI

@main
struct remembererApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
