//
//  TaskCreationView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 24/05/2023.
//

import SwiftUI
import CoreData


struct TaskCreationView: View {
    let page: Page
    
    @State var tList: String = ""
    @State var ShowWar: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Page.name, ascending: true)],
        animation: .default)
    private var pages: FetchedResults<Page>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.content, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    var body: some View {
        Form {
            Section(header: Text("\(ShowWar ? "Name is already taken" : "Enter Name of Task")")) {
                TextField("Task Name", text: $tList)
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
       
    }
    
    @discardableResult
    func Submiter() -> Bool {
        withAnimation {
            if tList == "" {
                return false
            }
            /*
            let newPage = Page(context: viewContext)
            newPage.name = tList
            newPage.id = UUID()*/
            
            let newTask = Task(context: viewContext)
            newTask.content = tList
            newTask.page = page
            newTask.id = UUID()

            do {
                try viewContext.save()
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func isNameInDatabase(_ name: String) -> Bool {
        // Assuming you have a CoreData entity named "Person" with a "name" attribute
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
/*
struct TaskCreationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCreationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
