//
//  LanguageManager.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 22/05/2024.
//

import UIKit

class LanguageManager{
    static let shared = LanguageManager()
    var defaults = UserDefaults.standard
    
    private init() {}
    
    var selectedLanguage: String {
        get {
            return defaults.string(forKey: "selectedLanguage") ?? "English"
        }
        set {
            defaults.set(newValue, forKey: "selectedLanguage")
            NotificationCenter.default.post(name: .myLanguageNotif, object: nil)
        }
    }
    
    func localizedString(for key: String) -> String {
            guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                return NSLocalizedString(key, comment: "")
            }
            return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
        }
}
