//
//  AddTaskViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 19/05/2024.
//

import UIKit
import CoreData

protocol AddTaskDelegate: AnyObject {
    func didSaveTask(title: String, description: String, isDone: Bool)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: AddTaskDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("init add task")
        setupUI()
        setupTextView()
        taskDescriptionView.delegate = self
    }
    
    private func setupUI(){
        
        taskDescriptionView.layer.borderColor = UIColor.lightGray.cgColor // Set your desired border color
        taskDescriptionView.layer.borderWidth = 0.5 // Set the border width
        taskDescriptionView.layer.cornerRadius = 5.0 // Optional: set the corner radius for rounded corners
        
        // Setting up navigation bar
        // Create the Save button
        let saveButton = UIBarButtonItem(
                                        title: "Save",
                                        style: .plain,
                                        target: self,
                                        action: #selector(saveTapped)
        )
        
        // Create the Cancel button
        let cancelButton = UIBarButtonItem(
                                        title: "Cancel",
                                        style: .plain,
                                        target: self,
                                        action: #selector(cancelTapped)
        )
        cancelButton.tintColor = .systemRed
        
        // Add the buttons to the navigation bar
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
                
    }
    
    func setupTextView(){
        taskDescriptionView.text = "Task description"
        taskDescriptionView.textColor = UIColor.lightGray
    }
    
    
    @objc func saveTapped(){
        var description = taskDescriptionView.text == "Task description" ? "" : taskDescriptionView.text

        if let title = taskTitleTextField.text, let description = description {
            delegate?.didSaveTask(title: title, description: description, isDone: false)
        }

        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
        print("cancel tapped")
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddTaskViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskDescriptionView.textColor == UIColor.lightGray {
                taskDescriptionView.text = nil
                taskDescriptionView.textColor = UIColor.black
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if taskDescriptionView.text.isEmpty{
            setupTextView()
        }
    }
}

extension AddTaskViewController: EditTaskDelegate{
    func didEditTask(title: String, description: String, isDone: Bool) {
        taskTitleTextField.text = title
        taskDescriptionView.text = description
        
    }
}
