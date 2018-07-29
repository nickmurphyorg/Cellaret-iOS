//
//  MenuTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuSelection: Int = 0
    var delegate: MenuSelectionDelegate?
    
    let impact = UIImpactFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.shared.menuOptions().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)

        cell.textLabel?.text = Menu.shared.menuOptions()[indexPath.row]
        if indexPath.row == menuSelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        impact.impactOccurred()
        
        tableView.deselectRow(at: indexPath, animated: true)
        menuSelection = indexPath.row
        delegate?.menuSelectionMade(selection: menuSelection)
        tableView.reloadData()
    }
    
    @IBAction func closeMenu(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
