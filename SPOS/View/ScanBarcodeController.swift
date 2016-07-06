//
//  ScanBarcodeController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ScanBarcodeController: UIViewController {
    
    var duration = 5.0
    
    @IBOutlet weak var cameraView: UIView!  //摄像头界面
    @IBOutlet weak var ivScanLine: UIImageView! //扫描浮动条
    
    @IBOutlet weak var lblOrderAmount: UILabel! //订单总额
    @IBOutlet weak var lblOrderNo: UILabel! //订单编号
    
    @IBOutlet weak var tConstraint: NSLayoutConstraint! //浮动条约束
    @IBOutlet weak var scanMaskView: ScanMaskView!
    
    
    var scanCamera : ScanWrapper? //扫描
    var bPause = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSelector(#selector(ScanBarcodeController.scanLineMovedownAndUp), withObject: nil, afterDelay: 0.1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.overlayColor = UIColor(red: 1 , green: 96/255.0 , blue : 0 , alpha : 1)
        self.navigationController?.navigationBar.jh_setBackgroundColor(UIColor.clearColor())
        
        
        if(!CameraPermission.isGetCameraPermission())
        {
            
        }else{
            if scanCamera == nil {
                scanCamera = ScanWrapper(videoPreView: cameraView, cropRect: ScanMaskView.getScanRectWithPreView(), success: {[weak self] (content) in
                    //处理扫码到用户信息后
                    self?.bPause = true
                    self?.ivScanLine.hidden = true
                    self?.view.showHUD()
                    PayManager.doPay("Alipay", ord_name: "支付宝收银", original_amount: 100, discount_amount: 0, ignore_amount: 0, trade_amount: 100, auth_code: content, callback: {[weak self] (aesValue , message) in
                        if message.characters.count > 0 {
                            self?.view.dismissHUD()
                            self?.view.makeToast(message)
                        }else{
                            if aesValue.characters.count > 0 {
                                self?.judgePayStatus(aesValue)
                            }else{
                               self?.view.dismissHUD()
                            }
                        }
                        })
                    
                    })
            }
            
            scanCamera?.start()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        scanCamera?.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Action
    //扫码不成功
    @IBAction func scanFailure(sender: AnyObject) {
        self.performSegueWithIdentifier("toScanFailure", sender: self)
    }
    
    //扫码帮助
    @IBAction func scanHelp(sender: AnyObject) {
        self.performSegueWithIdentifier("toScanHelp", sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
 
    
    // MARK: -Other
    func scanLineMovedownAndUp() {
        if tConstraint.constant == 0 {
            tConstraint.constant = SCREENWIDTH * 800 / 1242 - 15
        }else{
            tConstraint.constant = 0
        }
        UIView.animateWithDuration(2, animations: {
            [weak self] in
            self?.scanMaskView.layoutIfNeeded()
            }) {[weak self] (value) in
                if self?.bPause == true {
                    
                }else{
                    self?.scanLineMovedownAndUp()
                }
        }
    }
    
    /**
     判断订单支付状态
     - parameter value: 后台返回的json字符串
     */
    func judgePayStatus(value : String)  {
        do{
            let data  = try NSJSONSerialization.JSONObjectWithData(value.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            if let dicData = data as? [String : AnyObject] {
                var status = dicData["status"] as? Int ?? 0
                if status == 0 {
                    status = Int(dicData["status"] as? String ?? "0")!
                }
                print(status)
                if status == 1 {
                    self.view.dismissHUD()
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("paySuccess") as! PaySuccessController
                    self.navigationController?.pushViewController(controller, animated: true)
                }else if status == 4 {
                    
                }else if status == 2{
                    getOrderStatus(dicData["ord_no"] as? String ?? "")
                }
            }
            
        }catch{
            self.view.dismissHUD()
        }
    }
    
    /**
     读取订单状态
     - parameter order_no: 订单编号
     */
    func getOrderStatus(order_no : String) {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            let data : [String : AnyObject] = ["ord_no" : order_no]
            
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
                    manager.postRequest("paystatus?token=\(token)", postData: ["sign" : sign! , "data" : aesString] ,duration : duration, callback: {[weak self] (data, error) in
                        
                        if error != nil {
                            print(error)
                            if error?.code == -1009 {
                                print("异常订单")
                                return
                            }else if error?.code == -1001 {
                                //连接超时
                                self!.duration *= 2
                                if self!.duration > 60 {
                                    self!.duration = 60
                                }
                                self?.getOrderStatus(order_no)
                            }
                            
                        }
                        
                        if let value = data as? [String : AnyObject] {
                            print("查询订单状态返回：\(value)")
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
                                            self?.judgePayStatus(aesValue)
                                        }
                                        
                                    }else{
                                        print("验签没通过")
                                       
                                    }
                                    
                                }
                                
                            }else if value["errcode"] as? Int > 0 {
                                if let message = data?["msg"] as? String {
                                    print(message)
                                }
                            }
                        }
                    })
                }
                
            }catch{
                
            }
        }
    }
    
    /**
     取消订单支付
     - parameter order_no: 订单编号
     */
    func payCancel(order_no : String) {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            let data : [String : AnyObject] = ["ord_no" : order_no]
            
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
                    manager.postRequest("paycancel?token=\(token)", postData: ["sign" : sign! , "data" : aesString] , callback: {[weak self] (data, error) in
                        
                        if let value = data as? [String : AnyObject] {
                            print("取消订单状态返回：\(value)")
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
                                if let message = data?["msg"] as? String {
                                    print(message)
                                }
                            }
                        }
                    })
                }
                
            }catch{
                
            }
        }
    }

}
