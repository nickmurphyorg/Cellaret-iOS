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
    
    var pickerState = pickerCell.open
    var menuOptions = [String]()
    var editDrink: Drink?
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
        
        if let editDrink = editDrink {
            drinkImageView.image = editDrink.image
            drinkNameField.text = editDrink.name
            categoryCell.detailTextLabel?.text = Menu.shared.selectionName(selection: editDrink.category)
            categoryPickerView.selectRow(editDrink.category, inComponent: 0, animated: false)
            favoriteSwitch.setOn(editDrink.favorite, animated: false)
            drinkVolumeField.text = String(editDrink.alcoholVolume)
        } else {
            drinkImageView.image = nil
            saveButton.isEnabled = false
            categoryCell.detailTextLabel?.text = categoryToggleLabel
            deleteDrinkButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Actions
extension EditDrinkTableViewController {
    @IBAction func saveDrink(_ sender: UIBarButtonItem) {
        let drinkIdentifier = editDrink != nil ? editDrink!.drinkId : nil
        let imageIdentifier = imageID != nil ? imageID! : editDrink?.imageId
        
        let drinkData = Drink.init(drinkId: drinkIdentifier, imageId: imageIdentifier, image: drinkImageView.image, name: drinkNameField.text ?? "", favorite: favoriteSwitch.isOn, category: categoryPickerView.selectedRow(inComponent: 0), alcoholVolume: returnAlcoholVolume())
        
        if editDrink != nil {
            editDrinkDelegate?.editDrink(drink: drinkData, action: editAction.save)
            drinkViewDelegate?.updateView(editedDrink: drinkData)
        } else {
            editDrinkDelegate?.editDrink(drink: drinkData, action: editAction.create)
        }
        
        editDrink = nil
        imageID = nil
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissEditScreen(_ sender: UIBarButtonItem) {
        // Delete the image if one was uploaded
        if let imageID = imageID {
            ImageController.shared.deleteImage(imageID: imageID)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameTextChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func nameTextReturned(_ sender: UITextField) {
        drinkNameField.resignFirstResponder()
    }
    
    @IBAction func deleteDrink(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: (nil))
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            guard let weakSelf = self else { return }
            
            weakSelf.editDrinkDelegate?.editDrink(drink: weakSelf.editDrink!, action: editAction.delete)
            
            // Delete the image if one was uplaoded
            if let imageID = weakSelf.imageID {
                ImageController.shared.deleteImage(imageID: imageID)
            }
            
            weakSelf.editDrink = nil
            weakSelf.performSegue(withIdentifier: segueName.backToDrinkList.rawValue, sender: self)
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
        
        impact.impactOccurred()
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
            let thumbnail = ImageController.shared.createThumbnail(originalImage: capturedImage)
            let createImageId = ImageController.shared.saveImage(drinkImage: capturedImage)
            
            drinkImageView.image = thumbnail
            imageID = createImageId
            
            dismiss(animated: true, completion: nil)
        }
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
    
    func returnAlcoholVolume() -> Double {
        if drinkVolumeField.hasText {
            let volume = drinkVolumeField.text!
            
            return Double(volume)!
        } else {
            return 0.0
        }
    }
}
