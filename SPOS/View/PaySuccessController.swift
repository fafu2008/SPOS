//
//  PaySuccessController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/8.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class PaySuccessController: UIViewController {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblCunsomMoney: UILabel!
    @IBOutlet weak var lblCouponMoney: UILabel!
    @IBOutlet weak var lblAccruedMoney: UILabel!
    @IBOutlet weak var lblDiscountMoney: UILabel!
    @IBOutlet weak var lblIntegral: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //支付成功并返回
    @IBAction func payFinishedToBack(sender: AnyObject) {
        
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
