//
//  ImportOrderNoController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ImportOrderNoController: UIViewController , ScanBarcodeDelegate{

    @IBOutlet weak var tfBarcode: UITextField!  //订单输入框
    @IBOutlet weak var btnSubmit: UIButton! //确定按钮
    
    
    var shop_pass : String? //主管密码
    //var consumeRevokeVM = ConsumeRevokeViewModel()  //订单撤销ViewModel
    var dic:[String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingSubView()
    }
    
    //设置视图属性
    func settingSubView() {
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.clipsToBounds = true
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Normal)
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(BASE_UICOLOR), forState: .Highlighted)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -Action
    //扫二维码
    @IBAction func scanBarcode(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("scanBarcode") as! ScanBarcodeController
        controller.isCommonScan = true
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //提交订单号
    @IBAction func submitOrderNo(sender: AnyObject) {
        tfBarcode.resignFirstResponder()
        if let barcode = tfBarcode.text {
            let ord_no = barcode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if ord_no.characters.count > 0 {
                //modify by yushaopeng
                /*
                consumeRevokeVM.consumeRevokeByOrder(ord_no, shop_pass: shop_pass!, callback: { [weak self] (data, message) in
                    if message?.characters.count > 0 {
                        self?.view.makeToast(message!)
                    }
                    else
                    {
                        
                    }
                })
                */
                self.getOrderStatus(ord_no)
                
                return
            }
        }
        self.view.makeToast("请输入交易订单号")
        
    }
    
    
    
    // MARK: - Navigation
    
    //ScanBarcodeDelegate
    func scanBarcodeWithContent(content: String) {
        tfBarcode.text = content
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
                                            
                                            do{
                                                let data  = try NSJSONSerialization.JSONObjectWithData(aesValue.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
                                                if let dicData = data as? [String : AnyObject] {
                                                    self!.dic = dicData
                                                    self!.performSegueWithIdentifier("revoke_detail", sender: self)
                                                }
                                                
                                            }catch{
                                                
                                            }
                                            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "revoke_detail")
        {
            let controller = segue.destinationViewController as! RevokeDetailController
            controller.dic = self.dic
            controller.shop_pass = self.shop_pass
        }
    }
}
