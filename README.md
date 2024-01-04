#  Rememberer


#### Description:

The rememberer is an application to keep track of all the tasks that one need to do. One example is going to school: One need to pack the computer, notebook and the pencils.

To execute this application, one need to open the "rememberer.xcodeproj" into xcode. And then simulate the app on the simulator, on a Mac

within the application, one can make multiple pages containing multiple tasks. 
For example, a page can be school (what you need to bring with you when going to the lecture) or shoppinglist, and a task is the individual thing to remember or do.
When the individual tasks are completed, you can mark them as completed  
Both page and tasks can be deleted. When deleting a page, all its tasks will be deleted.

### Files used in this project

#### remembererApp.swift
This is the official start of the application that calls ContentView when it executes.

#### ContentView.swift
This is the startup view and it lists all the pages in the database. It lists them as a navigationlink and links it to a TaskListView   
This file also includes two ToolBarItems: "plus-icon" and "editbutton".  
The plus-icon is linked to the creationView.  
The editbutton allowes the user to delete the pages (including its tasks). This happens in the deleteitems function.
To be sure that it deletes all the tasks in the deleted page, i have added cascade deletion in the datamodel
The edit button is activating editmode, with the possibility for the user to delete the page

#### CreationView.swift
This file is responsible for creating a new page, it is presented as a sheet when the plus-icon on the ContentView is clicked.  
This file has a textfield for entering the name of the page, and a save button to save it to the database and the viewcontext.
The ShowWar (ShowWarning) is ment to send feedback to the user, if they have inputed something invalid, meaning the textfield is empty

The tList variable is a variable that keep track of the name that the user types into the textfield.

#### TaskListView.swift
This view is displaying all of the selected page's tasks and is triggered when the user clicks on a page in the ContentView
This file has a parameter of type "Page" to represent the correct page.

An example is the school page that wil have the following tasks: ["computer", "notebook", "pencils"]
This file also has two ToolBarItems: "plus-icon" and "editbutton". The plus-icon works the same as the plus-icon on contentview, except it is ment to create new tasks and is linked to TaskCreationView
The edit button is activating editmode, with the possibility for the user to delete the task
This file also displays if the task is done, and can be toggled with a function called toggleTaskDone
To filter all the tasks that one want to display, there is a function for that called filteredTasks:
``` swift
    private var filteredTasks: [Task] {
        return tasks.filter { $0.page == page }
    }
```

#### TaskCreationView.swift
This file is presented as a sheet from TaskListView. This file's job is to create a task on the viewcontext and database. 
This file has the same structure as the CreationView file; textfield and a save button.

The functions used in this view are very similar to the ones in CreationView, such as the "Submitter" that checks if the text inputed is empty, before it creates a new task
The ShowWar and tList work the same on this view as on the CreationView.

##### Design for TaskCreationView and CreationView
I had to choose a design for the views "TaskCreationView" and "CreationView", but there are multiple ways one could do it: One could for example merge them into one, and give them a parameter to signal if the user wants to create a new page or task. But in this project, i choose to have two seperate files.
There is also multiple ways of creating the save button. i choose to make it a form-button so that it is easier to see it. Also, if you press return when you are done writing the name, it will save it without the user clicking save. This design is only positive to put in use if there is only one field. if there are multiple, one could risking completing the form without the user completing it.



#### rememberer.xcdatamodeld
This is the core-data datamodel of the application
It has two entities:
 - Page
	- name - the name of the Page
	- id - unique ID
 - Task
	- content - the name/content of the Task
	- id - unique ID
	- isDone - keeps track of what tasks are done
	

The Page has a one to many relationship between the Task entity.
This datamodel also has a cascade deletion rule; when a page is deleted, all its tasks deleted

After doing research for how to structure a datamodel, I came up with this that have Page and Task. 
I designed it to be easy to use in code and robust, it is easy to use because I can call *page.task*, and *task.page* in my code and have the data that i want after i have gathered the data from the database through a fetchrequest.

#### Persistence.swift
This file has two usecases: 11
- Create the preview variable that is used for xcode's preview.
- Make the persistentContainer
