//
//  MyCustomCellTableViewCell.swift
//  PKSwipeTableViewCell
//
//  Created by Pradeep Kumar Yadav on 16/04/16.
//  Copyright © 2016 iosbucket. All rights reserved.
//

import UIKit

class CustomTableViewCell: PKSwipeTableViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var detail: UILabel!
    
    var viewCall = UIView()
    var btnCall : UIButton?
    var tio : TourIO?
    var list : [TourIO] = {
        var datalist = [TourIO]()
        return datalist
    }()

    var imageString = "black_star"
    
    @IBOutlet var tourImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRightViewInCell()
       
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ cellData:TourIO) {
        tio = TourIO()
        tio = cellData
        self.title.text = cellData.title
        self.detail.text = cellData.addr
        self.imageView?.image = cellData.thumbnailImage
        imageString = "black_star"
        if (tio?.imageString)! == "yellow_star"{
            imageString = (tio?.imageString)!
        }
        self.addRightViewInCell()

    }
    
    func addRightViewInCell() {
        
        //Create a view that will display when user swipe the cell in right
        
        //viewCall = 셀 버튼 색상
        viewCall.backgroundColor = UIColor.white
        //셀 버튼 크기
        viewCall.frame = CGRect(x: 0, y: 0,width: self.frame.height+20,height: self.frame.height)
        //Add a label to display the call text
        /*
        let lblCall = UILabel()
        lblCall.text  = "Call"
        lblCall.font = UIFont.systemFont(ofSize: 15.0)
        lblCall.textColor = UIColor.yellow
        lblCall.textAlignment = NSTextAlignment.center
        lblCall.frame = CGRect(x: 0,y: self.frame.height - 20,width: viewCall.frame.size.width,height: 20)
        //Add a button to perform the action when user will tap on call and add a image to display*/
        
        btnCall = UIButton(type: UIButtonType.custom)
        btnCall?.frame = CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40)
        
        
        btnCall?.setImage(UIImage(named: imageString), for: UIControlState())
        btnCall?.addTarget(self, action: #selector(CustomTableViewCell.callButtonClicked), for: UIControlEvents.touchUpInside)
        
        viewCall.addSubview(btnCall!)
                //Call the super addRightOptions to set the view that will display while swiping
        super.addRightOptionsView(viewCall)
    }
    
    
    
    func callButtonClicked(){
        //Reset the cell state and close the swipe action
        tio?.flag = !((tio?.flag)!)
        let count = UserDefaults.standard.integer(forKey: "count")
        if ((tio?.flag)! == true){
            UserDefaults.standard.set(tio?.contentid, forKey: String(count))
            UserDefaults.standard.set("0", forKey: String(count+1))
            UserDefaults.standard.set(count+1, forKey: "count")
            tio?.imageString = "yellow_star"
        }else{
            tio?.flag = false
            tio?.imageString = "black_star"
            for index in 1..<count{
                let char = UserDefaults.standard.object(forKey: String(index)) as! String
                if (tio?.contentid)! == char{
                    for i in index..<count{
                        let ch = UserDefaults.standard.object(forKey: String(i+1)) as! String
                        UserDefaults.standard.set(ch, forKey: String(i))
                    }
                    UserDefaults.standard.set(0, forKey: String(count))
                    UserDefaults.standard.set(count-1, forKey: "count")
                    btnCall?.setImage(UIImage(named: "black_star"), for: UIControlState())
                }
            }
        }
        btnCall?.setImage(UIImage(named: (tio?.imageString)!), for: UIControlState())
        self.resetCellState()
    }
    
}
