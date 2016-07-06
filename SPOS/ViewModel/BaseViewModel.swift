//
//  BaseViewModel.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    
    /**
     组装数据，为POST请求提供token和parameters
     
     - parameter data: 需要组装的数据
     
     - returns: token和parameters
     */
    internal func packageParam(data : [String : AnyObject]?) -> (String? , [String : AnyObject]?) {
        
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
        if data != nil {
            do{
                let json = try NSJSONSerialization.dataWithJSONObject(data!, options: .PrettyPrinted)
                if let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as? String {
                    
                    var dataString = String(data: json ,encoding: NSUTF8StringEncoding)
                    dataString = dataString?.stringByReplacingOccurrencesOfString("\\\\", withString: "\\")
                    
                    let aes = AESHelper()
                    let aesString = aes.aes_encrypt(dataString, key: aes_key)
                    let signString = DefaultKit.signString(token, data: aesString)
                    let rsa = RSAHelper()
                    let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                    return(token , ["sign" : sign! , "data" : aesString])
                }
            }catch{
                
            }
        }
        return (token , nil)
    }
    
    /**
     解析网络返回的数据
     
     - parameter data: 网络返回数据
     
     - returns: 解析后的数据和错误信息
     */
    internal func validParam(data : AnyObject?) -> (AnyObject? , String?){
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
                            return (jsonToData(aesValue) , nil)
                          
                        }else{
                            return(nil , nil)
                        }
                    }else{
                        return(nil , "验签没通过")
                    }
                }else{
                    return(data , nil)
                }
            }else if value["errcode"] as? Int > 0 {
                let errcode = value["errcode"] as! Int
                if errcode == 6 {
                    return(nil , "6")
                }else{
                    let message = value["msg"] as? String
                    return(nil , message)
                }
                
            }else{
               return(nil , "网络异常")
            }
        }else{
            return (nil , nil)
        }
    }
    
    
    internal func jsonToData(json : String) -> AnyObject? {
        do{
            let data  = try NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            return data
        }catch{
            return nil
        }
    }
    
}
