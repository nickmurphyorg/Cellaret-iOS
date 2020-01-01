//
//  DrinkDetailsViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkDetailTableViewController: UITableViewController {

    var drinkSelection: Drink?
    var drinkContent = [DrinkContent]()
    var editDrinkDelegate: EditDrinkDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let editDrinkButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editDrink(_:)))
        
        self.navigationItem.rightBarButtonItem = editDrinkButton
        
        if let drinkSelection = drinkSelection {
            drinkContent = drinkSelection.content()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Table view data source
extension DrinkDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkContent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = drinkContent[indexPath.row]
        
        switch content.type {
        case .detail:
            if let cell = tableView.dequeueReusableCell(withIdentifier: content.type.rawValue, for: indexPath) as? DrinkDetailTableViewCell {
                cell.content = content as? DrinkDetail
                
                return cell
            }
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: content.type.rawValue, for: indexPath) as? DrinkImageTableViewCell {
                //TODO: Connect the delegate
                cell.content = content as? DrinkImage
                
                return cell
            }
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: content.type.rawValue, for: indexPath) as? DrinkTitleTableViewCell {
                cell.content = content as? DrinkTitle
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: - Navigation
extension DrinkDetailTableViewController {
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
extension DrinkDetailTableViewController {
    @IBAction func editDrink(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: segueName.editDrink.rawValue, sender: nil)
    }
    
    @IBAction func unwindToDrinkList(segue: UIStoryboardSegue) {
        // If the drink was deleted, pop this view off the stack without animation
        if segue.identifier == segueName.backToDrinkList.rawValue {
            self.navigationController?.popViewController(animated: false)
        }
    }
}

//MARK: - Drink View Delegate
extension DrinkDetailTableViewController: DrinkViewDelegate {
    func updateView(editedDrink: Drink) {
        drinkSelection = editedDrink
        drinkContent = editedDrink.content()
        
        tableView.reloadData()
    }
}

//MARK: - Drink Image Tap Delegate
extension DrinkDetailTableViewController: DrinkImageTapDelegate {
    func enlargeDrinkImage() {
        guard drinkSelection?.image != nil else { return }
        
        performSegue(withIdentifier: segueName.showDrinkImage.rawValue, sender: nil)
    }
}
