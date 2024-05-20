//
//  ViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 18/05/2024.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController{

    @IBOutlet weak var toDoTableView: UITableView!
    var taskArray = [Task]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        loadTasks()
        //addTaskVC.delegate = self
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        toDoTableView.contentInsetAdjustmentBehavior = .never
        navigationItem.title = "ToDoApp"
    }
    
    
    
    func saveTasks(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        toDoTableView.reloadData()
    }
    
    func loadTasks(){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do{
            taskArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        toDoTableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            if let navigationController = segue.destination as? UINavigationController,
               let addTaskVC = navigationController.topViewController as? AddTaskViewController {
                addTaskVC.delegate = self
            }
        }
    }

 
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let task = taskArray[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.taskTitle
        content.secondaryText = task.taskDescription
        cell.accessoryType = task.isDone ? .checkmark : .none
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        taskArray[indexPath.row].isDone = !taskArray[indexPath.row].isDone
        saveTasks()
        
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (contextualAction, 
                                                                                          view,
                                                                                          isActionPerformed: (Bool) -> ()) in
            self.context.delete(self.taskArray[indexPath.row])
            self.taskArray.remove(at: indexPath.row)
            self.toDoTableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveTasks()

        })
        return UISwipeActionsConfiguration(actions: [delete])
    }

}

extension ToDoViewController: AddTaskDelegate{
    func didSaveTask(title: String, description: String, isDone: Bool) {
        print("did save task")
        let newTask = Task(context: context)
        newTask.taskTitle = title
        newTask.taskDescription = description
        newTask.isDone = isDone
        
        saveTasks()
        loadTasks()
    }
}

