//
//  ViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 18/05/2024.
//

import UIKit

class ToDoViewController: UIViewController{

    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        toDoTableView.contentInsetAdjustmentBehavior = .never
        navigationItem.title = "ToDoApp"
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let vc = AddTaskViewController()
        self.performSegue(withIdentifier: "editTask", sender: self)

    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        content.text = "text label"
        content.secondaryText = "detail text"
        cell.contentConfiguration = content
        return cell
    }
    
    
}

