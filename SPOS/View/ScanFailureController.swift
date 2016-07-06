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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置提交的倒角
        btnSubmit.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 204/255.0, green: 76/255.0, blue: 0, alpha: 1)), forState: .Highlighted)
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
