//
//  DefaultKit.swift
//  SPOS
//
//  Created by 张晓飞 on 16/1/28.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

let SCREENWIDTH = UIScreen.mainScreen().bounds.size.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.size.height

//add by yushaopeng in 2016-5-11
let VIEWWIDTH = UIScreen.mainScreen().bounds.size.width
let VIEWHEIGHT = UIScreen.mainScreen().bounds.size.height - 64
let NAVITEMHEIGHT = CGFloat(64.0)
//end add

//add by yushaopeng in 2016-5-13 for 界面调整
let BASE_UICOLOR = UIColor(red: 0/255.0, green: 161/255.0, blue: 238/255.0, alpha: 1)
let BASE_TEXTCOLOR = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
let BASE_TEXT_GRAYCOLOR = UIColor(red: 178/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1)
//end add

//add by yushaopeng in 2016-06-01 for 支付类型定义
let PAY_TYPE_WEIXIN = 1
let PAY_TYPE_ZHIFUBAO = 2
let PAY_TYPE_BAIDU = 3
//end add

class DefaultKit: NSObject {
    static let urlHead = "http://openapi.tlinx.cn/mct1/"
    
    static func filePath(fileName : String) -> String{
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        path = path.stringByAppendingString("/\(fileName)")
        return path
    }
    static func validString(dic : [String : AnyObject]) -> String {
        var message = dic["msg"] as! String
        message = message.utf8ToUnicode()
        print(message)
        return "{\"errcode\":\(dic["errcode"] as! Int),\"msg\":\"\(message)\",\"data\":\"\(dic["data"] as! String)\"}"
    }
    static func signString(token : String? , data : String?) -> String? {
        if token != nil {
            if data != nil {
                return "{\"token\":\"\(token!)\"}{\"data\":\"\(data!)\"}"
            }else{
                return "{\"token\":\"\(token!)\"}"
            }
            
        }
        return nil
    }
    //生成订单号(版本码（1位）+时间戳（10位）+收银员编号（6-8位）+随机数（1-3），取最左边20位)
    static func orderNo() -> String {
        let version = 4
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let scr_id = "100009"
        let random = arc4random() % 999
        var joinAll = "\(version)\(timestamp)\(scr_id)\(String(format: "%03d" , random))"
        if joinAll.characters.count >= 20 {
            return joinAll.substringToIndex(joinAll.startIndex.advancedBy(20))
        }else{
            let length = joinAll.characters.count
            for _ in 0..<20-length {
                joinAll += "0"
            }
            return joinAll
        }
    }
    
    //add by yushaopeng in 2016-05-11
    static func makeLable(rect:CGRect,title:String,font:UIFont,color:UIColor) -> UILabel{
        let lab = UILabel.init(frame: rect)
        lab.text = title
        lab.font = font
        lab.textColor = color
        return lab
    }
    
    static func makeLine(rect:CGRect,color:UIColor) -> UIView{
        let line = UIView.init(frame: rect)
        line.backgroundColor = color
        return line
    }
    
    static func packageParam(data : [String : AnyObject]?) -> (String? , [String : AnyObject]?) {
        
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

    static func change_string_to_int(str:String) -> Int
    {
        let str1 = str as NSString
        
        if (str1.isEqualToString(""))
        {
            print("change_string_to_int str is null")
            return 0
        }
        else if (str1.isEqualToString("0"))
        {
            return 0
        }
        else
        {
            let f_value = Int((str1.floatValue)*100)
            return f_value
        }
    }
    
    static func change_string_to_float(str:String) -> String
    {
        let str1 = str as NSString
        
        if (str1.isEqualToString(""))
        {
            print("change_string_to_float str is null")
            return ""
        }
        else if (str1.isEqualToString("0"))
        {
            return "0.00"
        }
        else
        {
            let f_value = Float((str1.floatValue)/100)
            let out_str = String(format:"%.2f",f_value)
            
            return out_str
        }
    }
    //end add
}

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
    
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        CC_MD5(str!, strLen, result);
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        return hash as String
    }
    
    func isTelNumber(num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[0-9])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluateWithObject(num) == true)
            || (regextestcm.evaluateWithObject(num)  == true)
            || (regextestct.evaluateWithObject(num) == true)
            || (regextestcu.evaluateWithObject(num) == true))
        {
            return true
        }
        else
        {
            return false
        }  
    }
}

extension UIView {
    
    
    func showHUD() {
        
        if let _ = self.viewWithTag(100000) {
            
        }else{
            let hudView = UIView()
            hudView.tag = 100000
            hudView.backgroundColor = UIColor.clearColor()
            let bgView = UIImageView(image: UIImage(named: "hud350350"))
            bgView.translatesAutoresizingMaskIntoConstraints = false
            hudView.addSubview(bgView)
            
            hudView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[bgView(113)]-(padding)-|", options: .DirectionLeadingToTrailing, metrics: ["padding" : (SCREENWIDTH-113)/2], views: ["bgView" : bgView]))
            hudView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bgView(113)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["bgView" : bgView]))
            hudView.addConstraint(NSLayoutConstraint(item: bgView, attribute: .CenterY, relatedBy: .Equal, toItem: hudView, attribute: .CenterY, multiplier: 1, constant: 0))
            
            let ivHud = UIImageView(image: UIImage(named: "hud100100"))
            ivHud.tag = 10000
            ivHud.translatesAutoresizingMaskIntoConstraints = false
            hudView.addSubview(ivHud)
            
            hudView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[ivHud(33)]-(padding)-|", options: .DirectionLeadingToTrailing, metrics: ["padding" : (SCREENWIDTH-33)/2], views: ["ivHud" : ivHud]))
            hudView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[ivHud(33)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["ivHud" : ivHud]))
            hudView.addConstraint(NSLayoutConstraint(item: ivHud, attribute: .CenterY, relatedBy: .Equal, toItem: hudView, attribute: .CenterY, multiplier: 1, constant: 0))
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = M_PI * 2
            animation.duration = 1
            animation.repeatCount = Float(Int.max)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.fillMode = kCAFillModeForwards
            ivHud.layer.addAnimation(animation, forKey: "rotation")
            
            
            
            hudView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(hudView)
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[hudView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["hudView" : hudView]))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[hudView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["hudView" : hudView]))
            hudView.layer.opacity = 0.5
            hudView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
                hudView.layer.opacity = 1
                hudView.transform = CGAffineTransformIdentity
                }) { (Bool) -> Void in
                    
            }
        }
        
    }
    
    func dismissHUD() {
        
        if let hudView = self.viewWithTag(100000) {
            
            hudView.removeFromSuperview()
        }
    
        
    }
    
}


extension UIViewController {
    func tokenExpired() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("navLogin")
            appDelegate.window?.rootViewController = controller
        }
    }
}

