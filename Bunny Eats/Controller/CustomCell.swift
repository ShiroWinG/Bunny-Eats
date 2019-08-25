//
//  CustomCell.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/21/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
