//
//  CommonDetailViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 6. 10..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit
import MapKit
class CommonDetailViewController : UIViewController,XMLParserDelegate, MKMapViewDelegate{
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var detailView: UITextView!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var tio = TourIO()
    var imageUrl1 = "http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/detailImage?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&contentId="
    var imageUrl2 = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailImage?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&contentId="
    var url1 = "http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/detailCommon?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&defaultYN=Y&mapinfoYN=Y&catcodeYN=Y&firstImageYN=Y&addrinfoYN=Y&catcodeYN=Y&overviewYN=Y&contentId="
    var url2 = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&defaultYN=Y&mapinfoYN=Y&catcodeYN=Y&firstImageYN=Y&addrinfoYN=Y&catcodeYN=Y&overviewYN=Y&contentId="
    var eventurl = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailIntro?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&contentTypeId=15&contentId="
    
    var pageImages : [UIImage] = []
    var pageViews : [UIImageView?] = []
    
    var locationManager : CLLocationManager = CLLocationManager()
    let regionRadius : CLLocationDistance = 5000
    
    var parser = XMLParser()
    var element = NSString()
    let theme = ThemaData()
    var color = UIColor()
    
    var startYear = ""
    var endYear = ""
    var startMonth = ""
    var endMonth = ""
    var startDay = ""
    var endDay = ""
    
    var eventFlag = false
    var imageFlag = false
    var viewFlag = false
    
    override func viewDidLoad() {
        if tio.whereAddress == true{
            url1 += tio.contentid!
            beginParsing(url1)
        }else{
            url2 += tio.contentid!
            beginParsing(url2)
        }
        titleView.text = tio.title!
        textView.text.append(tio.addr! + "\n")
        if tio.tel! != ""{
            textView.text.append(tio.tel! + "\n")
        }else{
            textView.text.append("전화번호 : 없음\n")
        }
        getTheme()
        textView.text.append("테마 : "+tio.cat1!+" -> "+tio.cat2!+" -> "+tio.cat3!+"\n")
        let overtext = tio.overview!
        var replacetext = overtext.replacingOccurrences(of: "<br/>", with: "")
        replacetext = replacetext.replacingOccurrences(of: "<br />", with: "")
        replacetext = replacetext.replacingOccurrences(of: "<br>", with: "")
        replacetext = replacetext.replacingOccurrences(of: "<strong>", with: "")
        replacetext = replacetext.replacingOccurrences(of: "</strong>", with: "")
        detailView.text.append(replacetext)
        
        if tio.contentTypeId == "15"{
            eventurl += tio.contentid!
            eventFlag = true
            beginParsing(eventurl)
            eventFlag = false
            
            var temp = tio.eventStart!
            startYear = temp.substring(to: temp.index(temp.startIndex, offsetBy: 4))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 4))
            startMonth = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
            startDay = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
            
