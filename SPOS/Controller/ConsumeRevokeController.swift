//
//  ConsumeRevokeController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ConsumeRevokeController: UIViewController {
    
    let consumeRevokeVM : ConsumeRevokeViewModel = ConsumeRevokeViewModel()
    
    @IBOutlet weak var tfPWD: UITextField!  //主管密码输入框
    @IBOutlet weak var btnSubmit: UIButton! //提交按钮
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingSubView()
    }
    
    //设置视图属性
    func settingSubView() {
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.clipsToBounds = true
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //提交主管密码
    @IBAction func submitManagePWD(sender: AnyObject) {
        if let pwd = tfPWD.text {
            if pwd.characters.count > 0 {
                self.view.showHUD()
                consumeRevokeVM.valideManagePWD(pwd, callback: {[weak self] (data, message) in
                    self?.view.dismissHUD()
                    if message?.characters.count > 0 {
                        if message == "6" {
                            self?.tokenExpired()
                        }else{
                            self?.view.makeToast(message)
                        }
                    }else{
                        self?.performSegueWithIdentifier("toImportOrderNo", sender: self)
                        if var controllers = self?.navigationController?.viewControllers {
                            var index = 0
                            var currentIndex = 0
                            for controller in controllers {
                                if controller is ConsumeRevokeController {
                                    currentIndex = index
                                }
                                index += 1
                            }
                            if currentIndex > 0 {
                                controllers.removeAtIndex(currentIndex)
                            }
                            self?.navigationController?.viewControllers = controllers
                        }
                    }
                })
            }
        }else{
            self.view.makeToast("请输入主管密码")
        }
        
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ImportOrderNoController {
            controller.shop_pass = tfPWD.text
        }
    }
 

}
