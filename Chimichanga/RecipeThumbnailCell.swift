//
//  RecipeThumbnailCell.swift
//  Chimichanga
//
//  Created by Gordon on 2017-10-08.
//  Copyright © 2017 doxxx.net. All rights reserved.
//

import UIKit

class RecipeThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var thumbnail: UIImage? = nil {
        didSet {
            if thumbnail == nil {
                thumbnailImage.image = UIImage(named: "RecipePlaceholderIcon")
                thumbnailImage.contentMode = .scaleAspectFit
            } else {
                thumbnailImage.image = thumbnail
                thumbnailImage.contentMode = .scaleAspectFill
            }
        }
    }
}
