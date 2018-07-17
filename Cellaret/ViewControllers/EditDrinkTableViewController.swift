//
//  EditDrinkTableViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import UIKit

class EditDrinkTableViewController: UITableViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameField: UITextField!
    @IBOutlet weak var categoryCell: UITableViewCell!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var drinkVolumeField: UITextField!
    @IBOutlet weak var deleteDrinkButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    enum pickerCell {
        case open
        case closed
    }
    
    var pickerState = pickerCell.open
    var menuOptions = [String]()
    var editDrink: Drink?
    
    let categoryToggleLabel = "Select"
    let uiPickerCell = IndexPath(row: 3, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuOptions = [categoryToggleLabel] + Menu.shared.categoryOptions()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
        deleteDrinkButton.layer.cornerRadius = 4.0
        
        if let editDrink = editDrink {
            drinkNameField.text = editDrink.name
            categoryCell.detailTextLabel?.text = Menu.shared.selectionName(selection: editDrink.category)
            categoryPickerView.selectRow(editDrink.category, inComponent: 0, animated: false)
            favoriteSwitch.setOn(editDrink.favorite, animated: false)
            
            if editDrink.alcoholVolume != nil {
                drinkVolumeField.text = String(editDrink.alcoholVolume!)
            }
        } else {
            saveButton.isEnabled = false
            categoryCell.detailTextLabel?.text = categoryToggleLabel
            deleteDrinkButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSaveButton() {
        if drinkNameField.hasText == true && categoryCell.detailTextLabel?.text != categoryToggleLabel {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: - Actions
extension EditDrinkTableViewController {
    
    @IBAction func dismissEditScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameTextChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func nameTextReturned(_ sender: UITextField) {
        drinkNameField.resignFirstResponder()
    }
    
    @IBAction func volumeTextReturned(_ sender: UITextField) {
        drinkVolumeField.resignFirstResponder()
    }
    
    @IBAction func deleteDrink(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "BackToDrinkList", sender: self)
            }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Tableview
extension EditDrinkTableViewController {
    
    func togglePicker() -> CGFloat {
        switch pickerState {
        case .open:
            pickerState = .closed
            return 0.0
        case .closed:
            pickerState = .open
            return 160.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (uiPickerCell.section, uiPickerCell.row):
            return togglePicker()
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case [uiPickerCell.section, uiPickerCell.row - 1]:
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            return
        }
    }
}

//MARK: - Category Picker
extension EditDrinkTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menuOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryCell.detailTextLabel?.text = menuOptions[row]
        updateSaveButton()
    }
}
