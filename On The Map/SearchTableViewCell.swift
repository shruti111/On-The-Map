//
//  SearchTableViewCell.swift
//  On The Map
//
//  Created by Shruti Pawar on 23/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {


 // Custom table view cell to display search results
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var visitButton: UIButton!
    
    // Configure UI
    
    override func awakeFromNib() {
        super.awakeFromNib()
         visitButton.layer.cornerRadius = 10.0
        visitButton.layer.borderColor = self.tintColor.CGColor
        visitButton.layer.borderWidth = 1.0
       
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Reset all data when cell is reused
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        locationLabel.text = ""
    }
}
