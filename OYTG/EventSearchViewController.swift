//
//  nextViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 18..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit
class EventSearchViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,XMLParserDelegate, UITableViewDataSource{
    
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet weak var areaTextField : UITextField!
    @IBOutlet var detailAreaTextField: UITextField!
    @IBOutlet var startTextField: UITextField!
    @IBOutlet var endTextField: UITextField!
    var startDatePicker : UIDatePicker!
    var endDatePicker : UIDatePicker!
    //텍스트 필드를 완료 안누르고 다른 텍스트 필드를 누르면 적용되는걸 방지
    var selectRowForCity : Int = 0
    var selectRowForDetail = 0
    var selectRowForLargeThema = 0
    var selectRowForMidThema = 0
    var selectRowForSmallThema = 0
    var flagForPickup = 0
    var startDate = ""
    var endDate = ""
    
    
    var url : String = ""
    var page = 1
    var totalCount = 0
    @IBOutlet var tbData: UITableView!
    
    //xml파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    
    var element = NSString()
    //저장 문자열 변수
    
    var list : [TourIO] = {
        var datalist = [TourIO]()
        return datalist
    }()
    var tio : TourIO?
    let city = CityData()
    
    fileprivate var oldStoredCell:PKSwipeTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textfield 초기화
        areaTextField.text = "도/시 전체"
        detailAreaTextField.text = "시/구 전체"
        startTextField.text = "시작 날짜"
        endTextField.text = "종료 날짜"
        
