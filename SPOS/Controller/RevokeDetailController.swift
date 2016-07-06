//
//  RevokeDetailController.swift
//  SPOS
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation

import UIKit

class RevokeDetailController: UIViewController{
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblOrderNo: UILabel!
    
    @IBOutlet weak var lblTradeTime: UILabel!
    
    var consumeRevokeVM = ConsumeRevokeViewModel()  //订单撤销ViewModel
    var shop_pass : String? //主管密码
    var dic:[String : AnyObject]?
    var resultString : String?
    
    @IBAction func cancelButtonTaped(sender: AnyObject) {
        if (self.lblOrderNo.text == nil || self.shop_pass == nil)
        {
            return
        }
        
        consumeRevokeVM.consumeRevokeByOrder(self.lblOrderNo.text!, shop_pass: shop_pass!, callback: { [weak self] (data, message) in
            if message?.characters.count > 0 {
                self!.resultString = message
            }
            else
            {
                self!.resultString = "退款成功!"
            }
            
            let orderCD = CDOrder()
            orderCD.deleteOrder(self!.lblOrderNo.text!)
            
            self!.performSegueWithIdentifier("revoke_result", sender: self)
            
            })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "revoke_result")
        {
            let controller = segue.destinationViewController as! RevokeResultController
            controller.str = self.resultString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.dic)
        
        self.lblAmount.text = DefaultKit.change_string_to_float(dic!["trade_amount"] as! String)
        self.lblAmount.textColor = BASE_TEXT_GRAYCOLOR
        self.lblOrderNo.text = dic!["ord_no"] as! String
        self.lblOrderNo.textColor = BASE_TEXT_GRAYCOLOR
        self.lblTradeTime.text = dic!["trade_pay_time"] as! String
        self.lblTradeTime.textColor = BASE_TEXT_GRAYCOLOR
    }
}
