//
//  ContentView.swift
//  rememberer
//
//  Created by AVEX41 on 01/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var tList: String = ""
    @State var showCreationView: Bool = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Page.name, ascending: true)],
        animation: .default)
    private var pages: FetchedResults<Page>

    var body: some View {
        NavigationView {
                    
            List {
                ForEach(pages) { item in
                    NavigationLink(destination: TaskListView(page: item)) {
                        Text(item.name!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    withAnimation() {
                        Button(action: {
                            showCreationView = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showCreationView) {
                CreationView()
                    .onDisappear{
                        showCreationView = false
                    }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pages[$0] }.forEach { page in
                // Delete tasks associated with the page
                page.tasks?.forEach { task in
                    viewContext.delete(task as! NSManagedObject)
                }
                
                // Delete the page itself
                viewContext.delete(page)
            }

            do {
                try viewContext.save()
            } catch {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "Save Failed"
                notificationContent.body = "Failed to save data. Please try again later."
                
                let request = UNNotificationRequest(identifier: "SaveFailedNotification", content: notificationContent, trigger: nil)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error)")
                    } else {
                        print("Notification scheduled successfully.")
                    }
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
