//
//  UserBasicInfoViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/6.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class UserBasicInfoViewController: UIViewController {

    @IBOutlet var shopName: UILabel!
    @IBOutlet var shopNo: UILabel!
    @IBOutlet var shopSubName: UILabel!
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var deviceID: UILabel!

    @IBOutlet var employeeName: UILabel!
    @IBOutlet var telephoneNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载全局值
        shopName.text = ""
        shopNo.text = ""
        shopSubName.text = ""
        userName.text = ""
        deviceID.text = ""
        employeeName.text = ""
        telephoneNumber.text = ""
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.getShopInfo()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getShopInfo(){
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(nil, urlString: "/user", postData: nil) { (data, error) in
            if let shop_no = data!["shop_no"] as? String{
                NSUserDefaults.standardUserDefaults().setObject(shop_no, forKey: "shop_no")
            }
            if let mct_name = data!["mct_name"] as? String{
                self.shopName.text = mct_name
            }
            if let mct_no = data!["mct_no"] as? String{
                self.shopNo.text = mct_no
            }
            if let shop_name = data!["shop_name"] as? String{
                self.shopSubName.text = shop_name
            }
            if let role_name = data!["role_name"] as? String{
                self.employeeName.text = role_name
            }
            if let mobile = data!["mobile"] as? String{
                self.telephoneNumber.text = mobile
            }
            if let user_name = data!["user_name"] as? String{
                self.userName.text = user_name
            }
            if let scr_id = data!["scr_id"] as? String{
                self.deviceID.text = scr_id
            }
            
        }
    }
    
    
    static func getShopInfo(){
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(nil, urlString: "/user", postData: nil) { (data, error) in
            if let shop_no = data!["shop_no"] as? String{
                NSUserDefaults.standardUserDefaults().setObject(shop_no, forKey: "shop_no")
            }
            if let shop_no = data!["scr_id"] as? String{
                NSUserDefaults.standardUserDefaults().setObject(shop_no, forKey: "scr_id")
            }
        }
        
        SystemManageAreaLanguageViewController.initAreaLanguage()

    }
}
