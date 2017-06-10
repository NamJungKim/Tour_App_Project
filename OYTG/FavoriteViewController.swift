//
//  FavoriteViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 29..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit

class FavoriteViewController : UITableViewController,XMLParserDelegate{
    
    var parser = XMLParser()
    var element = NSString()
    var tio : TourIO?
    let urlfalse : String = "http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/detailCommon?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&defaultYN=Y&firstImageYN=Y&addrinfoYN=Y&contentId="
    let urltrue : String = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&defaultYN=Y&firstImageYN=Y&addrinfoYN=Y&contentId="
    @IBOutlet var tbData: UITableView!
    var contentid : [String] = []
    var list : [TourIO] = {
        var datalist = [TourIO]()
        return datalist
    }()
    
    var presentCnt = 0
    
    var indicator = UIActivityIndicatorView()
    
    fileprivate var oldStoredCell:PKSwipeTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var color : UIColor!
        if UserDefaults.standard.object(forKey: "theme") != nil{
            let char = UserDefaults.standard.string(forKey: "theme")
            
            if char == "Emerald"{
                color = ThemeColor().emerald
                self.navigationController?.navigationBar.barTintColor = color //네이게이션바 배경색
                self.tabBarController?.tabBar.barTintColor = color //탭바 배경색
            }else if char == "Sky"{
                color = ThemeColor().hanuel
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }else if char == "LightGray"{
                color = ThemeColor().whiteGray
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }else if char == "Yellow"{
                color = ThemeColor().yellow
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }else if char == "Brown"{
                color = ThemeColor().brown
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }else if char == "White"{
                color = ThemeColor().white
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }else if char == "DarkGray"{
                color = ThemeColor().darkGray
                self.navigationController?.navigationBar.barTintColor = color
                self.tabBarController?.tabBar.barTintColor = color
            }
        }
        self.tabBarController?.tabBar.tintColor = UIColor.black //탭바아이템 클릭된 아이템 색
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.gray //탭바아이템 클릭안된 아이템 색
        self.activityIndicator()
        self.indicator.startAnimating()
        let when = DispatchTime.now() + 0.001 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.reload()
            self.indicator.stopAnimating()
        }
        if !UserDefaults.standard.bool(forKey: "iscount"){
            UserDefaults.standard.set(true, forKey: "iscount")
            UserDefaults.standard.set(0, forKey: "count")
        }
    }
    
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 177, y: 100, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentCnt != UserDefaults.standard.integer(forKey: "count"){
                self.indicator.startAnimating()
                list = []
                tbData.reloadData()
                let when = DispatchTime.now() + 0.001 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.reload()
                    self.indicator.stopAnimating()
                }
        }
    }
    
    func reload(){
        list = []
        let cnt = UserDefaults.standard.integer(forKey: "count")
        presentCnt = UserDefaults.standard.integer(forKey: "count")
        for index in 0..<cnt{
            let char = UserDefaults.standard.object(forKey: String(index)) as! String
            //뒤의 5글자가 false면 무장애 여행정보 검색 아니면 국문여행정보 검색
            if char.substring(to: char.index(char.startIndex, offsetBy: 5)) == "false"{
                beginParsing(urlfalse+char.substring(to: char.index(char.endIndex, offsetBy: -5)))
            }
            else{
                beginParsing(urltrue+char.substring(to: char.index(char.endIndex, offsetBy: -5)))
            }
        }
        tbData!.reloadData()
    }
    
    func beginParsing(_ url : String){
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName as NSString
        if( elementName as NSString).isEqual(to: "item"){
            tio = TourIO()
            tio?.title = String()
            tio?.title = ""
            tio?.addr = String()
            tio?.addr = ""
            tio?.thumbnail = String()
            tio?.thumbnail = ""
            tio?.thumbnailImage = UIImage()
            tio?.thumbnailImage = nil
            tio?.contentid = String()
            tio?.contentid = ""
            tio?.imageString = String()
            tio?.imageString = "yellow_star"
            tio?.flag = true
            tio?.eventStart = String()
            tio?.eventStart = ""
            tio?.eventEnd = String()
            tio?.eventEnd = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element.isEqual(to: "title"){
            tio?.title?.append(string)
        }else if element.isEqual(to: "addr1"){
            tio?.addr?.append(string)
        }else if element.isEqual(to: "firstimage2"){
            tio?.thumbnail?.append(string)
            let url : URL! = URL(string: (tio?.thumbnail!)!)
            let imageData = try! Data(contentsOf: url)
            tio?.thumbnailImage = UIImage(data: imageData)
            tio?.thumbnailImage = resizeImage(image: (tio?.thumbnailImage)!, targetSize: CGSize(width: 90.0, height: 60.0))
        }else if element.isEqual(to: "contentid"){
            tio?.contentid?.append(string)
        }else if element.isEqual(to: "eventstartdate"){
            tio?.eventStart?.append(string)
        }else if element.isEqual(to: "eventenddate"){
            tio?.eventEnd?.append(string)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        // Figure out what our orientation is, and use that to form the rectangle
        let newSize = CGSize(width: targetSize.width, height: targetSize.height)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?){
        if (elementName as NSString).isEqual(to: "item"){
            self.list.append(tio!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if self.list.count == 0{
            emptyLabel.text = "즐겨찾기 항목이 없습니다."
            emptyLabel.textColor = UIColor.lightGray
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.numberOfLines = 2
            self.tbData.backgroundView = emptyLabel
            self.tbData.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }else{
            emptyLabel.text = ""
            self.tbData.backgroundView = emptyLabel
            return self.list.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell")! as! CustomTableViewCell
        /*if cell.isEqual(NSNull.self) {
         cell = Bundle.main.loadNibNamed("tourSearchCell", owner: self, options: nil)?[0] as! CustomTableViewCell
         }
         let tio = self.list[indexPath.row]
         
         cell.textLabel?.text = tio.title
         cell.detailTextLabel?.text = tio.addr
         if tio.thumbnailImage != nil{
         cell.imageView?.image = tio.thumbnailImage
         }else{
         cell.imageView?.image = resizeImage(image: (cell.imageView?.image)!, targetSize: CGSize(width: 90.0, height: 60.0))
         }*/
        cell.delegate = self
        cell.configureCell(self.list[indexPath.row])
        if self.list[indexPath.row].thumbnailImage == nil{
            self.list[indexPath.row].thumbnailImage = resizeImage(image: UIImage(named: "noimage")!, targetSize: CGSize(width: 90.0, height: 60.0))
        }
        cell.tourImage.image = self.list[indexPath.row].thumbnailImage
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func swipeBeginInCell(_ cell: PKSwipeTableViewCell) {
        oldStoredCell = cell
    }
    
    func swipeDoneOnPreviousCell() -> PKSwipeTableViewCell? {
        guard let cell = oldStoredCell else {
            return nil
        }
        return cell
    }

    @IBAction func refreshBtn(_ sender: Any) {
        reload()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCommon"{
            if let cell = sender as? CustomTableViewCell {
                let indexPath = tbData.indexPath(for: cell)
                let tio = list[(indexPath?.row)!]
                
                if let commonDetailViewController = segue.destination as? CommonDetailViewController{
                    commonDetailViewController.tio = tio
                }
            }
        }
    }
}
