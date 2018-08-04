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
            updateView(withDrink: drinkSelection)
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

extension DrinkDetailViewController: DrinkViewDelegate {
    
    func updateView(editedDrink: Drink) {
        drinkSelection = editedDrink
        
        if let updatedDrink = drinkSelection {
            updateView(withDrink: updatedDrink)
        }
    }
    
    func updateView(withDrink: Drink) {
        let drinkImage = withDrink.image
        
        if let drinkImage = drinkImage {
            drinkImageView.image = drinkImage
        }
        
        drinkNameLabel.text = withDrink.name
        
        if withDrink.favorite == true {
            favoriteImageView.image = favoriteStar
        } else {
            favoriteImageView.image = nil
        }
        
        drinkCategoryLabel.text = Menu.shared.selectionName(selection: withDrink.category)
        drinkVolumeLabel.text = String(withDrink.alcoholVolume)
    }
}
