//
//  ImportOrderNoController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ImportOrderNoController: UIViewController {

    @IBOutlet weak var tfBarcode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -Action
    //扫二维码
    @IBAction func scanBarcode(sender: AnyObject) {
    }
    
    //提交订单号
    @IBAction func submitOrderNo(sender: AnyObject) {
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
