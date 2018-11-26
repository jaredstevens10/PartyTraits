//
//  BasicCell.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 2/12/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var traitImageView: UIImageView!

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var levelLBL: UILabel!
    
    @IBOutlet weak var playerTurnLBL: UILabel!
    @IBOutlet weak var playerNumberLBL: UILabel!
    
    @IBOutlet weak var viewTraitBTN: UIButton!
    
    @IBOutlet weak var editPlayerBTN: UIButton!
    @IBOutlet weak var sendTextBTN: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
