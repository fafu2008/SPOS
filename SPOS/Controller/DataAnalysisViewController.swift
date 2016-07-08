//
//  DataAnalysisViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/7/6.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit



class DataAnalysisViewController: UIViewController ,ZCharsManagerDelegate,ZCharsDataSource{
    
    
    let dataArray = [
        [
            "data":[120, 132, 101, 134, 90, 230, 210],
            "unit": "°C",
            "xAxis": ["周一","周二","周三","周四","周五","周六","周日"]
        ]]
    /*
    ,
    [
    "data":[-1, 182, 191, 234, 290, 330, 310],
    "unit": "°C",
    "xAxis": ["周一","周二","周三","周四","周五","周六","周日"]
    ]
    */
    lazy var segmentLine:UIView = UIView()
    
    lazy var titleSegment:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["交易","退款"])
        segment.tintColor = UIColor.whiteColor()
        segment.backgroundColor = UIColor.clearColor()
        segment.frame = CGRect(x: (SCREENWIDTH - 150) / 2, y: 25, width: 150, height: 30)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var tradeSegment:UISegmentedControl = {
        let seg = UISegmentedControl(items: ["交易金额","交易笔数","客单价"])
        seg.frame = CGRect(x: 0, y: 69, width: SCREENWIDTH, height: 30)

        seg.selectedSegmentIndex = 0
        return seg
    }()
    lazy var refundSegment:UISegmentedControl = {
        let seg = UISegmentedControl(items: ["退款金额","退款笔数"])
        seg.frame = CGRect(x: 0, y: 69, width: SCREENWIDTH, height: 30)
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stupNavigationBarView()
        stupSegment()
        stupChart1()
    }
    
    func stupNavigationBarView(){
        
        self.navigationController?.navigationBar.hidden = true
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 64))
        view.addSubview(titleView)
        titleView.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 30, width: 40, height: 20))
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(DataAnalysisViewController.backButtonClicked), forControlEvents: .TouchUpInside)
        titleView.addSubview(backButton)
        
        titleSegment.addTarget(self, action: #selector(DataAnalysisViewController.titileSegmentClicked(_:)), forControlEvents:UIControlEvents.ValueChanged)
        titleView.addSubview(titleSegment)
        
        
        let selectButton = UIButton(frame: CGRect(x: SCREENWIDTH - 35 - 20, y: 30, width: 40, height: 20))
        selectButton.setImage(UIImage(named: "日历"), forState: .Normal)
        selectButton.addTarget(self, action: #selector(DataAnalysisViewController.selectButtonClicked), forControlEvents: .TouchUpInside)
        titleView.addSubview(selectButton)

    }
    
    func stupSegment(){
        self.view.addSubview(tradeSegment)
        self.view.addSubview(refundSegment)
        tradeSegment.hidden = false
        refundSegment.hidden = true
        let image = createImageWithColor(UIColor.whiteColor())
        tradeSegment.setBackgroundImage(image, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        tradeSegment.setBackgroundImage(image,forState: UIControlState.Selected,barMetrics: .Default)
        tradeSegment.setBackgroundImage(image,forState: UIControlState.Highlighted,barMetrics: .Default)
        
        tradeSegment.setDividerImage(image, forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: .Default)
        
        tradeSegment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkTextColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)], forState: UIControlState.Normal)
        tradeSegment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0),NSFontAttributeName:UIFont.systemFontOfSize(15)], forState: UIControlState.Selected)
        tradeSegment.addTarget(self, action: #selector(DataAnalysisViewController.tradeSegmentValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        refundSegment.setBackgroundImage(image, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        refundSegment.setBackgroundImage(image,forState: UIControlState.Selected,barMetrics: .Default)
        refundSegment.setBackgroundImage(image,forState: UIControlState.Highlighted,barMetrics: .Default)
        
        refundSegment.setDividerImage(image, forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: .Default)
        
        refundSegment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkTextColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)], forState: UIControlState.Normal)
        refundSegment.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0),NSFontAttributeName:UIFont.systemFontOfSize(15)], forState: UIControlState.Selected)
        refundSegment.addTarget(self, action: #selector(DataAnalysisViewController.refundSegmentValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        segmentLine.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        segmentLine.frame = CGRect(x: 0,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 3,height: 1)
        self.view.addSubview(segmentLine)
        
    }
    
   
    func tradeSegmentValueChange(sender:UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){
            segmentLine.frame = CGRect(x: 0,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 3,height: 1)
        }else if(sender.selectedSegmentIndex == 1){
            segmentLine.frame = CGRect(x: SCREENWIDTH / 3,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 3,height: 1)
        }else{
            segmentLine.frame = CGRect(x: (SCREENWIDTH / 3) * 2,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 3,height: 1)
        }
    }
    
    func refundSegmentValueChange(sender:UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){
            segmentLine.frame = CGRect(x: 0,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 2,height: 1)
        }else{
            segmentLine.frame = CGRect(x: SCREENWIDTH / 2,y: tradeSegment.frame.maxY,width: SCREENWIDTH / 2,height: 1)
        }
    }

    func backButtonClicked(){
        if (self.presentingViewController != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func selectButtonClicked(){

    }
    
    func titileSegmentClicked(sender:UISegmentedControl){
        
        if(sender.selectedSegmentIndex == 0){
            tradeSegment.hidden = false
            refundSegment.hidden = true
            segmentLine.frame = CGRect(x: (SCREENWIDTH / 3) * CGFloat(tradeSegment.selectedSegmentIndex),y: tradeSegment.frame.maxY,width: SCREENWIDTH / 3,height: 1)

        }else{
            tradeSegment.hidden = true
            refundSegment.hidden = false
            segmentLine.frame = CGRect(x: (SCREENWIDTH / 2) * CGFloat(refundSegment.selectedSegmentIndex),y: tradeSegment.frame.maxY,width: SCREENWIDTH / 2,height: 1)

        }
    }

    func stupChart1(){
        let chart11 = ZCharsManager(frame: CGRect(x: 0, y: segmentLine.frame.maxY + 1, width: SCREENWIDTH, height: 250))
        chart11.delegate = self
        chart11.dataSource = self
        chart11.zcharsType = ZCharsType.Line
        self.view.addSubview(chart11)
        
        // 设置左侧刻度样式
        chart11.leftView.backgroundColor = UIColor.whiteColor()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Right
        
        let fontDict = [NSFontAttributeName:UIFont.systemFontOfSize(10),NSForegroundColorAttributeName:UIColor.darkTextColor(),NSParagraphStyleAttributeName:paragraph]
        
        chart11.leftView.fontDict = fontDict;
        //    zcharsManager.leftView.width = 35;
        
        chart11.backgroundColor = UIColor(patternImage: UIImage(named: "ZCharsBg")!)
        //    zcharsManager.leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ZCharsBg"]];
        
        let paragraph2 = NSMutableParagraphStyle()
        paragraph2.alignment = NSTextAlignment.Left
        
        let fontDict2 = [NSFontAttributeName:UIFont.systemFontOfSize(10),NSForegroundColorAttributeName:UIColor.darkTextColor(),NSParagraphStyleAttributeName:paragraph2]
        
        chart11.rightView.XAxisFont = fontDict2
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
         //       chart11.reloadData()
        })

        
        
        
    }
    
    
    func createImageWithColor(color: UIColor) -> UIImage
    {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
}

