//
//  HeaderCellTableViewCell.swift
//  OYTG
//
//  Created by 김남정 on 2017. 6. 7..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit

class HeaderCellTableViewCell: UITableViewCell {
    
    var headerCellSection:Int?
    
    
    @IBOutlet var themeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 }
