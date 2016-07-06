//
//  TcountTransrcdFilter.swift
//  SPOS
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation
import UIKit

class TcountTransrcdFilter: UIViewController{
    @IBOutlet weak var stateAll: UIButton!
    
    @IBOutlet weak var stateSucs: UIButton!
    
    @IBOutlet weak var stateFild: UIButton!
    
    @IBOutlet weak var stateWait: UIButton!
    
    
    @IBOutlet weak var typeAll: UIButton!
    
    @IBOutlet weak var typeRecharge: UIButton!
    
    @IBOutlet weak var typeGetcash: UIButton!
    
    @IBOutlet weak var typeIncome: UIButton!
    
    @IBOutlet weak var typeBuyapp: UIButton!
    
    @IBOutlet weak var typeCashIn: UIButton!
    
    @IBOutlet weak var typeCashOut: UIButton!
    
    @IBOutlet weak var typeSaleCost: UIButton!
    
    @IBOutlet weak var typeOtherIncome: UIButton!
    
    @IBOutlet weak var typeOtherCost: UIButton!
    
    
    @IBOutlet weak var beginTimeLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var curSelectState:Int?
    var curSelectType:Int?
    
    @IBAction func rightButtonTaped(sender: AnyObject) {
        print(self.curSelectType)
        print(self.curSelectState)
        
        NSNotificationCenter.defaultCenter().postNotificationName("tcountTransRdsFilter", object: nil, userInfo: ["beginTime":self.beginTimeLab.text!,
                       "endTime":self.endTimeLab.text!,
                       "state":self.curSelectState!-10,
                       "type":self.curSelectType!-100])
        
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
    func functionStateButtonAction(item : UIButton)
    {
        print(item.tag)
        
        if (self.curSelectState == item.tag)
        {
          return
        }
        
        let preButton:UIButton = self.view.viewWithTag(self.curSelectState!) as! UIButton
        
        preButton.setBackgroundImage(UIImage.init(named: "Tcbtn"), forState: UIControlState.Normal)
        
        self.curSelectState = item.tag
        item.setBackgroundImage(UIImage.init(named: "Tcbth"), forState: UIControlState.Normal)
    }
    
    func functionTypeButtonAction(item : UIButton)
    {
        print(item.tag)
        
        if (self.curSelectType == item.tag)
        {
            return
        }
        
        let preButton:UIButton = self.view.viewWithTag(self.curSelectType!) as! UIButton
        preButton.setBackgroundImage(UIImage.init(named: "Tcbtn"), forState: UIControlState.Normal)
        
        self.curSelectType = item.tag
        item.setBackgroundImage(UIImage.init(named: "Tcbth"), forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.beginTimeLab.text = "2016-05-01"
        self.endTimeLab.text = "2016-05-04"

        self.displayDate()
        
        //self.stateAll.setBackgroundImage(UIImage.init(named: "Tcbtn"), forState: UIControlState.Normal)
        self.stateAll.setBackgroundImage(nil, forState: UIControlState.Selected)
        //self.stateAll.selected = true
        
        //state button tag 偏移值为10
        self.stateAll.addTarget(self, action: #selector(self.functionStateButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.stateAll.tag = 10;
        
        self.stateSucs.addTarget(self, action: #selector(self.functionStateButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.stateSucs.tag = 11;
        
        self.stateFild.addTarget(self, action: #selector(self.functionStateButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.stateFild.tag = 14;
        
        self.stateWait.addTarget(self, action: #selector(self.functionStateButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.stateWait.tag = 12;
        
        self.curSelectState = 10
        
        //type button tag 偏移值为100
        self.typeAll.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeAll.tag = 100;
        
        self.typeRecharge.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeRecharge.tag = 101;
        
        self.typeGetcash.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeGetcash.tag = 105;
        
        self.typeIncome.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeIncome.tag = 103;
        
        self.typeBuyapp.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeBuyapp.tag = 106;
        
        self.typeCashIn.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeCashIn.tag = 102;
        
        self.typeCashOut.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeCashOut.tag = 104;
        
        self.typeSaleCost.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeSaleCost.tag = 108;
        
        self.typeOtherCost.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeOtherCost.tag = 107;
        
        self.typeOtherIncome.addTarget(self, action: #selector(self.functionTypeButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.typeOtherIncome.tag = 109;
        
        self.curSelectType = 100
    }
    
    @IBAction func timeChanged(sender: UIDatePicker) {
        self.displayDate()
    }
    
    func displayDate()
    {
        let curDate:NSDate = self.datePicker.date
        let str:String = curDate.description
        print(str)
        
        print(curDate.timeIntervalSinceReferenceDate)
        
        let beginTime = curDate.timeIntervalSinceReferenceDate - 2592000
        let date1 = NSDate.init(timeIntervalSinceReferenceDate: beginTime)
        
        self.beginTimeLab.text = ((date1.description) as NSString).substringToIndex(10)
        self.endTimeLab.text = (str as NSString).substringToIndex(10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}