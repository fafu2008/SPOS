//
//  TerminalActivationController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/28.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class TerminalActivationController: UIViewController {

    var token : String?
    var sms_id : String?
    var aes_key : String?
    @IBOutlet weak var tfSMSCode: UITextField!
    @IBOutlet weak var btnSMSCodeClear: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        btnCancel.layer.cornerRadius = 10.0
        btnCancel.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        btnCancel.layer.borderWidth = 1
        btnCancel.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)), forState: .Normal)
        btnCancel.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1)), forState: .Highlighted)
        btnCancel.clipsToBounds = true
        
        btnSubmit.layer.cornerRadius = 10.0
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1)), forState: .Normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 179/255.0, green: 62/255.0, blue: 15/255.0, alpha: 1)), forState: .Highlighted)
        btnSubmit.clipsToBounds = true
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    //清空输入框内容
    @IBAction func clearSMSCodeText(sender: AnyObject) {
        
        tfSMSCode.text = nil
        
    }
    
    //取消本次操作
    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    //确定激活
    @IBAction func submitActivation(sender: AnyObject) {
        
        tfSMSCode.resignFirstResponder()
        if let smscode = tfSMSCode.text {
            if smscode.characters.count > 0 {
                downloadCert(token!, sms_id: sms_id!, sms_code: smscode)
            }else{
                self.view.makeToast("验证码输入有误")
            }
        }else{
            self.view.makeToast("请输入验证码")
        }
        
    }
    
    
    //下载商户证书
    func downloadCert(token : String , sms_id : String , sms_code : String) {
        
        do {
            let data = ["sms_id" : sms_id , "sms_code" : sms_code]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            let aes = AESHelper()
            let jsonRSA = aes.aes256_encrypt(aes_key!, inData: jsonData)
            self.view.showHUD()
            let manager = AFNetworkingManager()
            manager.postRequest("merchant/cert_down?token=\(token)", postData: ["data" : jsonRSA], callback: {[weak self] (object : AnyObject?, error : NSError?) -> () in
                self!.view.dismissHUD()
                if let value = object as? Dictionary<String , AnyObject> {
                    
                    if value["errcode"] as? Int == 0 {
                        if let aesData = value["data"] as? String {
                            let aes = AESHelper()
                            let aesStr = aes.aes256_decrypt(self!.aes_key!, hexString: aesData).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            let jsonData = aesStr.dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as? Dictionary<String , AnyObject> {
                                    if let public_key = json["public_key"] as? String {
                                        do {
                                            try public_key.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile(DefaultKit.filePath("public_key.pem"), options: .DataWritingAtomic)
                                            
                                            if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
                                                app.window?.rootViewController = self!.storyboard?.instantiateViewControllerWithIdentifier("menu")
                                                
                                            }
                                            
                                        }catch{
                                            self?.view.makeToast("商户证书下载失败")
                                        }
                                        
                                    }
                                    if let mct_no = json["mct_no"] as? String {
                                        NSUserDefaults.standardUserDefaults().setObject(mct_no, forKey: "mct_no")
                                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                                        NSUserDefaults.standardUserDefaults().setObject(self!.aes_key!, forKey: "aes_key")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                    }
                                    
                                }else{
                                    
                                    self?.view.makeToast("数据格式错误")
                                }
                                
                                
                                
                                
                            }catch{
                                self?.view.makeToast("数据格式错误")
                            }
                            
                        }
                        
                    }else if value["errcode"] as? Int > 0 {
                        
                        if let message = value["msg"] as? String{
                            
                            self?.view.makeToast(message)
                            
                        }
                        
                    }else{
                        
                        
                        
                    }
                    
                    
                }
                
                })
            
        }catch {
            self.view.makeToast("数据格式错误")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
