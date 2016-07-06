//
//  SupervisorPWDController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/5.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SupervisorPWDController: UIViewController{

    let consumeRevokeVM : ConsumeRevokeViewModel = ConsumeRevokeViewModel()
    @IBOutlet weak var passwdView: SupervisorPWDView!
    var passNum = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //取消
    @IBAction func cancelEvent(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    
    //确定
    @IBAction func queryEvent(sender: AnyObject) {
        
        let pass_wd = passwdView.get_password()
        print(pass_wd)
        
            if pass_wd.characters.count > 0 {
                self.view.showHUD()
                consumeRevokeVM.valideManagePWD(pass_wd, callback: {[weak self] (data, message) in
                    self?.view.dismissHUD()
                    if message?.characters.count > 0 {
                        if message == "6" {
                            self?.tokenExpired()
                        }else{
                            self?.view.makeToast(message)
                        }
                    }else{
                        self!.view.makeToast("主管密码验证通过")
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("change_price", object: nil)
                        
                        self!.dismissViewControllerAnimated(true) {
                            
                        }
                    }
                    })

        }else{
            self.view.makeToast("请输入主管密码")
        }
        
        
    }
    

}
