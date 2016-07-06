//
//  RevokeResultController.swift
//  SPOS
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation
import UIKit

class RevokeResultController: UIViewController{
    @IBOutlet weak var resultLab: UILabel!
    
    @IBAction func okButtonTaped(sender: AnyObject) {
        let controller = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    var str:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PaySuccessController.back))
        button.image = UIImage.init(named: "back")
        
        let spacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [spacer,button]
        
        if (str != nil)
        {
            self.resultLab.text = str
        }
    }
    
    func back()
    {
        let controller = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(controller!, animated: true)
    }
}