//
//  ViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 18/05/2024.
//

import UIKit
import CoreData


class ToDoViewController: UIViewController{
    
    @IBOutlet weak var editButton: RoundedButton!
    @IBOutlet weak var addButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    var taskArray = [Task]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTasks()
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        navigationItem.title = "ToDoApp"
    }
    
    func setupTableView(){
        cancelButton.alpha = 0
        toDoTableView.tableFooterView = nil
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.allowsSelectionDuringEditing = true
        toDoTableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupFooterView(){
        // Initialize the footer view
        var footerView: UIView!
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        // Add a label to the footer view
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height))
        label.text = "Press + button to add a new task to the list"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14) // Set the font size to 16 points
        label.textColor = .lightGray
        
        footerView.addSubview(label)
        
        // Set the table view footer view
        toDoTableView.tableFooterView = footerView
    }
    
    func setupUI(){
        setupNavBar()
        setupTableView()
        setupFooterView()
    }
    
    
    //MARK: - CoreData actions
    
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
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        do{
            taskArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        toDoTableView.reloadData()
    }
    
    //MARK: - Button actions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editTask", sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        toDoTableView.setEditing(true, animated: true)
        addButton.animateOut()
        editButton.animateOut()
        cancelButton.animateIn()
    }
    
    @IBAction func cancelButtonPressed(_ sender: RoundedButton) {
        print("cancel")
        DispatchQueue.main.async(execute: {
            self.toDoTableView.setEditing(false, animated: true)
        })
        cancelButton.animateOut()
        editButton.animateIn()
        addButton.animateIn()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            if let navigationController = segue.destination as? UINavigationController,
               let addTaskVC = navigationController.topViewController as? AddTaskViewController {
                addTaskVC.delegate = self
                if let selectedTask = sender as? Task {
                    addTaskVC.task = selectedTask
                    addTaskVC.editDelegate = self
                }
            }
        }
        
    }
}

//MARK: - Extensions
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
    
    //Table editing
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let selectedTask = taskArray[indexPath.row]
            // Perform the segue if the table view is in editing mode
            print("select")
            performSegue(withIdentifier: "editTask", sender: selectedTask)
        }else{
            taskArray[indexPath.row].isDone = !taskArray[indexPath.row].isDone
            saveTasks()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow row deletion only when editing mode is enabled
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            // Perform the deletion
            let taskToDelete = self.taskArray[indexPath.row]
            self.context.delete(taskToDelete)
            self.taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveTasks()
            
            // Call the completion handler after the action is performed
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Enable row reordering only when editing mode is enabled
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    // Handle row reordering
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = taskArray.remove(at: sourceIndexPath.row)
        taskArray.insert(movedTask, at: destinationIndexPath.row)
        
        // Update order attribute of tasks
        for (index, task) in taskArray.enumerated() {
            task.order = Int16(index)  // Assuming order starts from 0
        }
        
        saveTasks()
    }
}

extension ToDoViewController: AddTaskDelegate, EditTaskDelegate{
    func didDeleteTask(_ task: Task) {
        context.delete(task)
        saveTasks()
        loadTasks()
    }
    
    func didEditTask(task: Task) {
        saveTasks()
        loadTasks()
    }
    
    func didSaveTask(title: String, description: String, isDone: Bool) {
        print("did save task")
        let newTask = Task(context: context)
        newTask.taskTitle = title
        newTask.taskDescription = description
        newTask.isDone = isDone
        newTask.order = Int16(taskArray.count)
        
        saveTasks()
        loadTasks()
    }
}

