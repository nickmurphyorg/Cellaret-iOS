//
//  DrinkTitleTableViewCell.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/31/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    let favoriteStar = UIImage(named: "Star")
    
    var content: DrinkTitle? {
        didSet {
            if let content = content {
                drinkNameLabel.text = content.title
                favoriteImageView.image = content.favorite ? favoriteStar : nil
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
