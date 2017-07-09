//
//  OulineTableViewCell.swift
//  PDF-Demo
//
//  Created by lan on 2017/6/27.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit

class OulineTableViewCell: UITableViewCell {

    @IBOutlet weak var leftOffset: NSLayoutConstraint!
    @IBOutlet open weak var openBtn: UIButton!
    @IBOutlet open weak var textLab: UILabel!
    @IBOutlet weak var pageLab: UILabel!
    
    var openBtnClick:((_ sender: UIButton) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if indentationLevel == 0 {
            textLab.font = UIFont.systemFont(ofSize: 17 )
        } else {
            textLab.font = UIFont.systemFont(ofSize: 15)
        }
        leftOffset.constant = CGFloat(indentationWidth * CGFloat(indentationLevel))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func openBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        openBtnClick?(sender)
    }
    
}
