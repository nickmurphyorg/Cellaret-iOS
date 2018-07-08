//
//  MenuTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menu = Menu()
    var menuSelection: Int = 0
    var delegate: MenuSelectionDelegate?

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
        return menu.options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)

        cell.textLabel?.text = menu.options[indexPath.row]
        if indexPath.row == menuSelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuSelection = indexPath.row
        delegate?.menuSelectionMade(selection: menuSelection)
        tableView.reloadData()
    }
    
    @IBAction func closeMenu(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
