//
//  TcountChangeCash.swift
//  SPOS
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation
import UIKit

class TcountChangeCash: UIViewController,APNumberPadDelegate{
    
    var amount:String?
    var bankName:String?
    var bankNo:String?
    
    @IBOutlet weak var cashNumLab: UILabel!
    
    @IBOutlet weak var bankCountLab: UILabel!
    
    @IBOutlet weak var bankNoLab: UILabel!
    
    @IBOutlet weak var explainButton: UIButton!
    
    
    
    @IBOutlet weak var numCleanButton: UIButton!
    
    func set_count_info(amount:String, bank_name:String, bank_no:String)
    {
        self.amount = amount
        self.bankName = bank_name
        self.bankNo = bank_no
    }
    
    @IBAction func explainButtonTaped(sender: AnyObject) {
        //提现说明
    }
    
    func changeCashRequest()
    {
        let data : [String : AnyObject] = ["amount" : self.cashNumLab.text!]
        //let data : [String : AnyObject] = ["page" : "1","pagesize" : "9"]
        let (token , param) = DefaultKit.packageParam(data)
        
        if (param == nil)
        {
            print("changeCash error")
            return
        }
        
        let manager = AFNetworkingManager()
        manager.postRequest("accountshop/cash?token=\(token!)", postData: param, callback: {[weak self] (dic, error) in
        //manager.postRequest("shopappstore?token=\(token!)", postData: param, callback: {[weak self] (dic, error) in
            
            if let value = dic as? [String : AnyObject] {
                
                print(value)
                
                if value["errcode"] as? Int == 0 {
                    NSNotificationCenter.defaultCenter().postNotificationName("changeCashNotify", object: nil)
                    
                    self?.navigationController?.popViewControllerAnimated(true)
                }
                else
                {
                    self!.view.makeToast(value["msg"] as! String)
                }
            }
        })
    }
    
    @IBAction func changeCashButtonTaped(sender: AnyObject) {
        if (self.cashNumLab.text!.hasPrefix("可提现") == true)
        {
            self.view.makeToast("请输入金额")
            return
        }
        
        self.changeCashRequest()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cashNumLab.text = "可提现"+self.amount!+"元"
        self.cashNumLab.textColor = BASE_TEXT_GRAYCOLOR
        self.bankCountLab.text = self.bankName
        self.bankNoLab.text = self.bankNo
        
        let rect = CGRectMake(0, SCREENHEIGHT-(SCREENWIDTH*0.75), SCREENWIDTH, (SCREENWIDTH*0.75))
        let numberPad = APNumberPad.init(delegate: self, withFrame:rect, displayLable:cashNumLab)
        
        numberPad.leftFunctionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(numberPad)
        
        let button_line = DefaultKit.makeLine(CGRectMake(1, 19, 56, 1), color: BASE_TEXT_GRAYCOLOR)
        self.explainButton.addSubview(button_line)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = self.parentViewController as? MenuViewController {
            controller.addPanGestureRecognizer()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let controller = self.parentViewController as? MenuViewController {
            controller.removePanGestureRecognizer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}