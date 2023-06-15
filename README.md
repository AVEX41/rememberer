#  Rememberer

#### Video Demo:  https://youtu.be/LwI0_nZOIiU
#### Description:

The rememberer is an application to keep track of all the tasks that one need to do. one example is going to school: One need to pack the computer, notebook and the pencils.

To execute this application, one need to open the "rememberer.xcodeproj" into xcode. and then simulate the app on the simulator, on a Mac

### Structure
one can make multiple pages that are a "category" with multiple tasks. One can use the school-example here: "school" is the category that contains multiple tasks such as "computer", "notebook" etc.

### Files used in this project
#### ContentView.swift
This is where the application starts. this view lists all the pages in the database. it lists them as a navigationlink and links it to a TaskListView   
This file also includes two ToolBarItems: "plus-icon" and "editbutton".  
the plus-icon is linked to the creationView.  
the editbutton allowes the user to delete the pages (including its tasks). This happens in the deleteitems function:   

``` swift
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
```

#### CreationView.swift
This file is responsible for creating a new page. it is presented as a sheet when the plus-icon on the ContentView is clicked.  
This file has a textfield for entering the name of the page, and a save button to save it to the database (and the viewcontext).
The ShowWar (ShowWarning) variable is to give the user feedback that the name is taken. the code checks the database if the name is taken in the isNameInDatabase function:

``` swift
	@State var ShowWar: Bool = false // show warning
	
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
```

The tList variable is a variable that keep track of the name that the user types into the textfield.

``` swift
    @State var tList: String = ""
    
	TextField("Task Name", text: $tList)
```

#### TaskListView.swift
This file has a parameter of a page and is showed when a page on the ContentView is pressed:  

```swift
    @State var page: Page
```

This file presents all the tasks of a spesific view, for example: "computer", "notebook" and "pencils", on the school page
This file also has two ToolBarItems: "plus-icon" and "editbutton". the plus-icon works the same as the plus-icon on contentview, except it is ment to create new tasks and is linked to TaskCreationView

This file also displays if the task is done, and can be toggled with a function called toggleTaskDone:

``` swift
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
```

To filter all the tasks that one want to display, there is a function for that called filteredTasks:

``` swift
    private var filteredTasks: [Task] {
        return tasks.filter { $0.page == page }
    }
```

#### TaskCreationView.swift
This file is presented as a sheet from TaskListView. this file's job is to create a task on the viewcontext and database. 
This file has the same structure as the CreationView file; textfield and a save button.

Alot of the functions used in this view are very similar to the ones in CreationView, such as the "Submitter" that checks if the text inputed is empty, before it creates a new task (and page)

#### remembererApp.swift
This is the official start of the application that calls ContentView when it executes.

#### rememberer.xcdatamodeld
This is the core-data datamodel of the application
It has two entities: Page and Task
the Page has a one to many relationship between the Task entity.
