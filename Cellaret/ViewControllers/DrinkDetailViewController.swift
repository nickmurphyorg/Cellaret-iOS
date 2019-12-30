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
    @IBOutlet weak var drinkUPCLabel: UILabel!
    
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
        switch segue.identifier {
        case segueName.editDrink.rawValue:
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.children.first as! EditDrinkTableViewController
            destinationViewController.drinkData = drinkSelection
            destinationViewController.editDrinkDelegate = editDrinkDelegate
            destinationViewController.drinkViewDelegate = self
        case segueName.showDrinkImage.rawValue:
            guard drinkSelection?.imageId != nil else { return }
            
            let navigationController = segue.destination as? UINavigationController
            let destinationViewController = navigationController?.children.first as! ImageZoomViewController
            destinationViewController.drinkImage = ImageController.shared.fetchImage(imageID: drinkSelection!.imageId!, imageSize.original)
        default:
            return
        }
    }
}

// MARK: - Actions
extension DrinkDetailViewController {
    @IBAction func editDrink(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: segueName.editDrink.rawValue, sender: nil)
    }
    
    @IBAction func unwindToDrinkList(segue: UIStoryboardSegue) {
        // If the drink was deleted, pop this view off the stack without animation
        unwind = segue.identifier == segueName.backToDrinkList.rawValue ? true : false
    }
    
    @IBAction func showDrinkImage(_ sender: UITapGestureRecognizer) {
        guard drinkSelection?.image != nil else { return }
        
        performSegue(withIdentifier: segueName.showDrinkImage.rawValue, sender: nil)
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
        drinkImageView.image = drink.image
        drinkNameLabel.text = drink.name
        favoriteImageView.image = drink.favorite ? favoriteStar : nil
        drinkCategoryLabel.text = Menu.shared.selectionName(selection: drink.category)
        drinkVolumeLabel.text = drink.alcoholVolume != nil ? drink.alcoholVolume.toString + "%" : ""
        drinkUPCLabel.text = drink.upc ?? ""
    }
}
