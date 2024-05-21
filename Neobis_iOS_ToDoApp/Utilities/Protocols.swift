//
//  Protocols.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 21/05/2024.
//

import Foundation

protocol EditTaskDelegate{
    func didEditTask(task: Task)
    func didDeleteTask(_ task: Task)
}

protocol AddTaskDelegate: AnyObject {
    func didSaveTask(title: String, description: String, isDone: Bool)
}
