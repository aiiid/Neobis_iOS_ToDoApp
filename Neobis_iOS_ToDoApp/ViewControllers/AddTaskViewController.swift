//  AddTaskViewController.swift
//  Neobis_iOS_ToDoApp
//  Created by Ai Hawok on 19/05/2024.
//

import UIKit
import CoreData


class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: AddTaskDelegate?
    var editDelegate: EditTaskDelegate?
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        // Populate task details if editing
        if let task = task {
            taskTitleTextField.text = task.taskTitle
            taskDescriptionView.text = task.taskDescription
            taskDescriptionView.textColor = UIColor.black
        } else {
            // Set placeholder text if creating new task
            setupTextView()
        }
    }
    
    private func setupUI() {
        taskDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        taskDescriptionView.layer.borderWidth = 0.5
        taskDescriptionView.layer.cornerRadius = 5.0
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        cancelButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupTextView() {
        if taskDescriptionView.text.isEmpty {
            taskDescriptionView.text = "Task description"
            taskDescriptionView.textColor = UIColor.lightGray
        }
    }
    
    @objc func saveTapped() {
        guard let title = taskTitleTextField.text, !title.isEmpty else {
            taskTitleTextField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
                return
            }
        
        guard var description = taskDescriptionView.text else { return }
        
        if description == "Task description" {
                    description = ""
                }
        
        if let task = task {
            task.taskTitle = title
            task.taskDescription = description
            editDelegate?.didEditTask(task: task)
        } else {
            delegate?.didSaveTask(title: title, description: description, isDone: false)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if let task = task {
                    editDelegate?.didDeleteTask(task)
                }
        dismiss(animated: true, completion: nil)
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskDescriptionView.textColor == UIColor.lightGray {
            taskDescriptionView.text = nil
            taskDescriptionView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if taskDescriptionView.text.isEmpty {
            setupTextView()
        }
    }
}
