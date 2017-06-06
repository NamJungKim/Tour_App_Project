//
//  ViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 5. 18..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var pickerView: UIPickerView!
    var pickerDataSource = ["관광","행사","숙박","근처"]
    var flag : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        flag = row
    }
    
    @IBAction func doneToPickerViewController(_ segue:UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTableView"{
        }
    }
    
    @IBAction func touchNext(_ sender: UIBarButtonItem) {
        /*let uvc = self.storyboard?.instantiateViewController(withIdentifier: "TourVC")
        uvc?.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal //페이지 전환시 에니메이션 효과 설정
        present(uvc!, animated: true, completion: nil)*/
        if flag == 0 {
            self.performSegue(withIdentifier: "segueToTour", sender: self)
        }else if flag == 1{
            self.performSegue(withIdentifier: "segueToEvent", sender: self)
        }else if flag == 2{
            self.performSegue(withIdentifier: "segueToHotel", sender: self)
        }else{
            self.performSegue(withIdentifier: "segueToArea", sender: self)
        }
    }
}

