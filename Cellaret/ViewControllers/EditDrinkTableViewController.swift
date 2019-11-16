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
    @IBOutlet weak var drinkUPCField: UITextField!
    @IBOutlet weak var deleteDrinkButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var pickerState = pickerCell.open
    var menuOptions = [String]()
    var drinkData: Drink?
    var imageID: String?
    var editDrinkDelegate: EditDrinkDelegate?
    var drinkViewDelegate: DrinkViewDelegate?
    
    let categoryToggleLabel = "Select"
    let uiPickerCell = IndexPath(row: 3, section: 0)
    let impact = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuOptions = [categoryToggleLabel] + Menu.shared.categoryOptions()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
        deleteDrinkButton.layer.cornerRadius = 4.0
        
        // Populate Form
        if let drinkData = drinkData {
            drinkImageView.image = drinkData.image
            drinkNameField.text = drinkData.name
            categoryCell.detailTextLabel?.text = drinkData.category == 0 ? categoryToggleLabel : Menu.shared.selectionName(selection: drinkData.category)
            categoryPickerView.selectRow(drinkData.category, inComponent: 0, animated: false)
            favoriteSwitch.setOn(drinkData.favorite, animated: false)
            drinkVolumeField.text = String(drinkData.alcoholVolume)
            drinkUPCField.text = drinkData.upc ?? ""
            deleteDrinkButton.isHidden = drinkData.drinkId == nil
        }
        
        updateSaveButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Actions
extension EditDrinkTableViewController {
    @IBAction func saveDrink(_ sender: UIBarButtonItem) {
        guard let drinkData = drinkData else {
            dismiss(animated: true, completion: nil)
            
            return
        }
        
        if drinkData.drinkId != nil {
            editDrinkDelegate?.editDrink(drink: drinkData, action: .save)
            drinkViewDelegate?.updateView(editedDrink: drinkData)
        } else {
            editDrinkDelegate?.editDrink(drink: drinkData, action: .create)
        }

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissEditScreen(_ sender: UIBarButtonItem) {
        // Delete the image if one was uploaded
        if let imageID = imageID {
            ImageController.shared.deleteImage(imageID: imageID)
        }
        
        // Delete the image for an unsaved drink
        if drinkData?.drinkId == nil,
            let drinkImageID = drinkData?.imageId {
            ImageController.shared.deleteImage(imageID: drinkImageID)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Tableview
extension EditDrinkTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (uiPickerCell.section, uiPickerCell.row):
            return togglePicker()
        default:
            return UITableView.automaticDimension
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

//MARK: - Picture Selection
extension EditDrinkTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func addImage(sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            imagePicker.sourceType = .camera
            
            self?.present(imagePicker, animated: true, completion: nil)
        })
        
        let photosOption = UIAlertAction(title: "Photos", style: .default, handler: { [weak self] action in
            imagePicker.sourceType = .photoLibrary
            
            self?.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: (nil))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraOption)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(photosOption)
        }
        
        alert.addAction(cancel)
        
        imagePicker.delegate = self
        impact.impactOccurred()
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[.originalImage] as? UIImage {
            let drinkThumbnail = ImageController.shared.createImage(imageSize.small, for: capturedImage)
            let savedImageID = ImageController.shared.saveImage(drinkImage: capturedImage)
            
            // Delete the Previously Uploaded Image If Available
            if let previousImageID = imageID {
                ImageController.shared.deleteImage(imageID: previousImageID)
            }
            
            drinkImageView.image = drinkThumbnail
            imageID = savedImageID
            drinkData?.imageId = savedImageID
            drinkData?.image = drinkThumbnail
            
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Name Field
extension EditDrinkTableViewController {
    @IBAction func nameTextChanged(_ sender: UITextField) {
        drinkData?.name = sender.text ?? ""
        
        updateSaveButton()
    }
    
    @IBAction func nameTextReturned(_ sender: UITextField) {
        drinkNameField.resignFirstResponder()
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
        drinkData?.category = row
        
        updateSaveButton()
    }
}

//MARK: - Favorite Toggle
extension EditDrinkTableViewController {
    @IBAction func toggleFavoriteSwitch(_ sender: UISwitch) {
        drinkData?.favorite = sender.isOn
    }
}

//MARK: - Alcohol Volume Field
extension EditDrinkTableViewController {
    @IBAction func alcoholVolumeChanged(_ sender: UITextField) {
        guard let alcoholVolume = sender.text else {
            drinkData?.alcoholVolume = 0.0
            
            return
        }
        
        drinkData?.alcoholVolume = Double(alcoholVolume) ?? 0.0
    }
}

//MARK: - UPC Field
extension EditDrinkTableViewController {
    @IBAction func drinkUPCFieldChanged(_ sender: UITextField) {
        drinkData?.upc = sender.text ?? ""
    }
    
    @IBAction func drinkUPCFieldReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

//MARK: - Delete Button
extension EditDrinkTableViewController {
    @IBAction func deleteDrink(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: (nil))
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            guard let weakSelf = self else { return }
            
            weakSelf.editDrinkDelegate?.editDrink(drink: weakSelf.drinkData!, action: editAction.delete)
            
            // Delete the image if one was uplaoded
            if let imageID = weakSelf.imageID {
                ImageController.shared.deleteImage(imageID: imageID)
            }
            
            weakSelf.drinkData = nil
            weakSelf.performSegue(withIdentifier: segueName.backToDrinkList.rawValue, sender: self)
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
        
        impact.impactOccurred()
    }
}

//MARK: - Helper Methods
extension EditDrinkTableViewController {
    func updateSaveButton() {
        if drinkNameField.hasText == true && categoryCell.detailTextLabel?.text != categoryToggleLabel {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
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
}
