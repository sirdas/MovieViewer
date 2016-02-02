//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Reis Sirdas on 1/25/16.
//  Copyright © 2016 sirdas. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        super.setSelected(false, animated: true)

        // Configure the view for the selected state
    }

}
