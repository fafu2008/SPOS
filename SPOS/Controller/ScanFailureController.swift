//
//  ScanFailureController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/15.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ScanFailureController: UIViewController {

    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var btnClearText: UIButton!
    @IBOutlet weak var tfBarcode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var codeField: UITextField!
    
    var amount: Int = 0
    var ori_amount = 0
    var disc_amount = 0
    var timer:NSTimer?
    var pay_type:Int = 0
    let request_timeInterval = 6.0 //重新请求时间间隔
    
    var type_name:String?
    var order_name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(animated: Bool) {
        if let timer_exit = self.timer{
            timer_exit.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTaped(sender: AnyObject) {
        self.codeField.text = nil
    }

    @IBAction func okButtonTaped(sender: AnyObject) {
        
        print(self.codeField.text)
        if (self.codeField.text == nil || self.codeField.text == "")
        {
            self.view.makeToast("付款码不能为空")
            return
        }
        
        self.view.showHUD()
        
        var type_name:String?
        var order_name:String?
        
        if (self.pay_type == PAY_TYPE_ZHIFUBAO)
        {
            type_name = "Alipay"
            order_name = "支付宝收银"
        }
        else if (self.pay_type == PAY_TYPE_WEIXIN)
        {
            type_name = "Weixin"
            order_name = "微信收银"
        }
        else if (self.pay_type == PAY_TYPE_BAIDU)
        {
            type_name = "Baifubao"
            order_name = "百度钱包收银"
        }
        else
        {
            print("不支持的收银方式")
            return
        }
        
        PayManager.doPay(type_name!, ord_name: order_name!, original_amount: self.ori_amount, discount_amount: self.disc_amount, ignore_amount: 0, trade_amount: self.amount, auth_code: self.codeField.text, order_no : nil,callback: {[weak self] (aesValue , message) in
            self?.view.dismissHUD()
            if message.characters.count > 0 {
                self?.view.makeToast(message)
            }else{
                if aesValue.characters.count > 0 {
                    self?.judgePayStatus(aesValue)
                }else{
                    self?.view.dismissHUD()
                }
            }
            })
    }
    
    /**
     判断订单支付状态
     - parameter value: 后台返回的json字符串
     */
    func request_timer_time_out(timer: NSTimer)
    {
        self.getOrderStatus((timer.userInfo as? String)!)
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
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("paySuccess") as! PaySuccessController
                    controller.dic = dicData
                    self.navigationController?.pushViewController(controller, animated: true)
                }else if status == 4 {
                    
                }else if status == 2{
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(self.request_timeInterval, target: self, selector:#selector(self.request_timer_time_out(_:)), userInfo: dicData["ord_no"] as? String, repeats: false)
                }
            }
            
        }catch{
            self.view.dismissHUD()
        }
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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

    
    // MARK: -Action
    //清空条形码内容
    @IBAction func clearText(sender: AnyObject) {
    }

    //提交条形码
    @IBAction func submitBarcode(sender: AnyObject) {
    }
}
