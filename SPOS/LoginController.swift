//
//  ViewController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/1/27.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    var smsID : String?
    var aes_key : String?
    var token : String?
    var mct_no : String?
    
    @IBOutlet weak var tConstraint: NSLayoutConstraint!    //中间视图到顶部的约束
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPWD: UITextField!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnPWD: UIButton!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tConstraint.constant = SCREENWIDTH * 205 / 320
    
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.overlayColor = UIColor(red: 0 , green: 161/255.0 , blue : 238 , alpha : 1)
        
        self.navigationController?.navigationBar.jh_setBackgroundColor(UIColor.clearColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? TerminalActivationController {
            controller.token = token
            controller.aes_key = aes_key
            controller.sms_id = smsID
            
        }
    }
    
    // MARK: -ACTION
    //清空输入框内容
    @IBAction func clearText(sender: AnyObject) {
    }
    
    //是否需要纪录密码
    @IBAction func isRememberPWD(sender: AnyObject) {
        
        btnRemember.selected = !btnRemember.selected
        
    }
    
    //忘记密码
    @IBAction func forgetPWD(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toForget", sender: self)
        
    }
    
    //登录
    @IBAction func loginAccount(sender: AnyObject) {
        
        if (tfName.text!.characters.count == 0)
        {
            self.view.makeToast("用户名不能为空")
            return
        }
        
        if (tfPWD.text!.characters.count == 0)
        {
            self.view.makeToast("密码不能为空")
            return
        }
        
        let public_key_path = DefaultKit.filePath("public_key.pem")
        let mct_no = NSUserDefaults.standardUserDefaults().objectForKey("mct_no") as? String
        if NSFileManager.defaultManager().fileExistsAtPath(public_key_path) && mct_no?.characters.count > 0 {
            
            loginNormal(tfName.text!, pwd: tfPWD.text!, mct_no: mct_no!)
            
        }else{
            login(tfName.text!, pwd: tfPWD.text!)
        }
        
        
    }
    //以游客身份登录
    @IBAction func loginWithTourist(sender: AnyObject) {
        
        
        
    }
    
    
    //登录事件，已下载商户证书
    /**
     登录
     
     - parameter username: 用户名或者手机号
     - parameter pwd:      密码
     - parameter mct_no:   商户号
     */
    func loginNormal(username : String , pwd : String , mct_no : String) {
        do {self.view.showHUD()
            let data = ["user_name" : username , "password" : pwd.sha1() , "app" : "iphone"]
            let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
            let helper = RSAHelper()
            let rsa = helper.rsaEncrypt(jsonStr, keyPath: DefaultKit.filePath("public_key.pem"))
            let manager = AFNetworkingManager()
            manager.postRequest("/user/login?mct_no=\(mct_no)", postData: ["data" : rsa ?? ""], callback: {[weak self] (object : AnyObject?, error : NSError?) -> () in
                
                assert(NSThread.currentThread().isMainThread)
                self!.view.dismissHUD()
                if let value = object as? [String : AnyObject] {
                    
                    if value["errcode"] as? Int == 0 {
                        
                        if let data = value["data"] as? String {
                            
                            let rsa = helper.rsaPDecrypt(data, keyPath: DefaultKit.filePath("public_key.pem"))
                            if let data = rsa.dataUsingEncoding(NSUTF8StringEncoding) {
                                
                                do {
                                    if let dic = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? Dictionary<String , AnyObject> {
                                        
                                        if let token = dic["token"] as? String {
                                            self!.token = token
                                            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                                            
                                        }
                                        
                                        if let aes_key = dic["aes_key"] as? String {
                                            self!.aes_key = aes_key
                                            NSUserDefaults.standardUserDefaults().setObject(aes_key, forKey: "aes_key")
                                            
                                        }
                                        
                                        if let mct_no = dic["mct_no"] as? String {
                                            
                                            NSUserDefaults.standardUserDefaults().setObject(mct_no, forKey: "mct_no")
                                            
                                        }
                                        
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        
                                        if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
                                            app.window?.rootViewController = self!.storyboard?.instantiateViewControllerWithIdentifier("menu")
                                            
                                        }
                                    }
                                    
                                    
                                }catch {
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                    }else if value["errcode"] as? Int > 0 {
                        
                        
                        
                    }else{
                        
                    }
                    
                }
                
                })
            
        }catch {
            
            self.view.dismissHUD()
            
            
        }
    }
    
    
    //登录事件，未下载商户证书
    /**
     登录
     
     - parameter username: 用户名或者手机号
     - parameter pwd:      密码
     */
    func login(username : String , pwd : String) {
        
        do {
            self.view.showHUD()
            let data = ["user_name" : username , "password" : pwd.sha1() , "app" : "iphone"]
            let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
            let helper = RSAHelper()
            let rsa = helper.rsaEncrypt(jsonStr, keyPath: NSBundle.mainBundle().pathForResource("public_key", ofType: "pem"))
            let manager = AFNetworkingManager()
            manager.postRequest("/user/login", postData: ["data" : rsa], callback: {[weak self] (object : AnyObject?, error : NSError?) -> () in
                
                assert(NSThread.currentThread().isMainThread)
                self!.view.dismissHUD()
                if let value = object as? Dictionary<String , AnyObject> {
                    
                    if value["errcode"] as? Int == 0 {
                        
                        if let data = value["data"] as? String {
                            
                            let rsa = helper.rsaPDecrypt(data, keyPath: NSBundle.mainBundle().pathForResource("public_key", ofType: "pem"))
                            if let data = rsa.dataUsingEncoding(NSUTF8StringEncoding) {
                                
                                do {
                                    if let dic = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? Dictionary<String , AnyObject> {
                                        
                                        if let token = dic["token"] as? String {
                                            self!.token = token
                                        }
                                        
                                        
                                        if let aes_key = dic["aes_key"] as? String {
                                            self!.aes_key = aes_key
                                            
                                            
                                        }
                                        
                                        if let mct_no = dic["mct_no"] as? String {
                                            
                                            self!.mct_no = mct_no
                                            
                                        }
                                        
                                        self!.getSMSCode(self!.token!, aes_key: self!.aes_key!)
                                        
                                       
                                        
                                    }
                                    
                                    
                                }catch {
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                    }else if value["errcode"] as? Int > 0 {
                        
                        
                        
                    }else{
                        
                    }
                    
                }
                
            })
            
        }catch {
            
            self.view.dismissHUD()
            
            
        }
        
        
    }
    
    //获取验证码
    func getSMSCode(token : String , aes_key : String) {
        
        let manager = AFNetworkingManager()
        manager.getRequest("/merchant/cert_mobile?token=\(token)", getData: nil) {[weak self] (data : AnyObject?, error : NSError?) -> () in
            
            if let value = data as? Dictionary<String , AnyObject> {
                
                if value["errcode"] as? Int == 0 {
                    if let data = value["data"] as? String {
                        let aes = AESHelper()
                        let json = aes.aes256_decrypt(aes_key, hexString: data).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            if let dic = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as? Dictionary<String , AnyObject> {
                                
                                if let sms_id = dic["sms_id"] as? String {
                                    
                                    self!.smsID = sms_id
                                    self?.performSegueWithIdentifier("toInitialCert", sender: self)
                                }
                                
                            }
                        }catch {
                            
                        }
                        
                    }
                    
                    
                    
                }else if value["errcode"] as? Int > 0 {
                    
                    
                }else {
                    
                }
                
            }
            
        }
        
    }
    
    
    
}

