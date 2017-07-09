//
//  ThumbnailGridCell.swift
//  PDF-Demo
//
//  Created by lan on 2017/7/5.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit

class ThumbnailGridCell: UICollectionViewCell {
    
    open var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
