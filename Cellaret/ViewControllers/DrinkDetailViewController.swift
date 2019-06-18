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
    var editDrinkDelegate: EditDrinkDelegate?
    var unwind = false
    
    let favoriteStar = UIImage(named: "Star-Black")
    
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
            updateViewWith(drinkSelection)
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
            let destinationViewController = navigationController?.children.first as! EditDrinkTableViewController
            destinationViewController.editDrink = drinkSelection
            destinationViewController.editDrinkDelegate = editDrinkDelegate
            destinationViewController.drinkViewDelegate = self
        }
    }
}

// MARK: - Actions
extension DrinkDetailViewController {
    @IBAction func editDrink(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "EditDrink", sender: nil)
    }
    
    @IBAction func unwindToDrinkList(segue: UIStoryboardSegue) {
        unwind = true
    }
}

//MARK: - Protocols
extension DrinkDetailViewController: DrinkViewDelegate {
    func updateView(editedDrink: Drink) {
        drinkSelection = editedDrink
        
        updateViewWith(editedDrink)
    }
}

//MARK: - Helper Methods
extension DrinkDetailViewController {
    func updateViewWith(_ drink: Drink) {
        if let drinkImage = drink.image {
            drinkImageView.image = drinkImage
        }
        
        drinkNameLabel.text = drink.name
        
        if drink.favorite == true {
            favoriteImageView.image = favoriteStar
        } else {
            favoriteImageView.image = nil
        }
        
        drinkCategoryLabel.text = Menu.shared.selectionName(selection: drink.category)
        drinkVolumeLabel.text = String(drink.alcoholVolume) + "%"
    }
}
