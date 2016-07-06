//
//  AFNetworkingManager.swift
//  SPOS
//
//  Created by 张晓飞 on 16/1/28.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit


class AFNetworkingManager: NSObject {
    
    
    /**
     POST请求
     
     - parameter urlString: URL
     - parameter postData:  POST请求Data
     - parameter callback:  回调
     */
    func postRequest(urlString : String , postData : AnyObject?  , callback : (AnyObject? , NSError?) -> ()) {
        
        postRequest(urlString, postData: postData, duration: 60, callback: callback)
        
    }
    
    /**
     POST请求，可定义请求时长
     
     - parameter urlString: URL
     - parameter postData:  POST请求Data
     - parameter duration:  交互时长
     - parameter callback:  回调
     */
    func postRequest(urlString : String , postData : AnyObject? , duration : NSTimeInterval  , callback : (AnyObject? , NSError?) -> ()) {
        

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = AFHTTPSessionManager(sessionConfiguration: configuration)
        let request = AFHTTPRequestSerializer().requestWithMethod("POST", URLString: DefaultKit.urlHead + urlString, parameters: postData, error: nil)
        request.timeoutInterval = duration
        if var set = session.responseSerializer.acceptableContentTypes {
            set.insert("text/html")
            session.responseSerializer.acceptableContentTypes = set
        }
        let task = session.dataTaskWithRequest(request, completionHandler: { (response, data, error) in
            assert(NSThread.currentThread().isMainThread)
            callback(data , error)
        })
        task.resume()

        
    }
    
    // xjq add start
    
    
    /**
     POST请求
     
     - parameter urlString: URL
     - parameter postData:  POST请求Data
     - parameter callback:  回调
     */
    func postRequest2(urlString : String , postData : AnyObject? , callback : (AnyObject? , NSError?) -> ()) {
        //NSLog("postRequest urlString = \(urlString) postData = \(postData)")
        postRequest2(urlString, postData: postData, duration: 60, callback: callback)
        
    }
    
    /**
     POST请求，可定义请求时长
     
     - parameter urlString: URL
     - parameter postData:  POST请求Data
     - parameter duration:  交互时长
     - parameter callback:  回调
     */
    func postRequest2(urlString : String , postData : AnyObject? , duration : NSTimeInterval  , callback : (AnyObject? , NSError?) -> ()) {
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = AFHTTPSessionManager(sessionConfiguration: configuration)
        let request = AFHTTPRequestSerializer().requestWithMethod("POST", URLString: urlString, parameters: postData, error: nil)
        request.timeoutInterval = duration
        if var set = session.responseSerializer.acceptableContentTypes {
            set.insert("text/html")
            session.responseSerializer.acceptableContentTypes = set
        }
        let task = session.dataTaskWithRequest(request, completionHandler: { (response, data, error) in
            assert(NSThread.currentThread().isMainThread)
            callback(data , error)
        })
        task.resume()
        
        
    }
    
    
    
    
    
    func httpConnectRequst(controller:UIViewController?, urlString : String , postData : AnyObject?  , callback : (AnyObject? , NSError?) -> ()){
        do{
            controller?.view.showHUD()
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                let aes_string:String?
                if(postData != nil){
                    let data = postData
                    //print(data)
                    let json = try NSJSONSerialization.dataWithJSONObject(data!, options: .PrettyPrinted)
                    
                    let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as?String
                    let aes = AESHelper()
                    
                    let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
                    aes_string = aes.aes_encrypt(jsonStr, key: aes_key)
                    
                }else{
                    aes_string = nil
                }
                let signString = DefaultKit.signString(token, data: aes_string)
                let rsa = RSAHelper()
                if let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                {
                    let manager = AFNetworkingManager()
                    
                    var post_string:Dictionary<String,String>
                    if(aes_string != nil){
                        post_string = ["sign" : sign,"data" : aes_string!]
                    }else{
                        post_string = ["sign" : sign]
                    }
                    manager.postRequest("\(urlString)?token=\(token)", postData: post_string, callback: { (dic, err) in
                        
                        if let value = dic as? [String : AnyObject] {
                            controller?.view.dismissHUD()
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
                                            let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                            do{
                                                if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? Dictionary<String , AnyObject>{
                                                    //print(dic1)
                                                    callback(dic1,err)
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
                                NSLog((value["msg"] as? String)!)
                                controller?.view.makeToast(value["msg"] as? String)
                                
                            }else{
                                
                            }
                        }
                    })
                }
            }
            
        }
        catch
        {
            controller?.view.dismissHUD()
            print("TCountTransRecord解析异常")
        }
    }
    
    
    func httpConnectRequstBackArray(controller:UIViewController, urlString : String , postData : AnyObject?  , callback : (AnyObject? , NSError?) -> ()){
        do{
            controller.view.showHUD()
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                let aes_string:String?
                if(postData != nil){
                    let data = postData
                    //print(data)
                    let json = try NSJSONSerialization.dataWithJSONObject(data!, options: .PrettyPrinted)
                    
                    let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as?String
                    let aes = AESHelper()
                    
                    let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
                    aes_string = aes.aes_encrypt(jsonStr, key: aes_key)
                    
                }else{
                    aes_string = nil
                }
                let signString = DefaultKit.signString(token, data: aes_string)
                let rsa = RSAHelper()
                if let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                {
                    let manager = AFNetworkingManager()
                    
                    var post_string:Dictionary<String,String>
                    if(aes_string != nil){
                        post_string = ["sign" : sign,"data" : aes_string!]
                    }else{
                        post_string = ["sign" : sign]
                    }
                    manager.postRequest("\(urlString)?token=\(token)", postData: post_string, callback: { (dic, err) in
                        
                        if let value = dic as? [String : AnyObject] {
                            controller.view.dismissHUD()
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
                                            let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                            do{
                                                if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? NSArray{
                                                    //print(dic1)
                                                    callback(dic1,err)
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
                                NSLog((value["msg"] as? String)!)
                                controller.view.makeToast(value["msg"] as? String)
                                
                            }else{
                                
                            }
                        }
                    })
                }
            }
            
        }
        catch
        {
            controller.view.dismissHUD()
            print("TCountTransRecord解析异常")
        }
    }
    
    
    // xjq add end
    
    /**
     Get请求
     
     - parameter urlString: URL
     - parameter getData:   参数
     - parameter callback:  回调
     */
    func getRequest(urlString : String , getData : AnyObject? , callback : (AnyObject? , NSError?) -> ()) {
        let URL = NSURL(string: DefaultKit.urlHead)
        let manager = AFHTTPSessionManager(baseURL: URL)
        manager.responseSerializer.acceptableContentTypes = ["text/html"]
        manager.GET(DefaultKit.urlHead + urlString, parameters: getData, progress: { (progress : NSProgress) -> Void in
            
            }, success: { (task : NSURLSessionDataTask, object : AnyObject?) -> Void in
                
                
                callback(object , nil)
                
                
            }) { (task : NSURLSessionDataTask?, error : NSError) -> Void in
                
                callback(nil , error)
                
        }
    }
}
