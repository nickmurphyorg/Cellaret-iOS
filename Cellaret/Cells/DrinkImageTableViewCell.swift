//
//  DrinkImageTableViewCell.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/31/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkImageTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    
    weak var drinkImageTapDelegate: DrinkImageTapDelegate?
    var content: DrinkImage? {
        didSet {
            if let content = content {
                drinkImageView.image = content.image
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
