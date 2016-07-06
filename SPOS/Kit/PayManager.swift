//
//  PayManager.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class PayManager: NSObject {
    
    //支付,暂测试现金收银
    static func doPay(pmt_tag : String , ord_name : String , original_amount : Int , discount_amount: Int ,ignore_amount : Int , trade_amount : Int , auth_code : String? , order_no:String? , callback : (String , String) -> Void) {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            var data : [String : AnyObject] = ["pmt_tag" : pmt_tag , "ord_no" : DefaultKit.orderNo() , "ord_name" : ord_name.utf8ToUnicode() , "original_amount" : original_amount , "discount_amount" : discount_amount , "ignore_amount" : ignore_amount ,"trade_amount" : trade_amount]
            if auth_code != nil {
                data["auth_code"] = auth_code!
            }
            
            //add by yushaopeng
            if order_no != nil{
                data["ord_no"] = order_no!
            }
            //end add
            do{
                let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
                if let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as? String {
                    let aes = AESHelper()
                    var dataString = String(data: json ,encoding: NSUTF8StringEncoding)
                    dataString = dataString?.stringByReplacingOccurrencesOfString("\\\\", withString: "\\")
                    let aesString = aes.aes_encrypt(dataString, key: aes_key)
                    let signString = DefaultKit.signString(token, data: aesString)
                    let rsa = RSAHelper()
                    let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                    let manager = AFNetworkingManager()
                    manager.postRequest("payorder?token=\(token)", postData: ["sign" : sign! , "data" : aesString], callback: { (data, error) in
                        if let value = data as? [String : AnyObject] {
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
                                            callback(aesValue , "")
                                            //modify by yushaopeng
                                            /*
                                            let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                            
                                            do{
                                                
                                                
                                                if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? Dictionary<String , AnyObject>{
                                                    
                                                    print(dic1)
                                                    
                                                    if let status:Int = dic1["status"] as! Int{
                                                        if (status == 1)
                                                        {
                                                            callback(aesValue , "交易成功")
                                                        }
                                                        else if (status == 4)
                                                        {
                                                            callback(aesValue , "已取消")
                                                        }
                                                        else if (status == 2)
                                                        {
                                                            callback(aesValue , "待支付")
                                                        }
                                                        else
                                                        {
                                                            callback(aesValue , "等待用户输入密码确认")
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                            catch {
                                                
                                            }*/

                                        }else{
                                            callback("" , "")
                                        }
                                        
                                    }else{
                                        print("验签没通过")
                                        callback("" , "")
                                    }
                                    
                                }else{
                                    callback("" , "")
                                }
                                
                            }else if value["errcode"] as? Int > 0 {
                                if let message = data?["msg"] as? String {
                                    callback("" , message)
                                }else{
                                    callback("" , "")
                                }
                            }else{
                                callback("" , "网络异常")
                            }
                        }else{
                            callback("" , "")
                        }
                    })
                }else{
                    callback("" , "")
                }
                
            }catch{
                callback("" , "")
            }
        }
    }
    
}
