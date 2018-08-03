//
//  UserDefaultController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/30/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

class UserPreferences {
    static let shared = UserPreferences()
    let preferences = UserDefaults.standard
    let menuChoice = "menuChoice"
    
    private var menuSelection: Int
    
    private init() {
        menuSelection = preferences.integer(forKey: menuChoice)
    }
    
    func getMenuSelection() -> Int {
        return menuSelection
    }
    
    func updateMenuSelection(selection: Int) {
        preferences.set(selection, forKey: menuChoice)
        menuSelection = selection
    }
    
}
