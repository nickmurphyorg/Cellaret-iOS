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
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var drinkVolumeField: UITextField!
    @IBOutlet weak var deleteDrinkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func dismissEditScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
