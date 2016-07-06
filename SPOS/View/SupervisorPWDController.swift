//
//  SupervisorPWDController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/5.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SupervisorPWDController: UIViewController {

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
        
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            if let signString = DefaultKit.signString(token, data: nil) {
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                let manager = AFNetworkingManager()
                manager.postRequest("/paylist?token=\(token)", postData: ["sign" : sign], callback: { (dic, err) in
                    if let value = dic as? [String : AnyObject] {
                        if value["errcode"] as? Int == 0 {
                            if let sign = value["sign"] as? String {
                                let rsa = RSAHelper()
                                let result = rsa.rsaPDecrypt(sign, keyPath: DefaultKit.filePath("public_key.pem"))
                                let result2 = DefaultKit.validString(value).md5
                                if result2 == result {
                                    
                                    if let data = value["data"] as? String {
                                        let aes = AESHelper()
                                        let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as? String
                                        let aesValue = aes.aes256_decrypt(aes_key!, hexString: data)
                                        print(aesValue)
                                    }
                                    
                                }else{
                                    print("验签没通过")
                                }
                                
                            }
                        }else if value["errcode"] as? Int > 0 {
                            
                        }else{
                            
                        }
                    }
                })
            }
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
