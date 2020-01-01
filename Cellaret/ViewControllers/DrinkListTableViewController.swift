//
//  DrinkListTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit
import AVFoundation

class DrinkListTableViewController: UITableViewController {
    
    var selectedDrinks = [Drink]()
    var selectedDrinkIndex: Int = -1
    var menuSelection: Int = 0
    
    let cellIdentifier = "drinkCell"
    let favoriteStar = UIImage(named: "Star-White")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuSelection = UserPreferences.shared.getMenuSelection()
        
        updateTitle()
        
        selectedDrinks = ModelController.shared.returnDrinksIn(category: menuSelection)
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
        
        selectedDrinkIndex = indexPath.row
        
        performSegue(withIdentifier: segueName.drinkDetails.rawValue, sender: nil)
    }

}

//MARK: - Add New Drink
extension DrinkListTableViewController {
    @IBAction func AddNewDrink(_ sender: UIBarButtonItem) {
        if AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.denied {
            performSegue(withIdentifier: segueName.addNewDrinkForm.rawValue, sender: nil)
        } else {
            performSegue(withIdentifier: segueName.addNewDrink.rawValue, sender: nil)
        }
    }
}

// MARK: - Navigation
extension DrinkListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueName.menuOptions.rawValue:
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.children.first as! MenuTableViewController
            destinationViewController.delegate = self
            destinationViewController.menuSelection = self.menuSelection
        case segueName.drinkDetails.rawValue:
            let destinationViewController = segue.destination as! DrinkDetailTableViewController
            destinationViewController.drinkSelection = selectedDrinkIndex != -1 ? selectedDrinks[selectedDrinkIndex] : nil
            destinationViewController.editDrinkDelegate = self
        case segueName.addNewDrink.rawValue:
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.children.first as! BarcodeScanerViewController
            destinationViewController.editDrinkDelegate = self
        case segueName.addNewDrinkForm.rawValue:
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.children.first as! EditDrinkTableViewController
            destinationViewController.editDrinkDelegate = self
            destinationViewController.drinkData = Drink()
        default:
            return
        }
    }
}

//MARK: - Menu Selection Delegate
extension DrinkListTableViewController: MenuSelectionDelegate {
    func menuSelectionMade(selection: Int) {
        guard menuSelection != selection else { return }
        
        UserPreferences.shared.updateMenuSelection(selection: selection)
        
        self.menuSelection = selection
        
        updateTitle()
        
        selectedDrinks = ModelController.shared.returnDrinksIn(category: menuSelection)
        
        tableView.reloadData()
    }
}

//MARK: - Edit Drink Delegate
extension DrinkListTableViewController: EditDrinkDelegate {
    func editDrink(drink: Drink, action: editAction) {
        switch action {
        case .save:
            ModelController.shared.saveEdited(drink)
            
            selectedDrinks[selectedDrinkIndex] = drink
            
        case .create:
            let savedDrink = ModelController.shared.saveNewDrink(drink)
            
            if savedDrink.category == menuSelection || menuSelection == 0 {
                selectedDrinks.append(savedDrink)
            }

        case .delete:
            selectedDrinks = ModelController.shared.deleteDrink(selectedDrinkIndex, selectedDrinks)
        }
        
        tableView.reloadData()
    }
}

//MARK: - Helper Methods
extension DrinkListTableViewController {
    func updateTitle() {
        self.navigationItem.title = Menu.shared.selectionName(selection: menuSelection)
    }
}
