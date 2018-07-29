//
//  AddDrinkDelegate.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/20/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

enum editAction {
    case save
    case delete
}

protocol EditDrinkDelegate {
    func editDrink(drink: Drink, action: editAction)
}
