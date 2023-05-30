//
//  remembererApp.swift
//  rememberer
//
//  Created by Aleksander Hoff on 01/05/2023.
//
// TODO: Link the page-id to the task-id

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
