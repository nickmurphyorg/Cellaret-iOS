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
    var editDrinkDelegate: EditDrinkDelegate?
    var drinkViewDelegate: DrinkViewDelegate?
    
    let addImagePlaceholder = UIImage(named: "Add Image Placeholder")
    let categoryToggleLabel = "Select"
    let uiPickerCell = IndexPath(row: 3, section: 0)
    let impact = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuOptions = [categoryToggleLabel] + Menu.shared.categoryOptions()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
        deleteDrinkButton.layer.cornerRadius = 4.0
        
        if let editDrink = editDrink {
            let drinkImage = editDrink.image
            
            if let drinkImage = drinkImage {
                drinkImageView.image = drinkImage
            }
            
            drinkNameField.text = editDrink.name
            categoryCell.detailTextLabel?.text = Menu.shared.selectionName(selection: editDrink.category)
            categoryPickerView.selectRow(editDrink.category, inComponent: 0, animated: false)
            favoriteSwitch.setOn(editDrink.favorite, animated: false)
            
            print("Favorite: \(editDrink.favorite)")
            
            if editDrink.alcoholVolume != nil {
                drinkVolumeField.text = String(editDrink.alcoholVolume!)
            }
        } else {
            drinkImageView.image = addImagePlaceholder
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
    
    @IBAction func closeKeyboard(_ sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func deleteDrink(_ sender: UIButton) {
        
        impact.impactOccurred()
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                self.editDrinkDelegate?.editDrink(drink: self.editDrink!, action: editAction.delete)
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
        
        switch indexPath {
        case [uiPickerCell.section, uiPickerCell.row - 1]:
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            return
        }
        
        self.view.endEditing(true)
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

//MARK: - Saving Drink
extension EditDrinkTableViewController {
    
    @IBAction func saveDrink(_ sender: UIBarButtonItem) {
        editDrinkDelegate?.editDrink(drink: createDrink(), action: editAction.save)
        drinkViewDelegate?.updateView(editedDrink: createDrink())
        dismiss(animated: true, completion: nil)
    }
    
    func createDrink() -> Drink {
        
        let drinkImage = { () -> UIImage? in
            if self.drinkImageView.image == self.addImagePlaceholder {
                return nil
            } else {
                return self.drinkImageView.image
            }
        }
        
        let newDrink = Drink(
            image: drinkImage(),
            name: drinkNameField.text!,
            favorite: favoriteSwitch.isOn,
            category: categoryPickerView.selectedRow(inComponent: 0),
            alcoholVolume: checkVolume()
        )
        return newDrink
    }

    func checkVolume() -> Double {
        if drinkVolumeField.hasText == true {
            let volume = drinkVolumeField.text!
            return Double(volume)!
        } else {
            return 0.0
        }
    }
}

//MARK: - Picture Selection
extension EditDrinkTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addImage(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        impact.impactOccurred()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            drinkImageView.image = capturedImage
            dismiss(animated: true, completion: nil)
        }
    }
}
