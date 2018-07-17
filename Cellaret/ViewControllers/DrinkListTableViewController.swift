//
//  DrinkListTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkListTableViewController: UITableViewController {
    
    var modelController = ModelController()
    var selectedDrinks = [Drink]()
    var menuSelection: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
        selectedDrinks = modelController.filterDrinks(category: menuSelection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDrinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)

        cell.textLabel?.text = selectedDrinks[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        } else if segue.identifier == "DrinkDetail" {
            let destinationViewController = segue.destination as! DrinkDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destinationViewController.drinkSelection = selectedDrinks[indexPath.row]
        }
    }
}

extension DrinkListTableViewController: MenuSelectionDelegate {
    func menuSelectionMade(selection: Int) {
        guard menuSelection != selection else { return }
        self.menuSelection = selection
        updateTitle()
        selectedDrinks = modelController.filterDrinks(category: menuSelection)
        tableView.reloadData()
    }
    
    func updateTitle() {
        self.navigationItem.title = Menu.shared.selectionName(selection: menuSelection)
    }
}
