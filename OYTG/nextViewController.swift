//
//  nextViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 18..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit
class nextViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var areaTextField : UITextField!
    
    @IBOutlet var detailAreaTextField: UITextField!
    var city = CityView()
    //텍스트 필드를 완료 안누르고 다른 텍스트 필드를 누르면 적용되는걸 방지
    var row = 0
    var selectRowForCity = 0
    var selectRowForDetail = 0
    var flagForPickup = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //textfield 초기화
        areaTextField.text = "전체"
        detailAreaTextField.text = "전체"
        //어느 텍스트 필드가 클릭되었는지 flag변경하는 메소드 추가
        areaTextField.addTarget(self, action: #selector(nextViewController.flagForPickupWithArea), for: UIControlEvents.touchDown)
        detailAreaTextField.addTarget(self,action: #selector(nextViewController.flagForPickupWithDetail), for: UIControlEvents.touchDown)
        //텍스트 필트 pickupView에 툴바 추가
        addToolBar(areaTextField,1)
        addToolBar(detailAreaTextField,2)
    }
    //어느 텍스트 필드가 클릭되었는지 flag변경하는 메소드
    func flagForPickupWithArea(){
        flagForPickup = 1
    }
    func flagForPickupWithDetail(){
        flagForPickup = 2
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
        
        
        let defaultButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextViewController.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextViewController.donePressed))
        //let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(nextViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 18)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.black
        if flagCount == 1{
            label.text = "도/시 선택"
        }else if flagCount == 2{
            label.text = "상세 지역 선택"
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
        }
    }
    //pickupView에서 완료버튼이 클릭되면 호출되는 메소드
    func donePressed(sender: UIBarButtonItem) {
        if flagForPickup == 1{
            //pickupView에서 행이 선택되면 row에 저장되었다가 완료버튼을 클릭하면 텍스트 필드의 행 번호가 바뀌면서 적용됨
            selectRowForCity=row
            areaTextField.resignFirstResponder()
            areaTextField.text = city.cityOption[selectRowForCity]
            detailAreaTextField.text = city.detail[0]?[0]
        }
        else if flagForPickup == 2{
            selectRowForDetail=row
            detailAreaTextField.resignFirstResponder()
            detailAreaTextField.text = city.detail[selectRowForCity]?[selectRowForDetail]
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
            return (city.detail[selectRowForCity]?.count)!
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
            return city.detail[selectRowForCity]?[row]
        }
        else{
            return ""
        }
    }
    //행이 선택될때 텍스트필드를 업데이트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //pickerTextField.text = pickOption[row]
        self.row = row
    }
}
