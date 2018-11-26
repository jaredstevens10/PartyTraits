//
//  CircularCollectionViewCell.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 12/9/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
    
    /*
    var imageName = "" {
        didSet {
            imageView!.image = UIImage(named: imageName)
        }
    }
    
    */
    @IBOutlet weak var updateTraitStatusBTN: UIButton!
    @IBOutlet weak var approvedStatusLBL: UILabel!
    @IBOutlet weak var traitDesc: UILabel!
    @IBOutlet weak var traitLevel: UILabel!
    
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var traitLBL: UILabel!
    
    @IBOutlet weak var imageView: UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView!.contentMode = .scaleAspectFill
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5)*self.bounds.height
    }
    
}
