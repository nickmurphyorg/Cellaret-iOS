//
//  DrinkDetailViewTapGestureController.swift
//  Cellaret
//
//  Created by Nick Murphy on 1/5/20.
//  Copyright © 2020 Nick Murphy. All rights reserved.
//

import Foundation
import UIKit

class DrinkDetailViewTapGestureController {
    private weak var viewController: UIViewController!
    private weak var tableView: UITableView!
    
    init(viewController: UIViewController, tableView: UITableView) {
        self.viewController = viewController
        self.tableView = tableView
        
        addTapGesture()
    }
}

extension DrinkDetailViewTapGestureController {
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        tapGesture.delegate = viewController as? UIGestureRecognizerDelegate
        
        tableView.addGestureRecognizer(tapGesture)
    }
}

extension DrinkDetailViewTapGestureController {
    @objc func handleGesture(gestureRecognizer: UITapGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: gestureRecognizer.view)
        
        guard let cellIndex = tableView.indexPathForRow(at: locationInView),
            let tableViewCell = tableView.cellForRow(at: cellIndex) as? DrinkImageTableViewCell else {
                return
        }

        tableViewCell.drinkImageTapDelegate?.enlargeDrinkImage()
    }
}
