//
//  DrinkListTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkListTableViewController: UITableViewController {
    
    var selectedDrinks = [Drink]()
    var tappedDrink: Drink?
    var menuSelection: Int = 0
    
    let cellIdentifier = "drinkCell"
    let favoriteStar = UIImage(named: "Star-White")

    override func viewDidLoad() {
        super.viewDidLoad()
        menuSelection = UserPreferences.shared.getMenuSelection()
        updateTitle()
        selectedDrinks = ModelController.shared.filterDrinks(category: menuSelection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Table view data source
extension DrinkListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDrinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DrinkTableViewCell else {
            fatalError("Drink cell could not be created.")
        }
        
        let drinkFavorite = { [weak self] () -> UIImage? in
            return self?.selectedDrinks[indexPath.row].favorite == true ? self?.favoriteStar : nil
        }
        
        let drinkImage = { [weak self] () -> UIImage? in
            if let drinkImage = self?.selectedDrinks[indexPath.row].image {
                return drinkImage
            } else {
                return nil
            }
        }
        
        cell.favoriteImageView.image = drinkFavorite()
        cell.drinkImageView.image = drinkImage()
        cell.drinkNameLabel.text = selectedDrinks[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tappedDrink = selectedDrinks[indexPath.row]
    }

}

// MARK: - Navigation
extension DrinkListTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MenuOptions":
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.childViewControllers.first as! MenuTableViewController
            destinationViewController.delegate = self
            destinationViewController.menuSelection = self.menuSelection
        case "DrinkDetail":
            let destinationViewController = segue.destination as! DrinkDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destinationViewController.drinkSelection = selectedDrinks[indexPath.row]
            destinationViewController.editDrinkDelegate = self
        case "AddNewDrink":
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.childViewControllers.first as! EditDrinkTableViewController
            destinationViewController.editDrinkDelegate = self
            tappedDrink = nil
        default:
            return
        }
    }
}

//MARK: - Delegates
extension DrinkListTableViewController: MenuSelectionDelegate {
    
    func menuSelectionMade(selection: Int) {
        guard menuSelection != selection else { return }
        
        UserPreferences.shared.updateMenuSelection(selection: selection)
        self.menuSelection = selection
        
        updateTitle()
        
        selectedDrinks = ModelController.shared.filterDrinks(category: menuSelection)
        
        tableView.reloadData()
    }
    
    func updateTitle() {
        self.navigationItem.title = Menu.shared.selectionName(selection: menuSelection)
    }
}

extension DrinkListTableViewController: EditDrinkDelegate {
    
    func editDrink(drink: Drink, action: editAction) {
        switch action {
        case .save:
            ModelController.shared.saveDrink(oldDrink: tappedDrink, newDrink: drink)
            tappedDrink = drink
        case .delete:
            ModelController.shared.deleteDrink(drink: drink)
        }
        
        if drink.category == menuSelection || menuSelection == 0 {
            selectedDrinks = ModelController.shared.filterDrinks(category: menuSelection)
            tableView.reloadData()
        }
    }
}
