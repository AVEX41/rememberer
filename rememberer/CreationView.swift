//
//  CreationView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 02/05/2023.
//

import SwiftUI
import CoreData


struct CreationView: View {
    //var completion: (() -> Void)?
    @State var tList: String = ""
    @State var ShowWar: Bool = false
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
        /*
        .navigationBarTitle("Creation View")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Save") {
                if Submiter() {
                    completion?() // call completion closure to dismiss sheet
                }
            }
        )*/
    }
    
    @discardableResult
    func Submiter() -> Bool {
        withAnimation {
            if tList == "" {
                return false
            }
            let newPage = Page(context: viewContext)
            newPage.name = tList

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

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
