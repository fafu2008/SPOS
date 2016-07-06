//
//  CashierDeskController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/29.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class CashierDeskController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var btnCashierDesk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        settingCashierDeskButton()
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
    
    //设置我要收银按钮
    func settingCashierDeskButton() {
        btnCashierDesk.layer.borderColor = UIColor(red: 0, green: 161/255.0, blue: 238, alpha: 1).CGColor
        btnCashierDesk.layer.borderWidth = 1
        btnCashierDesk.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0, green: 161/255.0, blue: 238, alpha: 1)), forState: .Highlighted)
        btnCashierDesk.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnCashierDesk.clipsToBounds = true
        btnCashierDesk.layer.cornerRadius = SCREENWIDTH * 968 / 1242 / 4
    }
    
    //我要收银
    @IBAction func startCashier(sender: AnyObject) {
        self.performSegueWithIdentifier("toCalculater", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: -CollectionViewDatasource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SYTCell
        
        switch indexPath.row {
        case 0:
            cell.ivLOGO.image = UIImage(named: "xfcx")
            cell.lblTitle.text = "消费撤销"
        case 1:
            cell.ivLOGO.image = UIImage(named: "jjb")
            cell.lblTitle.text = "交接班"
        case 2:
            cell.ivLOGO.image = UIImage(named: "dy")
            cell.lblTitle.text = "打印"
        case 3:
            cell.ivLOGO.image = UIImage(named: "pjs")
            cell.lblTitle.text = "批结算"
        case 4:
            cell.ivLOGO.image = UIImage(named: "ycdd")
            cell.lblTitle.text = "异常订单"
        case 5:
            cell.ivLOGO.image = UIImage(named: "dysz")
            cell.lblTitle.text = "打印设置"
        case 6:
            cell.ivLOGO.image = UIImage(named: "sjbb")
            cell.lblTitle.text = "数据报表"
        default:
            cell.ivLOGO.image = nil
            cell.lblTitle.text = ""
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((SCREENWIDTH - 3) / 4, (SCREENWIDTH * 480 / 1242 - 3) / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 0, 1, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("toConsumeRevoke", sender: self)
        case 1:
            self.performSegueWithIdentifier("toSignInOrOut", sender: self)
        case 2:
            self.performSegueWithIdentifier("toPrintOrder", sender: self)
        case 4:
            self.performSegueWithIdentifier("toExceptionOrder", sender: self)
        case 5:
            self.performSegueWithIdentifier("toPrintSetting", sender: self)
        default:
            print("")
        }
    }

}
