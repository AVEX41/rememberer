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
    
    @State var showCreationView: Bool = false
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
        VStack {
            Text("Tasks for \(page.name ?? "Unknown Page")")
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
               .onDelete(perform: deleteItems)
           }
           .toolbar {
               ToolbarItem(placement: .destructiveAction) {
                    EditButton()
                }
               ToolbarItem(placement: .navigationBarTrailing) {
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
               TaskCreationView(page: page)
                   .onDisappear{
                       showCreationView = false
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
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

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