        //어느 텍스트 필드가 클릭되었는지 flag변경하는 메소드 추가
        areaTextField.addTarget(self, action:
            #selector(EventSearchViewController.flagForPickupWithArea), for: UIControlEvents.touchDown)
        detailAreaTextField.addTarget(self,action:
            #selector(EventSearchViewController.flagForPickupWithDetail), for: UIControlEvents.touchDown)
        
        //날짜 바꾸면 눈에 보이게 텍스트 변경하는 method
        startTextField.addTarget(self, action: #selector(EventSearchViewController.flagForPickupWithStart), for: UIControlEvents.touchDown)
        endTextField.addTarget(self, action:
            #selector(EventSearchViewController.flagForPickupWithEnd), for: UIControlEvents.touchDown)
        
        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        
        //텍스트 필트 pickupView에 툴바 추가
        addToolBar(areaTextField,1)
        addToolBar(detailAreaTextField,2)
        addToolBar2(startTextField, 3)
        addToolBar2(endTextField, 4)
        
        moreBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //어느 텍스트 필드가 클릭되었는지 flag변경하는 메소드
    func flagForPickupWithArea(){
        flagForPickup = 1
    }
    func flagForPickupWithDetail(){
        flagForPickup = 2
    }
    func flagForPickupWithStart(){
        flagForPickup = 3
    }
    func flagForPickupWithEnd(){
        flagForPickup = 4
    }
    
    
    //pickupView에 적용되는 툴바 추가하는 메소드
    func addToolBar(_ textField : UITextField,_ flagCount : Int){
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        textField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.blue
        //toolBar.backgroundColor = UIColor.black
        
        
        let defaultButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TourSearchViewController.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TourSearchViewController.donePressed))
        //let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(nextViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 18)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.black
        if flagCount == 1{
            label.text = "도/시 선택"
        }else if flagCount == 2{
            label.text = "시/구 선택"
        }else if flagCount == 3{
            label.text = "시작 날짜"
        }else if flagCount == 4{
            label.text = "종료 날짜"
        }
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton],animated: true)
        
        textField.inputAccessoryView = toolBar
    }
    func addToolBar2(_ textField : UITextField,_ flagCount : Int){
        //pickerView.delegate = self
        
        if flagCount == 3{
            startDatePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = startDatePicker
        }else{
            endDatePicker.datePickerMode = UIDatePickerMode.date
            if startDate != ""{
                textField.inputView = endDatePicker
            }else{
                let pickerView = UIPickerView()
                pickerView.delegate = self
                textField.inputView = pickerView
            }
        }
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.blue
        //toolBar.backgroundColor = UIColor.black
        
        
        let defaultButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TourSearchViewController.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TourSearchViewController.donePressed))
        //let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(nextViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 18)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.black
        if flagCount == 1{
            label.text = "도/시 선택"
        }else if flagCount == 2{
            label.text = "시/구 선택"
        }else if flagCount == 3{
            label.text = "시작 날짜"
        }else if flagCount == 4{
            label.text = "종료 날짜"
        }
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton],animated: true)
        
        textField.inputAccessoryView = toolBar
    }

    //pickupView에서 취소버튼이 클릭되면 호출되는 메소드
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        if flagForPickup == 1{
            //areaTextField.text = "전체"
            areaTextField.resignFirstResponder()
        }else if flagForPickup == 2{
            //detailAreaTextField.text = "전체"
            detailAreaTextField.resignFirstResponder()
        }else if flagForPickup == 3{
            startTextField.resignFirstResponder()
        }else if flagForPickup == 4{
            endTextField.resignFirstResponder()
        }
    }
    //pickupView에서 완료버튼이 클릭되면 호출되는 메소드
    func donePressed(sender: UIBarButtonItem) {
        if flagForPickup == 1{
            //pickupView에서 행이 선택되면 row에 저장되었다가 완료버튼을 클릭하면 텍스트 필드의 행 번호가 바뀌면서 적용됨
            selectRowForDetail = 0
            let pickerView = UIPickerView()
            pickerView.delegate = self
            detailAreaTextField.inputView = pickerView
            areaTextField.text = city.cityOption[selectRowForCity]
            detailAreaTextField.text = city.detail[selectRowForCity][0]
            areaTextField.resignFirstResponder()
        }
        else if flagForPickup == 2{
            if selectRowForCity != 0{
                detailAreaTextField.text = city.detail[selectRowForCity][selectRowForDetail]
            }
            detailAreaTextField.resignFirstResponder()
        }else if flagForPickup == 3{
            let componenets = Calendar.current.dateComponents([.year, .month, .day], from: startDatePicker.date)
            let year = String(describing: componenets.year!)
            var month = ""
            var day = ""
            if componenets.month! < 10{
                month = "0"+String(describing: componenets.month!)
            }else{
                month = String(describing: componenets.month!)
            }
            if componenets.day! < 10{
                day = "0"+String(describing: componenets.day!)
            }else{
                day = String(describing: componenets.day!)
            }
            startDate = year+month+day
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            startTextField.text = dateFormatter.string(from: startDatePicker.date)

            startTextField.resignFirstResponder()
            
            endTextField.inputView = endDatePicker
        }else if flagForPickup == 4{
            let componenets = Calendar.current.dateComponents([.year, .month, .day], from: endDatePicker.date)
            let year = String(describing: componenets.year!)
            var month = ""
            var day = ""
            if componenets.month! < 10{
                month = "0"+String(describing: componenets.month!)
            }else{
                month = String(describing: componenets.month!)
            }
            if componenets.day! < 10{
                day = "0"+String(describing: componenets.day!)
            }else{
                day = String(describing: componenets.day!)
            }
            endDate = year+month+day
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            endTextField.text = dateFormatter.string(from: endDatePicker.date)

            endTextField.resignFirstResponder()
        }
    }
    
    //구성 요소의 설정 번호
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //구성 요소의 행 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if flagForPickup == 1{
            return city.cityOption.count
        }else if flagForPickup == 2{
            if selectRowForCity == 0{
                return 1
            }
            return city.detail[selectRowForCity].count
        }else if flagForPickup == 4{
            return 1
        }
        return 0
    }
    //각 행의 대한 제목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if flagForPickup == 1{
            return city.cityOption[row]
        }
        else if flagForPickup == 2{
            if selectRowForCity == 0{
                return city.detail[0][0]
            }
            return city.detail[selectRowForCity][row]
        }else if flagForPickup == 4{
            return "시작날짜를 선택해주세요."
        }
        return "no title"
    }
    //행이 선택될때 텍스트필드를 업데이트
    //문제점 - 피커뷰를 돌린후 다른 row의 양이 적은 피커뷰를 돌리지않고 그냥 완료만 했을시 row값이 갱신되지 않아 overflow발생
    //해결법 - if문으로 체크박스마다 row값을 각각 입력해준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //pickerTextField.text = pickOption[row]
        switch flagForPickup {
        case 1:
            selectRowForCity = row
        case 2:
            selectRowForDetail = row
        default:
            break
        }
    }
    @IBAction func onSearch(_ sender: Any) {
        url = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG"
        var cityString = ""
        var sigunString = ""
        var eventStartDate = ""
        var eventEndDate = ""
        self.list = []
        
        if selectRowForCity != 0{
            cityString = "&areaCode=" + String(city.cityCode[selectRowForCity])
            url += cityString
            if selectRowForDetail != 0{
                sigunString = "&sigunguCode=" + String(selectRowForDetail)
                url += sigunString
            }
        }
        if startDate != ""{
            eventStartDate = "&eventStartDate="+startDate
            url += eventStartDate
        }
        if endDate != ""{
            eventEndDate = "&eventEndDate="+endDate
            url += eventEndDate
        }
        beginParsing(url)
    }
    
    @IBAction func moreButton(_ sender: Any) {
        self.page += 1
        let url = self.url+"&pageNo="+String(self.page)
        beginParsing(url)
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
            tio?.whereAddress = true
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
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventSearchCell")! as! CustomTableViewCell
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if areaTextField.isEditing{
            areaTextField.resignFirstResponder()
        }
        if detailAreaTextField.isEditing{
            detailAreaTextField.resignFirstResponder()
        }
        if startTextField.isEditing{
            startTextField.resignFirstResponder()
        }
        if endTextField.isEditing{
            endTextField.resignFirstResponder()
        }
    }
}
