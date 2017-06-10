//
//  SettingViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 6. 7..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet var tbData: UITableView!
    var indicator = UIActivityIndicatorView()
    
    
    let color = ["White","LightGray","DarkGray","Emerald","Sky","Brown","Yellow"]
    let themeColor = ThemeColor()
    let cellHeight = 0.0
    var flag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        var color : UIColor!
        if UserDefaults.standard.object(forKey: "theme") != nil{
            let char = UserDefaults.standard.string(forKey: "theme")
            
            if char == "Emerald"{
                color = ThemeColor().emerald
                self.navigationController?.navigationBar.barTintColor = color //네이게이션바 배경색
            }else if char == "Sky"{
                color = ThemeColor().hanuel
                self.navigationController?.navigationBar.barTintColor = color
            }else if char == "LightGray"{
                color = ThemeColor().whiteGray
                self.navigationController?.navigationBar.barTintColor = color
            }else if char == "Yellow"{
                color = ThemeColor().yellow
                self.navigationController?.navigationBar.barTintColor = color
            }else if char == "Brown"{
                color = ThemeColor().brown
                self.navigationController?.navigationBar.barTintColor = color
            }else if char == "White"{
                color = ThemeColor().white
                self.navigationController?.navigationBar.barTintColor = color
            }else if char == "DarkGray"{
                color = ThemeColor().darkGray
                self.navigationController?.navigationBar.barTintColor = color
            }
        }
        activityIndicator()

    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 177, y: 100, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func showAlert(title: String,message: String){
        
        let alertController = UIAlertController(title: title+"\n", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "변경", style: .default, handler: {handler in
            self.indicator.startAnimating()
            let when = DispatchTime.now() + 0.001 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "Root_View")
                self.indicator.stopAnimating()
            }
            
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default,handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func showAlert2(title: String,message: String){
        
        let alertController = UIAlertController(title: title+"\n", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "변경", style: .default, handler: {handler in
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key.description)
            }
            self.showAlert3(title: "알 림", message: "초기화되었습니다.")
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default,handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func showAlert3(title: String,message: String){
        
        let alertController = UIAlertController(title: title+"\n", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let Action = UIAlertAction(title: "확인", style: .default,handler: nil)
        
        alertController.addAction(Action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func TapGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        print("섹션 클릭")
        //do your stuff here
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 8{
            
        }else{
            if self.flag == true{
                return CGFloat(cellHeight)
            }else{
                return 30
            }
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            cell.detailTextLabel?.text = "클릭하면 테마들이 나타납니다."
        }else if indexPath.row == 8{
            cell = tableView.dequeueReusableCell(withIdentifier: "resetCell", for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath)
            cell.textLabel?.text = color[indexPath.row-1]
            cell.textLabel?.textAlignment = NSTextAlignment.center
            if indexPath.row == 1{
                if(cell.isSelected){
                    cell.backgroundColor = themeColor.emerald
                }else{
                    cell.backgroundColor = themeColor.white

                }
            }else if indexPath.row == 2{
                cell.backgroundColor = themeColor.whiteGray
            }else if indexPath.row == 3{
                cell.backgroundColor = themeColor.darkGray
            }else if indexPath.row == 4{
                cell.backgroundColor = themeColor.emerald
            }else if indexPath.row == 5{
                cell.backgroundColor = themeColor.hanuel
            }else if indexPath.row == 6{
                cell.backgroundColor = themeColor.brown
            }else if indexPath.row == 7{
                cell.backgroundColor = themeColor.yellow
            }
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.flag = !self.flag
            tbData.reloadData()
        }else if indexPath.row == 8{
            let str = UserDefaults.standard.string(forKey: "theme")
            self.showAlert2(title: "경 고", message: "모든 즐겨찾기가 초기화됩니다.\n초기화 하시겠습니까?")
            UserDefaults.standard.set(str, forKey: "theme")
        }else{
            showAlert(title: "테마 변경", message: "테마를 변경합니다.\n앱의 초기화면으로 돌아갑니다.")
            let index = indexPath.row-1
            let str = color[index]
            UserDefaults.standard.set(str, forKey: "theme")
        }

    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell")! as! HeaderCellTableViewCell
        
        return header.contentView
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
