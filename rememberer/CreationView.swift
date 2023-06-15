//
//  CreationView.swift
//  rememberer
//
//  Created by AVEX41 on 02/05/2023.
//

import SwiftUI
import CoreData


struct CreationView: View {
    @FocusState private var textFocused: Bool
    
    @State var tList: String = ""
    @State var ShowWar: Bool = false // show warning
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Page.name, ascending: true)],
        animation: .default)
    private var pages: FetchedResults<Page>
    
    var body: some View {
        Form {
            Section(header: Text("\(ShowWar ? "Name is already taken" : "Enter Name")")) {
                TextField("Task Name", text: $tList)
                    .focused($textFocused)
            }
            Section {
                withAnimation() {
                    Button(action: {
                        if isNameInDatabase(tList) {
                            ShowWar = true
                        } else {
                            if Submiter() {
                                presentationMode
                                    .wrappedValue
                                    .dismiss()
                            }
                        }
                    }) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
        }
        .onSubmit {
            if Submiter() { presentationMode.wrappedValue.dismiss() }
        }
        .onAppear {
            textFocused = true
        }
    }
    
    @discardableResult
    func Submiter() -> Bool {
        withAnimation {
            if tList == "" {
                return false
            }
            let newPage = Page(context: viewContext)
            newPage.name = tList
            newPage.id = UUID()

            do {
                try viewContext.save()
                return true
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
                return false
            }
        }
    }
    
    func isNameInDatabase(_ name: String) -> Bool {
        let fetchRequest: NSFetchRequest<Page> = Page.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let matchingNames = try viewContext.fetch(fetchRequest)
            return !matchingNames.isEmpty
        } catch {
            print("Error fetching names: \(error.localizedDescription)")
            return false
        }
    }
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
