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
    var imageID: String?
    var editDrinkDelegate: EditDrinkDelegate?
    var drinkViewDelegate: DrinkViewDelegate?
    weak var vc: EditDrinkTableViewController!
    
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
            } else {
                drinkImageView.image = addImagePlaceholder
            }
            
            drinkNameField.text = editDrink.name
            categoryCell.detailTextLabel?.text = Menu.shared.selectionName(selection: editDrink.category)
            categoryPickerView.selectRow(editDrink.category, inComponent: 0, animated: false)
            favoriteSwitch.setOn(editDrink.favorite, animated: false)
            drinkVolumeField.text = String(editDrink.alcoholVolume)
            
            print("Favorite: \(editDrink.favorite)")
            
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
    
    @IBAction func closeKeyboard(_ sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func deleteDrink(_ sender: UIButton) {
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: (nil))
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            self?.editDrinkDelegate?.editDrink(drink: (self?.editDrink)!, action: editAction.delete)
            
            if let imageID = self?.imageID {
                ImageController.shared.deleteImage(imageID: imageID)
            }
            
            self?.performSegue(withIdentifier: "BackToDrinkList", sender: self)
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
        impact.impactOccurred()
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
        let newDrink = Drink(
            imageId: imageID,
            image: checkImage(drinkImage: drinkImageView.image!),
            name: drinkNameField.text!,
            favorite: favoriteSwitch.isOn,
            category: categoryPickerView.selectedRow(inComponent: 0),
            alcoholVolume: checkVolume()
        )
        return newDrink
    }
    
    func checkImage(drinkImage: UIImage) -> UIImage? {
        return drinkImage == addImagePlaceholder ? nil : drinkImageView.image
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let thumbnail = ImageController.shared.createThumbnail(originalImage: capturedImage)
            let createImageId = ImageController.shared.saveImage(drinkImage: capturedImage)
            
            drinkImageView.image = thumbnail
            imageID = createImageId
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}
