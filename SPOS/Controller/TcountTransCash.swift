//
//  TcountTransCash.swift
//  SPOS
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation
import UIKit

class TcountTransCash: UIViewController,APNumberPadDelegate{

    @IBOutlet weak var cashNumLab: UILabel!
    
    @IBOutlet weak var countNameLab: UILabel!
    
    var amount:String?

    @IBAction func transCashButtonTaped(sender: AnyObject) {
        //接口还没有，等待接口
        print("transCashButtonTaped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cashNumLab.text = "可转账\(self.amount!)元"
        self.cashNumLab.textColor = BASE_TEXT_GRAYCOLOR
        self.countNameLab.adjustsFontSizeToFitWidth = true
        
        let rect = CGRectMake(0, SCREENHEIGHT-(SCREENWIDTH*0.75), SCREENWIDTH, (SCREENWIDTH*0.75))
        let numberPad = APNumberPad.init(delegate: self, withFrame:rect, displayLable:cashNumLab)
        
        numberPad.leftFunctionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(numberPad)
        
        queryMerchantTcountState()
    }

    func queryMerchantTcountState() {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            if let signString = DefaultKit.signString(token, data: nil) {
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                let manager = AFNetworkingManager()
                manager.postRequest("/account?token=\(token)", postData: ["sign" : sign], callback: { (dic, err) in
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
                                        
                                        let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                        
                                        do{
                                            
                                            
                                            if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? Dictionary<String , AnyObject>{
                                                
                                                print(dic1)
                                                let count_name = dic1["account_name"] as? String
                                                self.countNameLab.text = self.countNameLab.text! + " ("+count_name! + ")"
                                            }
                                        }
                                        catch {
                                            
                                        }
                                        
                                        
                                    }
                                }else{
                                    print("验签没通过")
                                }
                                
                            }
                        }else if value["errcode"] as? Int > 0 {
                            
                            print(value["msg"])
                            
                        }else{
                            
                        }
                    }
                })
            }
        }
        
    }
}
