//
//  CalculaterController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/29.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit


class CalculaterController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var pmt_type = ""
    var pmt_tag : String = ""
    var cachedResult = "" //缓存计算中的结果
    let cdPayWay = CDPayWay()
    
    @IBOutlet weak var vPayInfo: UIView! //付款信息
    @IBOutlet weak var vPayType: UIView! //付款类型选择
    @IBOutlet weak var vCalculater: UIView! //计算器
    @IBOutlet weak var vCashIn: UIView!
    @IBOutlet weak var lblCashIn: UILabel! //收银、＝
    @IBOutlet weak var lblResult: UILabel!//计算器计算的结果
    @IBOutlet weak var lblConsume: UILabel! //消费金额
    @IBOutlet weak var lblPreferential: UILabel! //优惠金额
    @IBOutlet weak var lblNeedPay: UILabel! //应付金额
    
    @IBOutlet weak var tConstraint: NSLayoutConstraint! //计算器滚动条的顶部约束
    @IBOutlet weak var ttConstraint: NSLayoutConstraint! //支付方式和支付清单的竖直距离约束
    
    @IBOutlet weak var svResult: UIScrollView! //显示最终的计算结果（滚动条）
    @IBOutlet weak var cvCalculater: UICollectionView!
    @IBOutlet weak var cvPayType: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //给收银按钮添加单击手势
        let tapCashIn = UITapGestureRecognizer(target: self, action: #selector(CalculaterController.tapCashIn(_:)))
        tapCashIn.numberOfTapsRequired = 1
        vCashIn.addGestureRecognizer(tapCashIn)
        
        //设置计算总额的上约束
        let svHeight = SCREENHEIGHT - 64 - SCREENWIDTH * 1500 / 1242
        if svHeight > 62 {
            tConstraint.constant = svHeight - 62 - 5
        }
        
        handlePayTypeList()
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
       
    }
    
    //抹零
    //注奖分角清空为零，或者取消抹零
    @IBAction func deleteMJToZeroOrNot(sender: AnyObject) {
        
    }
    
    //改价
    //修改价格，或者取消修改价格
    @IBAction func updateMoney(sender: AnyObject) {
        
        let supervisorPWD = self.storyboard?.instantiateViewControllerWithIdentifier("supervisorPWD") as! SupervisorPWDController
        if #available(iOS 8.0, *) {
            supervisorPWD.modalPresentationStyle = .OverCurrentContext
        } else {
            supervisorPWD.modalPresentationStyle = .CurrentContext
        }
        self.presentViewController(supervisorPWD, animated: true) { 
            
        }
        
    }
    
    
    //点击收银按钮触发事件
    func tapCashIn(recognizer : UITapGestureRecognizer) {
        if recognizer.state == .Began {
            vCashIn.backgroundColor = UIColor(red: 179/255.0, green: 62/255.0, blue: 15/255.0, alpha: 1)
        }else if recognizer.state == .Ended {
            vCashIn.backgroundColor = UIColor(red: 179/255.0, green: 62/255.0, blue: 15/255.0, alpha: 1)
        self.performSelector(#selector(CalculaterController.settingCashInBackgroud), withObject: nil, afterDelay: 0.1)
            handleResult()
       }else if recognizer.state == .Cancelled {
        
            vCashIn.backgroundColor = UIColor(red: 179/255.0, green: 62/255.0, blue: 15/255.0, alpha: 1)
            self.performSelector(#selector(CalculaterController.settingCashInBackgroud), withObject: nil, afterDelay: 0.1)
        }
    }
    
    //由于没触发效果，手动设置下
    func settingCashInBackgroud() {
        vCashIn.backgroundColor = UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1)
    }
    
    func handleResult() {
        if lblCashIn.text == "=" {
            lblCashIn.text = "收钱"
            let text = lblResult.text!
            let nums = text.componentsSeparatedByString("+")
            var result = 0.0
            for num in nums {
                result += Double(num) ?? 0.0
            }
            cachedResult = text
            let resultString = String(format: "%.2lf", result)
            let size = (resultString as NSString).boundingRectWithSize(CGSizeMake(SCREENWIDTH - 10, 10000), options: [.UsesFontLeading , .UsesLineFragmentOrigin], attributes: [NSFontAttributeName : UIFont.systemFontOfSize(52)], context: nil).size
            let svHeight = SCREENHEIGHT - 64 - SCREENWIDTH * 1500 / 1242
            if size.height + 5 > svHeight {
                tConstraint.constant = 0
                svResult.contentOffset = CGPointMake(0, size.height - svHeight + 5)
            }else{
                tConstraint.constant = svHeight - size.height - 5
                svResult.contentOffset = CGPointZero
            }
            lblResult.text = resultString
        }else{
            
            vPayInfo.hidden = false
            vPayType.hidden = false
            let text = lblResult.text!
            lblConsume.text = String(format: "%.2lf", Double(text)!)
            lblNeedPay.text = String(format: "%.2lf", Double(text)!)
        }
    }
    
    //获取付款方式
    func handlePayTypeList() {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            if let signString = DefaultKit.signString(token, data: nil) {
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                let manager = AFNetworkingManager()
                manager.postRequest("/paylist?token=\(token)", postData: ["sign" : sign], callback: { [weak self] (dic, err) in
                    if let value = dic as? [String : AnyObject] {
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
                                        print(aesValue)
                                        do {
                                            let payWayList : [[String : AnyObject]] = try NSJSONSerialization.JSONObjectWithData(aesValue.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as! [[String : AnyObject]]
                                            
                                            if payWayList.count > 0 {
                                                let payWays = self!.cdPayWay.selectObject("PayWay")
                                                if payWays.count > 0 {
                                                    self!.cdPayWay.deleteObject("PayWay")
                                                }
                                                self!.cdPayWay.insertObject("PayWay", dic: payWayList)//插入
                                                
                                            }
                                            self?.cvPayType.reloadData() //刷新
                                        }catch {
                                            
                                        }
                                        
                                    }
                                    
                                }else{
                                    print("验签没通过")
                                }
                                
                            }
                        }else if value["errcode"] as? Int > 0 {
                            
                        }else{
                            
                        }
                    }
                })
            }
        }
        
    }
    
    //判断是否包含主扫 和 被扫
    func getPayStyle() -> PayStyle {
        if pmt_type.characters.count > 0 {
            if pmt_type.containsString(",") && pmt_type == "2,3" {
                return .kQRCodeOrScan
            }else if pmt_type == "2" {
                return .kQRCode
            }else if pmt_type == "3" {
                return .kScan
            }
        }
        return .kQRCodeOrScan
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? QRCodeOrScanController {
            let result = lblResult.text //最终的金额
            controller.amount = Double(result!)!
            if pmt_tag == "Alipay" {
                controller.title = "支付宝"
                controller.style = getPayStyle()
            }else if pmt_tag == "Weixin" {
                controller.title = "微信支付"
                controller.style = getPayStyle()
            }else if pmt_tag == "Baifubao" {
                controller.title = "百度钱包"
                controller.style = getPayStyle()
            }
        }
    }
 
    
    // MARK: -UICollectionViewDataSource and UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvCalculater {
            return 16
        }else{
            return cdPayWay.payWayCount()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == cvCalculater {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CalculaterCell
            switch indexPath.row {
            case 0:
                cell.lblContent.text = "1"
                cell.ivIcon.image = nil
            case 1:
                cell.lblContent.text = "2"
                cell.ivIcon.image = nil
            case 2:
                cell.lblContent.text = "3"
                cell.ivIcon.image = nil
            case 3:
                cell.lblContent.text = ""
                cell.ivIcon.image = UIImage(named: "clearCalculater")
            case 4:
                cell.lblContent.text = "4"
                cell.ivIcon.image = nil
            case 5:
                cell.lblContent.text = "5"
                cell.ivIcon.image = nil
            case 6:
                cell.lblContent.text = "6"
                cell.ivIcon.image = nil
            case 7:
                cell.lblContent.text = "清空"
                cell.ivIcon.image = nil
            case 8:
                cell.lblContent.text = "7"
                cell.ivIcon.image = nil
            case 9:
                cell.lblContent.text = "8"
                cell.ivIcon.image = nil
            case 10:
                cell.lblContent.text = "9"
                cell.ivIcon.image = nil
            case 12:
                cell.lblContent.text = "."
                cell.ivIcon.image = nil
            case 13:
                cell.lblContent.text = "0"
                cell.ivIcon.image = nil
            case 14:
                cell.lblContent.text = "+"
                cell.ivIcon.image = nil
            default:
                cell.lblContent.text = ""
                cell.ivIcon.image = nil
            }
            if indexPath.row == 3 || indexPath.row == 7 {
                cell.ivBG.image = UIImage.imageWithColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1))
            }else{
                cell.ivBG.image = UIImage.imageWithColors([UIColor.whiteColor() , UIColor(red:230/255.0 , green:230/255.0 , blue : 230/255.0 , alpha : 1 )], size: CGSizeMake((SCREENWIDTH - 3) / 4, (SCREENWIDTH * 1500 / 1242 - 3)/4))
            }
            
            if indexPath.row == 7 {
                cell.lblContent.font = UIFont.systemFontOfSize(18)
            }else{
                cell.lblContent.font = UIFont.systemFontOfSize(52)
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CCell", forIndexPath: indexPath)
            let ivIcon = cell.contentView.viewWithTag(888) as! UIImageView
            let lblTitle = cell.contentView.viewWithTag(889) as! UILabel
            
            let payWay = cdPayWay.payWayWithRow(indexPath.row)
            ivIcon.sd_setImageWithURL(NSURL(string: payWay.pmt_icon!), placeholderImage: UIImage(named: "DefaultIcon"))
            lblTitle.text = payWay.pmt_name
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == cvCalculater {
            var text = lblResult.text!
            let row = indexPath.row
            switch row {
            case 0 , 1 , 2 , 4 , 5 ,6 , 8 , 9, 10 :
                
                var value = 0
                if row <= 2 {
                    value = row + 1
                }else if row <= 6 {
                    value = row
                }else{
                    value = row - 1
                }
                if cachedResult.characters.count > 0 {
                    
                }else if text == "0" {
                    text = "\(value)"
                }else if text.hasSuffix(".") || text.hasSuffix("+"){
                    text += "\(value)"
                }else if text.containsString("+"){
                    
                    if let range = text.rangeOfString("+", options: .BackwardsSearch, range: text.startIndex..<text.endIndex, locale: nil){
                        let lastNum = text.substringFromIndex(range.startIndex.advancedBy(1))
                        if lastNum.containsString(".") {
                            if lastNum.rangeOfString(".")?.endIndex == lastNum.endIndex.advancedBy(-1) {
                                text += "\(value)"
                            }else{
                                
                            }
                        }else{
                            if lastNum.characters.count >= 7 {
                                
                            }else{
                                text += "\(value)"
                            }
                        }
                    }
                    
                }else{
                    if text.containsString(".") {
                        if text.rangeOfString(".")?.endIndex == text.endIndex.advancedBy(-1) {
                            text += "\(value)"
                        }else{
                            
                        }
                    }else{
                        if text.characters.count >= 7 {
                            
                        }else{
                            text += "\(value)"
                        }
                    }
                }
            case 3 :
                if cachedResult.characters.count > 0 {
                    if let range = cachedResult.rangeOfString("+", options: .BackwardsSearch, range: cachedResult.startIndex..<cachedResult.endIndex, locale: nil){
                        text = cachedResult.substringToIndex(range.startIndex)
                        cachedResult = ""
                    }
                    
                }else{
                    if let range = text.rangeOfString("+", options: .BackwardsSearch, range: text.startIndex..<text.endIndex, locale: nil){
                        text = text.substringToIndex(range.startIndex)
                    }else{
                        if text.characters.count == 1 {
                            text = "0"
                        }else{
                            text = text.substringToIndex(text.endIndex.advancedBy(-1))
                        }
                    }
                }
            case 7:
                text = "0"
                cachedResult = ""
            case 12:
                if cachedResult.characters.count == 0 {
                    if let range = text.rangeOfString("+", options: .BackwardsSearch, range: text.startIndex..<text.endIndex, locale: nil){
                        let lastNum = text.substringFromIndex(range.startIndex.advancedBy(1))
                        if lastNum.containsString(".") == false && lastNum.characters.count <= 7 {
                            text += "."
                        }
                    }else{
                        if text.containsString(".") == false && text.characters.count <= 7 {
                            text += "."
                        }
                    }
                }
            case 13:
                if cachedResult.characters.count == 0 {
                    if let range = text.rangeOfString("+", options: .BackwardsSearch, range: text.startIndex..<text.endIndex, locale: nil){
                        let lastNum = text.substringFromIndex(range.startIndex.advancedBy(1))
                        if lastNum.containsString(".") {
                            if lastNum.rangeOfString(".")?.startIndex != lastNum.endIndex.advancedBy(-2) {
                                text += "0"
                            }
                        }else{
                            if text != "0" && text.characters.count <= 7 {
                                text += "0"
                            }
                        }
                    }else{
                        if text.containsString(".") {
                            if text.rangeOfString(".")?.startIndex != text.endIndex.advancedBy(-2) {
                                text += "0"
                            }
                        }else{
                            if text != "0" && text.characters.count <= 7 {
                                text += "0"
                            }
                        }
                        
                    }
                }
            case 14:
                if cachedResult.characters.count > 0 {
                    text = cachedResult + "+"
                    cachedResult = ""
                }else{
                    if text.containsString("+") {
                        if text.hasSuffix("+") {
                            
                        }else{
                            if let range = text.rangeOfString("+", options: .BackwardsSearch, range: text.startIndex..<text.endIndex, locale: nil){
                                let lastNum = text.substringFromIndex(range.startIndex.advancedBy(1))
                                if lastNum == "0" {
                                    text += "+"
                                }else if lastNum.hasSuffix(".") {
                                    text = text.substringToIndex(text.endIndex.advancedBy(-1))
                                    text += "+"
                                }else{
                                    text += "+"
                                }
                            }
                        }
                    }else{
                        if text == "0" {
                            text += "+"
                        }else if text.hasSuffix(".") {
                            text = text.substringToIndex(text.endIndex.advancedBy(-1))
                            text += "+"
                        }else{
                            text += "+"
                        }
                    }
                }
                
            default:
                print(indexPath.row)
            }
            if text.containsString("+") {
                lblCashIn.text = "="
            }else {
                lblCashIn.text = "收钱"
            }
            
            let size = (text as NSString).boundingRectWithSize(CGSizeMake(SCREENWIDTH - 10, 10000), options: [.UsesFontLeading , .UsesLineFragmentOrigin], attributes: [NSFontAttributeName : UIFont.systemFontOfSize(52)], context: nil).size
            let svHeight = SCREENHEIGHT - 64 - SCREENWIDTH * 1500 / 1242
            if size.height + 5 > svHeight {
                tConstraint.constant = 0
                svResult.contentOffset = CGPointMake(0, size.height - svHeight + 5)
            }else{
                tConstraint.constant = svHeight - size.height - 5
                svResult.contentOffset = CGPointZero
            }
            
            lblResult.text = text
            
        }else{
            let payWay = cdPayWay.payWayWithRow(indexPath.row)

            if payWay.pmt_tag == "Cash" {
                PayManager.doPay("Cash", ord_name: "现金收银", original_amount: 100, discount_amount: 0, ignore_amount: 0, trade_amount: 100, auth_code: nil, callback: {[weak self] (easValue , message) in
                    if message.characters.count > 0 {
                        self?.view.makeToast(message)
                    }
                    })
            }else if payWay.pmt_tag == "Chinaums" {
                //刷卡支付
            }else if payWay.pmt_tag == "Alipay" {
                pmt_tag = "Alipay"
                pmt_type = payWay.pmt_type ?? ""
                self.performSegueWithIdentifier("toQRCodeOrScan", sender: self)
            }else if payWay.pmt_tag == "Weixin" {
                pmt_tag = "Weixin"
                pmt_type = payWay.pmt_type ?? ""
                self.performSegueWithIdentifier("toQRCodeOrScan", sender: self)
            }else if payWay.pmt_tag == "Baifubao" {
                pmt_tag = "Baifubao"
                pmt_type = payWay.pmt_type ?? ""
                self.performSegueWithIdentifier("toQRCodeOrScan", sender: self)
            }
            
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == cvCalculater {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalculaterCell
            cell.ivBG.image = UIImage.imageWithColor(UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1))
        }else{
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.contentView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == cvCalculater {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalculaterCell
            if indexPath.row == 3 || indexPath.row == 7 {
                cell.ivBG.image = UIImage.imageWithColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1))
            }else{
                cell.ivBG.image = UIImage.imageWithColors([UIColor.whiteColor() , UIColor(red:230/255.0 , green:230/255.0 , blue : 230/255.0 , alpha : 1 )], size: CGSizeMake((SCREENWIDTH - 3) / 4, (SCREENWIDTH * 1500 / 1242 - 3)/4))
            }
        }else{
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == cvCalculater {
            return CGSizeMake((SCREENWIDTH - 3) / 4, (SCREENWIDTH * 1500 / 1242 - 3)/4)
        }else{
            return CGSizeMake((SCREENWIDTH - 1) / 2, (SCREENWIDTH - 1) / 2 * 590 / 620)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 0, 1, 0)
    }

}
