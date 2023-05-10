//
//  CreationView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 02/05/2023.
//

import SwiftUI


struct CreationView: View {
    @State var tList: String = ""
    @State var notsaved = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Page.name, ascending: true)],
        animation: .default)
    private var pages: FetchedResults<Page>
    
    var body: some View {
        Form {
            if !notsaved {
                Text("Saved successful, you can go back now!")
                Toggle(isOn: $notsaved) {
                    Label("Or, create another one", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            } else {
                Section(header: Text("Name for new Task List")) {
                    TextField("Task Name", text: $tList)
                }
            }
        }
        .navigationBarTitle("Settings")
        .onSubmit {
            Submiter()
        }
    }
    
    func Submiter() {
        withAnimation {
            let newPage = Page(context: viewContext)
            newPage.name = tList

            do {
                try viewContext.save()
                notsaved = true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            if notsaved {
                ContentView()
            }
        }
    }
}
struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
