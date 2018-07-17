//
//  DrinkDetailsViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkDetailViewController: UIViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var drinkCategoryLabel: UILabel!
    @IBOutlet weak var drinkVolumeLabel: UILabel!
    
    var drinkSelection: Drink?
    var unwind = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if unwind {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let editDrinkButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editDrink(_:)))
        self.navigationItem.rightBarButtonItem = editDrinkButton
        if let drinkSelection = drinkSelection {
            drinkNameLabel.text = drinkSelection.name
            drinkCategoryLabel.text = Menu.shared.selectionName(selection: drinkSelection.category)
            if drinkSelection.alcoholVolume != nil {
                drinkVolumeLabel.text = String(drinkSelection.alcoholVolume!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - Navigation
extension DrinkDetailViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDrink" {
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.childViewControllers.first as! EditDrinkTableViewController
            destinationViewController.editDrink = drinkSelection
        }
    }
}

// MARK: - Actions
extension DrinkDetailViewController {
    
    @IBAction func editDrink(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditDrink", sender: nil)
    }
    
    @IBAction func saveDrink(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToDrinkList(segue: UIStoryboardSegue) {
        unwind = true
    }
}
