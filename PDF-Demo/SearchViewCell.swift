//
//  SearchViewCell.swift
//  PDF-Demo
//
//  Created by lan on 2017/7/5.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var resultTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