extension DataAnalysisViewController{
    
    func didScrollViewDidScroll(indexPath:NSIndexPath, paopaoView:UIImageView){
        
    }
    
    /**
     *  行数
     *
     *  @param zcharsManager
     *  @param rowCount
     *
     *  @return
     */
    func rowContInZCharsManager(zcharsManager:ZCharsManager) ->Int{
        return 5
    }
    
    /**
     *  每列宽度
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func columnWidthInZCharsManager(zcharsManager:ZCharsManager) ->CGFloat{
        return (SCREENWIDTH - 100) / 7
    }
    
    
    /**
     *  刻度区间, 最大值,最小值, 不设置则自动计算
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func valueSectionInZCharsManager(zcharsManager:ZCharsManager)->ZChasValue{
        return ZChasValueMake(0, 400)
    }
    
    
    /**
     *  间距
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func rightInsetsInZCharsManager(zcharsManager:ZCharsManager) ->UIEdgeInsets{
        return UIEdgeInsetsMake(0, 70, 45, 45)
    }
    
    /**
     *  滑块 view
     *  只可改变 paopaoview 的width 和 Y. 属性
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func paopaoViewInZCharsManager(zcharsManager:ZCharsManager)->UIImageView{
        //return UIImageView(image: UIImage(named: "ZcharsPaopao"))
        let imageView = UIImageView()
        imageView.hidden = true
        return imageView
    }
    
    /**
     *  collectionView header
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func headerViewInZCharsManager(zcharsManager:ZCharsManager)->String{
        return "ZCharsHeaderView"
    }

    
    //*********** lineDelegate ***************
    
    /**
     *  每个 cell 绘制几条线
     *
     *  @param zcharsManager
     *
     *  @return
     */
    func lineNumberOfInZCharsManager(zcharsManager:ZCharsManager)->Int{
        return dataArray.count
    }
    
    /**
     *  数据条数
     *
     *  @param collectionView
     *  @param section
     *
     *  @return
     */
    func collectionView(collectionView:UICollectionView , numberOfItemsInSection section:NSInteger) ->Int{
        return dataArray[section]["data"]!.count
    }
    
    
    /**
     *  曲线图代理方法
     *
     *  @param cell
     *  @param lineNumber
     *
     *  @return
     */
    func dataOflineNumberZCharsManager(indexPath:NSIndexPath, lineNumber:NSInteger) ->CGFloat{
       // return dataArray[lineNumber]["data"]![indexPath.row]
        let dic:NSDictionary = dataArray[lineNumber] 
        let array:NSArray = dic["data"] as! NSArray
        let f:CGFloat = array[indexPath.row] as! CGFloat
        return f
    }
    
    /**
     *  线条颜色
     *
     *  @param lineNumber
     *
     *  @return
     */
    func lineColorOflineNumber(lineNumber:NSInteger) ->UIColor{
        if (lineNumber == 0) {
            return UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        } else {
            return UIColor.redColor()
        }
    }
    
    /**
     *  X轴绘制文字
     *
     *  @param cell
     *  @param lineNumber
     *
     *  @return
     */
    func xAxisOflineNumberZCharsManager(cell:ZCharsLineViewCell,lineNumber:Int) ->String{
        let dic:NSDictionary = dataArray[lineNumber]
        let array:NSArray = dic["xAxis"] as! NSArray
        let str:String = array[cell.indexPath.row] as! String
        return str
    }
    
   
}


class ChartCollectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "新鲜热卖"
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.frame = CGRectMake(0, 0, 50, 20)
        titleLabel.textColor = UIColor.darkTextColor()
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