            temp = tio.eventEnd!
            endYear = temp.substring(to: temp.index(temp.startIndex, offsetBy: 4))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 4))
            endMonth = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
            endDay = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2))
            temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
            textView.text.append("행사 날짜 : "+startYear+"/"+startMonth+"/"+startDay+" ~ "+endYear+"/"+endMonth+"/"+endDay)
        }else{
            textView.text.append("최종 수정일 : "+tio.modifiedYear!+tio.modifiedMonth!+tio.modifiedDay!+tio.modifiedHour!+tio.modifiedMin!+tio.modifiedSec!)
        }
        
        
        changeColor()
        //맵의 초기 화면 중앙을 잡음
        let initialLocation = CLLocation(latitude: Double(tio.latitude!)!, longitude: Double(tio.longitude!)!)
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        //핀 추가
        let annotation = MKPointAnnotation()
        annotation.title = tio.title!
        annotation.subtitle = tio.addr!
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(tio.latitude!)!, longitude: Double(tio.longitude!)!)
        mapView.addAnnotation(annotation)
        
        loading.startAnimating()
        //이미지 로딩
        
        let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewFlag == false{
        self.imageFlag = true
        if self.tio.whereAddress == true{
            self.imageUrl1 += self.tio.contentid!
            self.imageUrl1 += "&contentTypeId="+self.tio.contentTypeId!
            self.beginParsing(self.imageUrl1)
        }else{
            self.imageUrl2 += self.tio.contentid!
            self.imageUrl2 += "&contentTypeId="+self.tio.contentTypeId!
            self.beginParsing(self.imageUrl2)
        }
        self.imageFlag = false
        if self.pageImages.count == 0{
            let noimage = self.resizeImage(image: UIImage(named: "noimage")!, targetSize: CGSize(width: 343.0, height: 224.0))
            self.pageImages.append(noimage)
        }
        
        
        
        //스크롤뷰와 페이지컨트롤 초기화
        let pageCount = self.pageImages.count
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pageCount
        for _ in 0..<pageCount{
            self.pageViews.append(nil)
        }
        let pagesScrollViewSize = self.scrollView.frame.size
        self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
        self.loadVisiblepage()
        self.loading.stopAnimating()
        
        self.viewFlag = true
        }
    }
    
    func loadPage(_ page: Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        
        if pageViews[page] != nil{
            //pageView.removeFromSuperview()
            //pageViews[page] = nil
        }else{
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(_ page:Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        
        if let pageView = pageViews[page]{
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblepage(){
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for index in 0..<firstPage+1{
            purgePage(index)
        }
        
        for index in firstPage...lastPage{
            loadPage(index)
        }
        
        for index in lastPage+1..<pageImages.count+1{
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblepage()
    }
    
    
    func changeColor(){
        if UserDefaults.standard.object(forKey: "theme") != nil{
            let char = UserDefaults.standard.string(forKey: "theme")
            
            if char == "Emerald"{
                color = ThemeColor().emerald
                self.navigationView.backgroundColor = color //네이게이션바 배경색
            }else if char == "Sky"{
                color = ThemeColor().hanuel
                self.navigationView.backgroundColor = color
            }else if char == "LightGray"{
                color = ThemeColor().whiteGray
                self.navigationView.backgroundColor = color
            }else if char == "Yellow"{
                color = ThemeColor().yellow
                self.navigationView.backgroundColor = color
            }else if char == "Brown"{
                color = ThemeColor().brown
                self.navigationView.backgroundColor = color
            }else if char == "White"{
                color = ThemeColor().white
                self.navigationView.backgroundColor = color
            }else if char == "DarkGray"{
                color = ThemeColor().darkGray
                self.navigationView.backgroundColor = color
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*0.1, regionRadius*0.1)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func beginParsing(_ url : String){
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func getTheme(){
        var largeIndex = 0
        var midIndex = 0
        var smallIndex = 0
        var index = 0
        
        for item in theme.largeCode{
            if tio.cat1! == item{
                largeIndex = index
                break
            }
            index += 1
        }
        index = 0
        for item in theme.midCode[largeIndex]{
            if tio.cat2!.isEqual(item){
                midIndex = index
                break
            }
            index += 1
        }
        index = 0
        for item in theme.smallCode[largeIndex][midIndex]{
            if tio.cat3!.isEqual(item){
                smallIndex = index
                break
            }
            index += 1
        }
        tio.cat1 = theme.largeThema[largeIndex]
        tio.cat2 = theme.midThema[largeIndex][midIndex]
        tio.cat3 = theme.smallThema[largeIndex][midIndex][smallIndex]
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName as NSString
        if( elementName as NSString).isEqual(to: "item"){
            if eventFlag == true{
                tio.eventStart = String()
                tio.eventStart = ""
                tio.eventEnd = String()
                tio.eventEnd = ""
            }else if imageFlag == true{
                
            }else{
                tio.title = String()
                tio.title = ""
                tio.addr = String()
                tio.addr = ""
                tio.thumbnail = String()
                tio.thumbnail = ""
                tio.thumbnailImage = UIImage()
                tio.thumbnailImage = nil
                tio.contentid = String()
                tio.contentid = ""
                tio.imageString = String()
                tio.imageString = ""
                tio.contentTypeId = String()
                tio.contentTypeId = ""
                tio.hompage = String()
                tio.hompage = ""
                tio.latitude = String()
                tio.latitude = ""
                tio.longitude = String()
                tio.longitude = ""
                tio.modifiedDay = String()
                tio.modifiedDay = ""
                tio.modifiedMin = String()
                tio.modifiedMin = ""
                tio.modifiedSec = String()
                tio.modifiedSec = ""
                tio.modifiedHour = String()
                tio.modifiedHour = ""
                tio.modifiedYear = String()
                tio.modifiedYear = ""
                tio.modifiedMonth = String()
                tio.modifiedMonth = ""
                tio.overview = String()
                tio.overview = ""
                tio.tel = String()
                tio.tel = ""
                tio.contentTypeId = String()
                tio.contentTypeId = ""
                tio.cat1 = String()
                tio.cat1 = ""
                tio.cat2 = String()
                tio.cat2 = ""
                tio.cat3 = String()
                tio.cat3 = ""

            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if eventFlag == true{
            if element.isEqual(to: "eventstartdate"){
                tio.eventStart?.append(string)
            }else if element.isEqual(to: "eventenddate"){
                tio.eventEnd?.append(string)
            }
        }else if imageFlag == true{
            if element.isEqual(to: "originimgurl"){
                let image = URL(string: string)
                let imageData = try! Data(contentsOf: image!)
                pageImages.append(resizeImage(image: UIImage(data: imageData)!, targetSize: CGSize(width: 343.0, height: 220.0)))
            }
        }else{
            if element.isEqual(to: "title"){
                tio.title = string
            }else if element.isEqual(to: "addr1"){
                tio.addr = "주소 : "+string
            }else if element.isEqual(to: "firstimage"){
                tio.thumbnail?.append(string)
                let url : URL! = URL(string: (tio.thumbnail!))
                let imageData = try! Data(contentsOf: url)
                tio.thumbnailImage = self.resizeImage(image: UIImage(data: imageData)!, targetSize: CGSize(width: 343.0, height: 220.0))
                pageImages.append(tio.thumbnailImage!)
            }else if element.isEqual(to: "contentid"){
                tio.contentid?.append(string)
                let count = UserDefaults.standard.integer(forKey: "count")
                tio.imageString = "black_star"
                for index in 0..<count{
                    let i = String(index)
                    let char : String = UserDefaults.standard.object(forKey: i) as! String
                    if char.substring(to: char.index(char.endIndex, offsetBy: -5)) == string{
                        tio.imageString = "yellow_star"
                        tio.flag = true
                        break
                    }
                }
                //btnCall?.setImage(UIImage(named: (tio?.imageString)!), for: UIControlState())
                imageButton.setBackgroundImage(UIImage(named: tio.imageString!), for: UIControlState())
            }else if element.isEqual(to: "homepage"){
                tio.hompage?.append(string)
            }else if element.isEqual(to: "modifiedtime"){
                var temp = string
                tio.modifiedYear = temp.substring(to: temp.index(temp.startIndex, offsetBy: 4)) + "년 "
                temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 4))
                tio.modifiedMonth = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2)) + "월 "
                temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
                tio.modifiedDay = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2)) + "일 "
                temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
                tio.modifiedHour = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2)) + "시 "
                temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
                tio.modifiedMin = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2)) + "분 "
                temp = temp.substring(from: temp.index(temp.startIndex, offsetBy: 2))
                tio.modifiedSec = temp.substring(to: temp.index(temp.startIndex, offsetBy: 2)) + "초 "
                
            }else if element.isEqual(to: "overview"){
                tio.overview!.append(string)
            }else if element.isEqual(to: "tel"){
                tio.tel = "전화번호 : " + string
            }else if element.isEqual(to: "mapx"){
                tio.longitude?.append(string)
            }else if element.isEqual(to: "mapy"){
                tio.latitude?.append(string)
            }else if element.isEqual(to: "contenttypeid"){
                tio.contentTypeId?.append(string)
            }else if element.isEqual(to: "cat1"){
                tio.cat1?.append(string)
            }else if element.isEqual(to: "cat2"){
                tio.cat2?.append(string)
            }else if element.isEqual(to: "cat3"){
                tio.cat3?.append(string)
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
        
    @IBAction func onImageButton(_ sender: Any) {
        let count = UserDefaults.standard.integer(forKey: "count")
        tio.flag! = !tio.flag!
        if ((tio.flag)! == true){
            if tio.whereAddress == false{
                UserDefaults.standard.set((tio.contentid)!+"false", forKey: String(count))
            }else{
                UserDefaults.standard.set((tio.contentid)!+"+true", forKey: String(count))
            }
            UserDefaults.standard.set(count+1, forKey: "count")
            tio.imageString = "yellow_star"
        }else{
            tio.imageString = "black_star"
            for index in 0..<count{
                let char = UserDefaults.standard.object(forKey: String(index)) as! String
                if (tio.contentid)! == char.substring(to: char.index(char.endIndex, offsetBy: -5)){
                    for i in index+1..<count{
                        let ch = UserDefaults.standard.object(forKey: String(i)) as! String
                        UserDefaults.standard.set(ch, forKey: String(i-1))
                    }
                    UserDefaults.standard.set(0, forKey: String(count))
                    UserDefaults.standard.set(count-1, forKey: "count")
                }
            }
        }
        imageButton.setBackgroundImage(UIImage(named: tio.imageString!), for: UIControlState())
    }
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
