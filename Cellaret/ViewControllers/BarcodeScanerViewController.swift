//
//  BarcodeScanerViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 9/15/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit

class BarcodeScanerViewController: UIViewController {
    var editDrinkDelegate: EditDrinkDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Actions
extension BarcodeScanerViewController {
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NoBarcode(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueName.drinkForm.rawValue, sender: nil)
    }
}

// MARK: - Navigation
extension BarcodeScanerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueName.drinkForm.rawValue:
            let destinationViewController = segue.destination as! EditDrinkTableViewController
            destinationViewController.editDrinkDelegate = editDrinkDelegate
        default:
            return
        }
    }
}
