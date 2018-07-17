//
//  menuOptions.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

struct Menu {
    static let shared = Menu()
    let options: [String] = ["All", "Beer", "Water", "Wine", "Whiskey", "Vodka"]
    
    func selectionName(selection: Int) -> String {
        let name = options[selection]
        return name
    }
    
    func categoryOptions() -> [String] {
        let categoryOptions = options.filter { $0 != "All" }
        return categoryOptions
    }
}
