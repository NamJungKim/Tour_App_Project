//
//  nextViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 18..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit
class TourSearchViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,XMLParserDelegate, UITableViewDataSource{
    
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet weak var areaTextField : UITextField!
    @IBOutlet var detailAreaTextField: UITextField!
    @IBOutlet var largeThemaTextField: UITextField!
    @IBOutlet var midThemaTextField: UITextField!
    @IBOutlet var smallThemaTextField: UITextField!
    @IBOutlet var keword: UITextField!
    @IBOutlet var loading: UIActivityIndicatorView!

    @IBOutlet var searchBtn: UIButton!
    
    @IBOutlet var moreLoding: UIActivityIndicatorView!
    let city = CityData()
    let thema = ThemaData()
    
    //텍스트 필드를 완료 안누르고 다른 텍스트 필드를 누르면 적용되는걸 방지
    var selectRowForCity : Int = 0
    var selectRowForDetail = 0
    var selectRowForLargeThema = 0
    var selectRowForMidThema = 0
    var selectRowForSmallThema = 0
    var flagForPickup = 0
    
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
    
    let refreshControl = UIRefreshControl()

    
    fileprivate var oldStoredCell:PKSwipeTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        //textfield 초기화
        areaTextField.text = "도/시 전체"
        detailAreaTextField.text = "시/구 전체"
        largeThemaTextField.text = "대분류 전체"
        midThemaTextField.text = "중분류 전체"
        smallThemaTextField.text = "소분류 전체"
        //어느 텍스트 필드가 클릭되었는지 flag변경하는 메소드 추가
        areaTextField.addTarget(self, action: #selector(TourSearchViewController.flagForPickupWithArea), for: UIControlEvents.touchDown)
        detailAreaTextField.addTarget(self,action: #selector(TourSearchViewController.flagForPickupWithDetail), for: UIControlEvents.touchDown)
        largeThemaTextField.addTarget(self, action: #selector(TourSearchViewController.flagForPickupWithLarge), for: UIControlEvents.touchDown)
        midThemaTextField.addTarget(self, action: #selector(TourSearchViewController.flagForPickupWithMid), for: UIControlEvents.touchDown)
        smallThemaTextField.addTarget(self, action: #selector(TourSearchViewController.flagForPickupWithSmall), for: UIControlEvents.touchDown)
        //텍스트 필트 pickupView에 툴바 추가
        addToolBar(areaTextField,1)
        addToolBar(detailAreaTextField,2)
        addToolBar(largeThemaTextField, 3)
        addToolBar(midThemaTextField, 4)
        addToolBar(smallThemaTextField, 5)
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
    func flagForPickupWithLarge(){
        flagForPickup = 3
    }
    func flagForPickupWithMid(){
        flagForPickup = 4
    }
    func flagForPickupWithSmall(){
        flagForPickup = 5
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
            label.text = "대분류 선택"
        }else if flagCount == 4{
            label.text = "중분류 선택"
        }else if flagCount == 5{
            label.text = "소분류 선택"
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
            largeThemaTextField.resignFirstResponder()
        }else if flagForPickup == 4{
            midThemaTextField.resignFirstResponder()
        }else if flagForPickup == 5{
            smallThemaTextField.resignFirstResponder()
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
            selectRowForMidThema = 0
            selectRowForSmallThema = 0
            let pickerView = UIPickerView()
            pickerView.delegate = self
            midThemaTextField.inputView = pickerView
            smallThemaTextField.inputView = pickerView
            largeThemaTextField.resignFirstResponder()
            largeThemaTextField.text = thema.largeThema[selectRowForLargeThema]
            midThemaTextField.text = thema.midThema[selectRowForLargeThema][0]
            smallThemaTextField.text = thema.smallThema[selectRowForLargeThema][selectRowForMidThema][0]
        }else if flagForPickup == 4{
            if selectRowForLargeThema != 0{
                selectRowForSmallThema = 0
                let pickerView = UIPickerView()
                pickerView.delegate = self
                smallThemaTextField.inputView = pickerView
                midThemaTextField.text = thema.midThema[selectRowForLargeThema][selectRowForMidThema]
                smallThemaTextField.text = thema.smallThema[selectRowForLargeThema][selectRowForMidThema][0]
            }
            midThemaTextField.resignFirstResponder()
        }else if flagForPickup == 5{
            if selectRowForLargeThema != 0 && selectRowForMidThema != 0{
                smallThemaTextField.text = thema.smallThema[selectRowForLargeThema][selectRowForMidThema][selectRowForSmallThema]
            }
            smallThemaTextField.resignFirstResponder()

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
        }else if flagForPickup == 3{
            return thema.largeThema.count
        }else if flagForPickup == 4{
            if selectRowForLargeThema == 0{
                return 1
            }
            return thema.midThema[selectRowForLargeThema].count
        }else if flagForPickup == 5{
            if selectRowForLargeThema == 0 || selectRowForMidThema == 0{
                return 1
            }
            return thema.smallThema[selectRowForLargeThema][selectRowForMidThema].count
        }else{
            return 0
        }
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
        }
        else if flagForPickup == 3{
            return thema.largeThema[row]
        }else if flagForPickup == 4{
            if selectRowForLargeThema == 0 {
                return thema.midThema[selectRowForLargeThema][0]
            }
            return thema.midThema[selectRowForLargeThema][row]
        }else if flagForPickup == 5{
            if selectRowForLargeThema == 0 || selectRowForMidThema == 0{
                return thema.smallThema[selectRowForLargeThema][selectRowForMidThema][0]
            }
            return thema.smallThema[selectRowForLargeThema][selectRowForMidThema][row]
        }else{
            return ""
        }
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
        case 3:
            selectRowForLargeThema = row
        case 4:
            selectRowForMidThema = row
        case 5:
            selectRowForSmallThema = row
        default:
            break
        }
    }
    @IBAction func onSearch(_ sender: Any) {
        self.loading.startAnimating()
        self.searchBtn.isEnabled = false
        let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            var cityString = ""
            var sigunString = ""
            var largeThemaString = ""
            var midThemaString = ""
            var smallThemaString = ""
            self.list = []
            let kewordString = "&keyword="+self.keword.text!
            
            if kewordString == "&keyword="{
                self.url = "http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/areaBasedList?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&numOfRows=10"
            }else{
                self.url = "http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/searchKeyword?serviceKey=ex%2FH5GN%2BB21X%2B87vYrBxFYdAWSz1cWxgQQDDW9lEeckwagijgq6opR6MlhGxE%2Bth5ydwv1SV%2FVhyd1FpFOlC8g%3D%3D&MobileOS=IOS&MobileApp=OYTG&numOfRows=10"
                let param = kewordString
                let encodedParam = param.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                self.url += encodedParam!
            }
            if self.selectRowForCity != 0{
                cityString = "&areaCode=" + String(self.city.cityCode[self.selectRowForCity])
                self.url += cityString
                if self.selectRowForDetail != 0{
                    sigunString = "&sigunguCode=" + String(self.selectRowForDetail)
                    self.url += sigunString
                }
            }
            if self.selectRowForLargeThema != 0{
                largeThemaString = "&cat1=" + String(self.thema.self.largeCode[self.selectRowForLargeThema])
                self.url += largeThemaString
                if self.selectRowForMidThema != 0{
                    midThemaString = "&cat2=" + String(self.thema.midCode[self.selectRowForLargeThema][self.selectRowForMidThema])
                    self.url += midThemaString
                    if self.selectRowForSmallThema != 0{
                        smallThemaString = "&cat3=" + String(self.thema.smallCode[self.selectRowForLargeThema][self.selectRowForMidThema][self.selectRowForSmallThema])
                        self.url += smallThemaString
                    }
                }
            }
            
            
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
        self.moreLoding.startAnimating()
        self.moreBtn.isHidden = true
        let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.page += 1
            let url = self.url+"&pageNo="+String(self.page)
            self.beginParsing(url)
            self.moreBtn.isEnabled = true
            self.moreLoding.stopAnimating()
        }
    }
    
    
    
    func beginParsing(_ url : String){
        
        parser = XMLParser(contentsOf:(URL(string:url))!)!
        parser.delegate = self
        parser.parse()
        if self.list.count >= totalCount{
            self.moreBtn.isHidden = true
        }else{
            self.moreBtn.isHidden = false
        }
        tbData.reloadData()
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
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        if self.list.count == 0{
            emptyLabel.text = "원하는 지역과 테마와 키워드를\n입력하시고 검색버튼을 눌러주세요"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourSearchCell")! as! CustomTableViewCell
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
        if largeThemaTextField.isEditing{
            largeThemaTextField.resignFirstResponder()
        }
        if midThemaTextField.isEditing{
            midThemaTextField.resignFirstResponder()
        }
        if smallThemaTextField.isEditing{
            smallThemaTextField.resignFirstResponder()
        }
        if keword.isEditing{
            keword.resignFirstResponder()
        }
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
