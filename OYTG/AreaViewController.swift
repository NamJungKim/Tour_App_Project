//
//  AreaViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 6. 6..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AreaViewController : UIViewController,XMLParserDelegate, UITableViewDataSource,CLLocationManagerDelegate{
    
    @IBOutlet var moreBtn: UIButton!
    
    @IBOutlet var keword: UITextField!
    
    var locationManager:CLLocationManager!
    
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var morLoding: UIActivityIndicatorView!
    //텍스트 필드를 완료 안누르고 다른 텍스트 필드를 누르면 적용되는걸 방지
    var url : String = ""
    var latitude = ""
    var longitude = ""
    var page = 1
    var totalCount = 0
    @IBOutlet var tbData: UITableView!
    
    @IBOutlet var searchBtn: UIButton!
    //xml파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    
    var element = NSString()
    //저장 문자열 변수
    
    var list : [TourIO] = {
        var datalist = [TourIO]()
        return datalist
    }()
    var tio : TourIO?
    
    fileprivate var oldStoredCell:PKSwipeTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        moreBtn.isHidden = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다
        if let coor = manager.location?.coordinate{
            latitude = String(coor.latitude)
            longitude = String(coor.longitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @IBAction func onSearch(_ sender: Any) {
        self.loading.startAnimating()
        self.searchBtn.isEnabled = false
        let when = DispatchTime.now() + 0.001 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
        self.url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG"
        self.url += "&mapX="+self.longitude
        self.url += "&mapY="+self.latitude
        if Int(self.keword.text!) == nil{
            self.showAlert(title: "입력 에러", message: "거리를 입력해주세요.")
            self.searchBtn.isEnabled = true
            self.loading.stopAnimating()
            return
        }
        self.url += "&radius="+self.keword.text!
        self.list = []
        self.keword.resignFirstResponder()
        self.beginParsing(self.url)
        if self.totalCount == 0{
            self.showAlert(title: "결 과", message: "검색 결과가 없습니다." )
        }
            self.searchBtn.isEnabled = true
            self.loading.stopAnimating()
        }
    }
    func showAlert(title: String,message: String){
        
        let alertController = UIAlertController(title: title+"\n", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func moreButton(_ sender: Any) {
        self.morLoding.startAnimating()
        self.moreBtn.isHidden = true
        let when = DispatchTime.now() + 0.001 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.page += 1
            let url = self.url+"&pageNo="+String(self.page)
            self.beginParsing(url)
            self.moreBtn.isEnabled = true
            self.morLoding.stopAnimating()
        }
    }
    
    
    
    func beginParsing(_ url : String){
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
        if self.list.count >= totalCount{
            self.moreBtn.isHidden = true
        }
        tbData!.reloadData()
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
            tio?.imageString = ""
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
            //tio?.thumbnailImage = UIImage(data: imageData)
            tio?.thumbnailImage = resizeImage(image: UIImage(data: imageData)!, targetSize: CGSize(width: 95.0, height: 60.0))
        }else if element.isEqual(to: "totalCount"){
            totalCount = Int(string)!
            if self.list.count <= totalCount{
                moreBtn.isHidden = false
            }
        }else if element.isEqual(to: "contentid"){
            tio?.contentid?.append(string)
            let count = UserDefaults.standard.integer(forKey: "count")
            for index in 0..<count{
                let i = String(index)
                let char : String = UserDefaults.standard.object(forKey: i) as! String
                if char.substring(to: char.index(char.endIndex, offsetBy: -5)) == string{
                    tio?.imageString = "yellow_star"
                    tio?.flag = true
                    break
                }
            }
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if self.list.count == 0{
            emptyLabel.text = "원하는 거리 반경(m)을 입력하시고\n검색버튼을 눌러주세요"
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
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaSearchCell")! as! CustomTableViewCell
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
            self.list[indexPath.row].thumbnailImage = resizeImage(image: UIImage(named: "noimage")!, targetSize: CGSize(width: 95.0, height: 60.0))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keword.resignFirstResponder()    }

}
