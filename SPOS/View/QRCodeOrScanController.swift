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

    var style : PayStyle = .kQRCodeOrScan
    var amount : Double = 0
    @IBOutlet weak var lblAmount: UILabel! //支付金额
    @IBOutlet weak var btnQRCode: UIButton!//二维码
    @IBOutlet weak var btnScan: UIButton!//扫描二维码
    @IBOutlet weak var barcodeView: UIView!
    @IBOutlet weak var ivBarcode: UIImageView!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnQRCode.layer.borderColor = UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1).CGColor
        btnQRCode.layer.borderWidth = 1
        btnQRCode.layer.cornerRadius = 10
        btnQRCode.setTitleColor(UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1), forState: .Normal)
        btnQRCode.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnQRCode.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        btnQRCode.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1)), forState: .Highlighted)
        btnQRCode.clipsToBounds = true
        
        btnScan.layer.borderColor = UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1).CGColor
        btnScan.layer.borderWidth = 1
        btnScan.layer.cornerRadius = 10
        btnScan.setTitleColor(UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1), forState: .Normal)
        btnScan.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnScan.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        btnScan.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 90/255.0, blue: 0, alpha: 1)), forState: .Highlighted)
        btnScan.clipsToBounds = true
        
        lblAmount.text = String(format: "%.2lf", amount)
        
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
        self.navigationController?.navigationBar.overlayColor = UIColor(red: 1 , green: 96/255.0 , blue : 0 , alpha : 1)
        self.navigationController?.navigationBar.jh_setBackgroundColor(UIColor.clearColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Action
    
    @IBAction func goBack(sender: AnyObject) {
    }
    //展示二维码执行支付
    @IBAction func qrCodePay(sender: AnyObject) {
        self.view.showHUD()
        PayManager.doPay("Alipay", ord_name: "支付宝收银", original_amount: 100, discount_amount: 0, ignore_amount: 0, trade_amount: 100, auth_code: nil, callback: {[weak self] (aesValue , message) in
            self?.view.dismissHUD()
            if message.characters.count > 0 {
                self?.view.makeToast(message)
            }else{
                if aesValue.characters.count > 0 {
                    do {
                        if let json : [String : AnyObject] = try NSJSONSerialization.JSONObjectWithData(aesValue.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [String : AnyObject] {
                            if let trade_qrcode = json["trade_qrcode"] as? String {
                                self?.barcodeView.hidden = false
                                self?.ivBarcode.image = ScanWrapper.createCode("CIQRCodeGenerator", codeString: trade_qrcode, size: CGSizeMake(SCREENWIDTH/3, SCREENWIDTH/3), qrColor: UIColor.blackColor(), bkColor: UIColor.whiteColor())
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

}
