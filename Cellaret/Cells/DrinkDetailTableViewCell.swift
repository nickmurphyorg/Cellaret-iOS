//
//  DrinkDetailTableViewCell.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/31/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit

class DrinkDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var content: DrinkDetail? {
        didSet {
            if let content = content {
                titleLabel.text = content.title
                contentLabel.text = content.content
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
