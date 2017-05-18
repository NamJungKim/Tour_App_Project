//
//  nextViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 18..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import Foundation
import UIKit
class TourSearchViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var areaTextField : UITextField!
    @IBOutlet var detailAreaTextField: UITextField!
    @IBOutlet var largeThemaTextField: UITextField!
    @IBOutlet var midThemaTextField: UITextField!
    @IBOutlet var smallThemaTextField: UITextField!
    let city = CityData()
    let thema = ThemaData()
    //텍스트 필드를 완료 안누르고 다른 텍스트 필드를 누르면 적용되는걸 방지
    var selectRowForCity = 0
    var selectRowForDetail = 0
    var selectRowForLargeThema = 0
    var selectRowForMidThema = 0
    var selectRowForSmallThema = 0
    var flagForPickup = 0
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
}
