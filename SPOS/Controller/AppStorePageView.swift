//
//  AppStorePageView.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/18.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class AppStorePageView: UIView {
    
    var currentPage:Int = 1
    var totalPage:Int = 1
    
    lazy var left:UIButton = UIButton()
    lazy var right:UIButton = UIButton()
    
    lazy var bt1:UIButton = UIButton()
    lazy var bt2:UIButton = UIButton()
    lazy var bt3:UIButton = UIButton()
    lazy var bt4:UIButton = UIButton()
    lazy var bt5:UIButton = UIButton()
    
    init(frame: CGRect, currentPage:Int, totalPage:Int) {
        super.init(frame: frame)
        
        self.currentPage = currentPage
        self.totalPage = totalPage
        
        //增加上一页
        left = UIButton()
        left.setBackgroundImage(UIImage(named:"0057") , forState: UIControlState.Normal)
        left.setBackgroundImage(UIImage(named:"0056") , forState: UIControlState.Selected)
        left.contentMode = UIViewContentMode.ScaleToFill
        if(currentPage == 1){
            left.enabled = false
        }else{
            left.enabled = true
        }
        self.addSubview(left)
        
        //增加下一页
        right = UIButton()
        right.setBackgroundImage(UIImage(named:"0055") , forState: UIControlState.Normal)
        right.setBackgroundImage(UIImage(named:"0054") , forState: UIControlState.Selected)
        right.contentMode = UIViewContentMode.ScaleToFill
        if(currentPage < totalPage){
            right.enabled = true
        }else{
            right.enabled = false
        }
        self.addSubview(right)
        
        //增加当前页
        bt3.setBackgroundImage(UIImage(named: "0053"), forState: UIControlState.Normal)
        bt3.contentMode = UIViewContentMode.Center
        bt3.enabled = false
        bt3.setTitle(String(currentPage), forState: UIControlState.Normal)
        self.addSubview(bt3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = super.frame.width
        let h = super.frame.height
        
        left.frame = CGRectMake(2, 2, h - 4, h - 4)
        right.frame = CGRectMake(w - h - 4 - 2, 2, h - 4, h - 4)
        
        bt3.frame = CGRectMake((w - h - 4)/2, 2, h-4, h-4)
        
        
    }
    
    
    
}