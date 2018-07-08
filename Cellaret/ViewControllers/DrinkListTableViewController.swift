//
//  DrinkListTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkListTableViewController: UITableViewController {
    
    var menu = Menu()
    var menuSelection: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)

        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func updateTitle() {
        self.navigationItem.title = menu.selectionName(selection: menuSelection)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuOptions" {
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.childViewControllers.first as! MenuTableViewController
            destinationViewController.delegate = self
            destinationViewController.menuSelection = self.menuSelection
        }
    }
}

extension DrinkListTableViewController: MenuSelectionDelegate {
    func menuSelectionMade(selection: Int) {
        print("Data received.")
        guard menuSelection != selection else { return }
        self.menuSelection = selection
        updateTitle()
    }
}
