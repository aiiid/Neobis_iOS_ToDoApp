//
//  SettingsViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 21/05/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    let tableView = UITableView()
    let defaults = UserDefaults.standard
    let language = LanguageManager.shared
    
    var sections: [String] = []
    var languages: [String] = []
    var selectedLanguageIndex = 0
    
    var selectedLanguage: String {
        get {
            return defaults.string(forKey: "selectedLanguage") ?? "en"
        }
        set {
            defaults.set(newValue, forKey: "selectedLanguage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLanguageIndex = selectedLanguage == "en" ? 0 : 1
        setupUI()
        applyTheme()
        updateSectionsAndLanguages()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageChanged),
            name: Notification.Name.myLanguageNotif,
            object: nil
        )
    }
    
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = language.localizedString(for: "settingsTitle")
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func applyTheme(){
        let isDarkModeEnabled = defaults.bool(forKey: "darkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    @objc func languageChanged(){
        navigationItem.title = language.localizedString(for: "settingsTitle")
        updateSectionsAndLanguages()
    }
    
    func updateSectionsAndLanguages() {
        sections = [language.localizedString(for: "settingsTheme"),
                    language.localizedString(for: "settingsLanguage")]
        languages = [language.localizedString(for: "settingsEnglish"),
                     language.localizedString(for: "settingsRussian")]
        // Reload table view data after updating sections and languages
        tableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = language.localizedString(for: "settingsDarkMode")
            let darkModeSwitch = UISwitch()
            darkModeSwitch.isOn = defaults.bool(forKey: "darkModeEnabled") // Update switch state
            darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = darkModeSwitch
        } else {
            cell.textLabel?.text = languages[indexPath.row]
            cell.accessoryView = nil
            cell.accessoryType = (indexPath.row == selectedLanguageIndex) ? .checkmark : .none
        }
        return cell
    }
    
    
    @objc func darkModeSwitchChanged(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "darkModeEnabled")
        
        if sender.isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    
    //MARK: - Section settings
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : languages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedLanguageIndex = indexPath.row
            selectedLanguage = indexPath.row == 0 ? "en" : "ru"
            language.selectedLanguage = selectedLanguage
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
