//
//  menuOptions.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

struct Menu {
    let options: [String] = ["All", "Water", "Wine", "Whiskey"]
    
    func selectionName(selection: Int) -> String {
        let name = options[selection]
        return name
    }
}
