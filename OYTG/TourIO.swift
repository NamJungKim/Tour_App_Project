//
//  TourIO.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 27..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit

class TourIO{
    var thumbnail : String?
    
    var title : String?
    
    var addr : String?
 
    var thumbnailImage : UIImage?
    
    var imageString : String?
    
    var contentid : String?
    
    var flag : Bool?
    
    var whereAddress = false //무장애인지,국문여행정보인지 무장애면 false 국문여행정보면 true
    
    init() {
        imageString = "black_star"
        flag = false
    }
}
