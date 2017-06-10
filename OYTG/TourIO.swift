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
    
    var contentTypeId : String?
    var overview : String?
    var tel : String?
    var modifiedYear : String?
    var modifiedMonth : String?
    var modifiedDay : String?
    var modifiedHour : String?
    var modifiedMin : String?
    var modifiedSec : String?
    var hompage : String?
    var latitude : String?
    var longitude : String?
    var cat1 : String?
    var cat2 : String?
    var cat3 : String?
    
    var eventEnd : String?
    var eventStart : String?
 
    init() {
        imageString = "black_star"
        flag = false
    }
}
