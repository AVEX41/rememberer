//
//  TaskListView.swift
//  rememberer
//
//  Created by Aleksander Hoff on 23/05/2023.
//
// TODO: need to make an ondelete, and make the function that deletes the task

import SwiftUI
import CoreData

struct TaskListView: View {
    let page: Page
    
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
        // the old one, 
        VStack {
            Text("Tasks for \(page.name!)")
               .font(.title)
           
           List {
               ForEach(filteredTasks) { task in
                   HStack {
                       Button(action: {
                           toggleTaskDone(task)
                       }) {
                           Label(
                               title: {
                                   Text("\(task.content!)")
                                       .foregroundColor(task.isDone ? .green : .black)
                               },
                               icon: {
                                   Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                       .foregroundColor(task.isDone ? .green : .gray)
                               }
                           )
                       }
                       Spacer()
                   }
               }
           }
           .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private var filteredTasks: [Task] {
        return tasks.filter { $0.page == page }
    }
    
    private func toggleTaskDone(_ task: Task) {
            viewContext.perform {
                task.isDone.toggle()
                
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
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
