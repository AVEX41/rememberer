#  Rememberer

#### Video Demo:  https://youtu.be/LwI0_nZOIiU
#### Description:

The rememberer is an application to keep track of all the tasks that one need to do. one example is going to school: One need to pack the computer, notebook and the pencils.

To execute this application, one need to open the "rememberer.xcodeproj" into xcode. and then simulate the app on the simulator, on a Mac

##### Structure
one can make multiple pages that are a "category" with multiple tasks. One can use the school-example here: "school" is the category that contains multiple tasks such as "computer", "notebook" etc.

##### Files used in this project
###### ContentView.swift
This is where the application starts. this view lists all the pages in the database. it lists them as a navigationlink and links it to a TaskListView   
This file also includes two ToolBarItems: "plus-icon" and "editbutton".  
the plus-icon is linked to the creationView.  
the editbutton allowes the user to delete the pages (including its tasks)  

###### CreationView.swift
This file is responsible for creating a new page. it is presented as a sheet when the plus-icon on the ContentView is clicked.  
This file has a textfield for entering the name of the page, and a save button to save it to the database (and the viewcontext).

###### TaskListView.swift
This file has a parameter of a page and is showed when a page on the ContentView is pressed.  
This file presents all the tasks of a spesific view, for example: "computer", "notebook" and "pencils", on the school page
This file also has two ToolBarItems: "plus-icon" and "editbutton". the plus-icon works the same as the plus-icon on contentview, except it is ment to create new tasks and is linked to TaskCreationView

###### TaskCreationView.swift
This file is presented as a sheet from TaskListView. this file's job is to create a task on the viewcontext and database. 
This file has the same structure as the CreationView file; textfield and a save button.

###### remembererApp.swift
This is the official start of the application that calls ContentView when it executes.

###### rememberer.xcdatamodeld
This is the core-data datamodel of the application
It has two entities: Page and Task
the Page has a one to many relationship between the Task entity.
