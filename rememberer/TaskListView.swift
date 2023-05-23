//
//  TaskListView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 23/05/2023.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    let page: Page
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Page.name, ascending: true)],
        animation: .default)
    private var pages: FetchedResults<Page>
    
    var body: some View {
        VStack {
            Text("Tasks for \(page.name!)")
                .font(.title)
            /*
            List(page.task) { task in
                Text(task.name)
            }
            */
        }
    }
}
/*
struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
*/
