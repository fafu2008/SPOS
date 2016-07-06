//
//  QRCodeOrScanController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/12.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

enum PayStyle : Int {
    case kQRCode = 0 , kScan , kQRCodeOrScan
}


class QRCodeOrScanController: UIViewController {

    var timer:NSTimer?
    let request_timeInterval = 6.0 //重新请求时间间隔
    var style : PayStyle = .kQRCodeOrScan
    var amount : Int = 0
    var or_amount : Int = 0
    var disc_amount : Int = 0
    var order_type : String?
    
    @IBOutlet weak var lblAmount: UILabel! //支付金额
    @IBOutlet weak var btnQRCode: UIButton!//二维码
    @IBOutlet weak var btnScan: UIButton!//扫描二维码
    @IBOutlet weak var barcodeView: UIView!
    @IBOutlet weak var ivBarcode: UIImageView!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnQRCode.layer.borderColor = BASE_UICOLOR.CGColor
        btnQRCode.layer.borderWidth = 1
        btnQRCode.layer.cornerRadius = 10
        btnQRCode.setTitleColor(BASE_UICOLOR, forState: .Normal)
        btnQRCode.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnQRCode.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        btnQRCode.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Highlighted)
        btnQRCode.clipsToBounds = true
        
        btnScan.layer.borderColor = BASE_UICOLOR.CGColor
        btnScan.layer.borderWidth = 1
        btnScan.layer.cornerRadius = 10
        btnScan.setTitleColor(BASE_UICOLOR, forState: .Normal)
        btnScan.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnScan.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        btnScan.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Highlighted)
        btnScan.clipsToBounds = true
        
        let doubleVar : Float = Float(self.amount)
        lblAmount.text = String(format: "%.2lf", doubleVar/100)
        
        if style == .kQRCode {
            btnQRCode.hidden = false
            btnScan.hidden = true
        }else if style == .kScan {
            btnQRCode.hidden = true
            btnScan.hidden = false
        }else {
            btnQRCode.hidden = false
            btnScan.hidden = false
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.overlayColor = UIColor(red: 0 , green: 161/255.0 , blue : 238 , alpha : 1)
        self.navigationController?.navigationBar.jh_setBackgroundColor(UIColor.clearColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
        
        //add by yushaopeng
        if let timer_exit = self.timer{
            timer_exit.invalidate()
        }
        //end add
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Action
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //展示二维码执行支付
    @IBAction func qrCodePay(sender: AnyObject) {
        self.view.showHUD()
        
        var order_name:String?
        
        if (self.title == "支付宝")
        {
            order_name = "支付宝收银"
        }
        else if (self.title == "微信支付")
        {
            order_name = "微信收银"
        }
        else if (self.title == "百度钱包")
        {
            order_name = "百度钱包收银"
        }
        else
        {
            print("不支持的收银方式")
            return
        }
        
        if (self.order_type == nil)
        {
            print("不支持的收银方式")
            return
        }
    
        PayManager.doPay(self.order_type!, ord_name: order_name!, original_amount: self.or_amount, discount_amount: self.disc_amount, ignore_amount: 0, trade_amount: self.amount, auth_code: nil, order_no : nil,callback: {[weak self] (aesValue , message) in
            self?.view.dismissHUD()
            if message.characters.count > 0 {
                self?.view.makeToast(message)
            }else{
                if aesValue.characters.count > 0 {
                    do {
                        if let json : [String : AnyObject] = try NSJSONSerialization.JSONObjectWithData(aesValue.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [String : AnyObject] {
                            if let trade_qrcode = json["trade_qrcode"] as? String {
                                
                                self?.lblOrderNo.text = "订单编号:"+(json["ord_no"] as? String)!
                                self?.lblMoney.text = "交易金额:"+self!.lblAmount.text!
                                
                                self?.barcodeView.hidden = false
                                self?.ivBarcode.image = ScanWrapper.createCode("CIQRCodeGenerator", codeString: trade_qrcode, size: CGSizeMake(SCREENWIDTH/3, SCREENWIDTH/3), qrColor: UIColor.blackColor(), bkColor: UIColor.whiteColor())
                                
                                self?.timer = NSTimer.scheduledTimerWithTimeInterval(self!.request_timeInterval, target: self!, selector:#selector(QRCodeOrScanController.request_timer_time_out(_:)), userInfo: json["ord_no"] as? String, repeats: false)
                                
                                //timer.fire()
                                
                                //self!.getOrderStatus((json["ord_no"] as? String)!)
                            }
                        }
                        
                    }catch {
                    
                    }
                }
            }
        })
    }
    
    //扫描二维码进行支付
    @IBAction func scanPay(sender: AnyObject) {
        self.performSegueWithIdentifier("toScanBarcode", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //add by yushaopeng
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toScanBarcode")
        {
            let controller = segue.destinationViewController as! ScanBarcodeController
            controller.amount = self.amount
            controller.or_amount = self.or_amount
            controller.disc_amount = self.disc_amount
            
            if (self.title == "支付宝")
            {
                controller.pay_type = PAY_TYPE_ZHIFUBAO
            }
            else if (self.title == "微信支付")
            {
                controller.pay_type = PAY_TYPE_WEIXIN
            }
            else if (self.title == "百度钱包")
            {
                controller.pay_type = PAY_TYPE_BAIDU
            }
        }
    }
    
    func request_timer_time_out(timer: NSTimer)
    {
        print(timer.userInfo)
        self.getOrderStatus((timer.userInfo as? String)!)
    }
    
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
                    manager.postRequest("paystatus?token=\(token)", postData: ["sign" : sign! , "data" : aesString] ,duration : 6, callback: {[weak self] (data, error) in
                        
                        if error != nil {
                            print(error)
                            if error?.code == -1009 {
                                print("异常订单")
                                return
                            }else if error?.code == -1001 {
                                //连接超时
                                
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
                    controller.dic = dicData
                    self.navigationController?.pushViewController(controller, animated: true)
                }else if status == 4 {
                    
                }else if status == 2{
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(self.request_timeInterval, target: self, selector:#selector(QRCodeOrScanController.request_timer_time_out(_:)), userInfo: dicData["ord_no"] as? String, repeats: false)
                    
                }
            }
            
        }catch{
            self.view.dismissHUD()
        }
    }
    //end add
}
