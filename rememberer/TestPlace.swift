//
//  TestPlace.swift
//  rememberer
//
//  Created by Aleksander Hoff on 18/05/2023.
//
//  This File is not supposed to be here, delete when done.

import SwiftUI
import CoreData

struct TestPlace: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var nameToCheck = ""
    
    var body: some View {
        VStack {
            TextField("Enter a name", text: $nameToCheck)
                .padding()
            
            Button("Check") {
                if isNameInDatabase(nameToCheck) {
                    // Code to execute if the name is present in the database
                    print("Name found in database")
                } else {
                    // Code to execute if the name is not present in the database
                    print("Name not found in database")
                }
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


struct TestPlace_Previews: PreviewProvider {
    static var previews: some View {
        TestPlace()
    }
}
