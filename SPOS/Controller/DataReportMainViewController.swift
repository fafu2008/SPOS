//
//  DataReportMainViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/7/6.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class DataReportMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true

        self.view.backgroundColor = UIColor.whiteColor()
        let vc1 = DataAnalysisViewController()
        let vcna1 = UINavigationController(rootViewController: vc1)
        vc1.view.backgroundColor = UIColor.redColor()
        //vc1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "首页_4"), selectedImage: UIImage(named: "首页"))
        //vc1.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()],forState:UIControlState.Normal)
        vcna1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "首页_4"), selectedImage: UIImage(named: "首页"))
        
        let vc2 = DataAnalysisViewController()
        let vcna2 = UINavigationController(rootViewController: vc2)
        vc2.view.backgroundColor = UIColor.greenColor()
        vcna2.tabBarItem = UITabBarItem(title: "汇总", image: UIImage(named: "汇总_3"), selectedImage: UIImage(named: "汇总"))
        
        let vc3 = DataAnalysisViewController()
        let vcna3 = UINavigationController(rootViewController: vc3)
        vc3.view.backgroundColor = UIColor.yellowColor()
        vcna3.tabBarItem = UITabBarItem(title: "记录", image: UIImage(named: "记录_2"), selectedImage: UIImage(named: "记录"))
        //vcna3.tabBarItem.badgeValue = "123"
        
        let vc4 = DataAnalysisViewController()
        let vcna4 = UINavigationController(rootViewController: vc4)
        //vc4.view.backgroundColor = UIColor.orangeColor()
        vcna4.tabBarItem = UITabBarItem(title: "分析", image: UIImage(named: "分析_1"), selectedImage: UIImage(named: "分析"))
        
        self.viewControllers = [vcna1,vcna2,vcna3,vcna4]
        //self.tabBar.tintColor = UIColor.purpleColor()
        self.selectedIndex = 3
        
    }
    
    
   }
