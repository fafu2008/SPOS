//
//  MenuViewController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class MenuViewController: HUSliderMenuViewController {

    var menuItems : [[String : String]] {
        
        return [["title" : "首页" , "image" : "left1"] ,["title" : "收银台" , "image" : "left2"] ,["title" : "应用市场" , "image" : "left3"] ,["title" : "我的应用" , "image" : "left4"] ,["title" : "T账户" , "image" : "left5"] ,["title" : "系统管理" , "image" : "left6"] ,]
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mController = self.storyboard!.instantiateViewControllerWithIdentifier("mainNav") as! UINavigationController
        
        self.addChildViewController(mController)
        mController.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        self.view.addSubview(mController.view)
        self.currentViewController = mController
        
        let sytController = self.storyboard!.instantiateViewControllerWithIdentifier("SYTNav") as! UINavigationController
        self.addChildViewController(sytController)
        sytController.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        
        //xjq add start
        let appStorestoryboard = UIStoryboard(name: "ShopAppStore", bundle: nil)
        let appStoreViewContronll = appStorestoryboard.instantiateViewControllerWithIdentifier("ShopAppStoreMain") as! UINavigationController
        self.addChildViewController(appStoreViewContronll)
        //var temp = appStoreViewContronll.topViewController
        appStoreViewContronll.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        
        let myAppsstoryboard = UIStoryboard(name: "MyApps", bundle: nil)
        let myAppsViewContronll = myAppsstoryboard.instantiateViewControllerWithIdentifier("MyAppsMain") as! UINavigationController
        self.addChildViewController(myAppsViewContronll)
        myAppsViewContronll.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        //xjq add end
        
        //add by 虞邵鹏 for T账户
        let storyboard = UIStoryboard(name: "Tcount", bundle: nil)
        let tCountController = storyboard.instantiateViewControllerWithIdentifier("TcountNavs") as! UINavigationController
        self.addChildViewController(tCountController)
        tCountController.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        
        //xjq add start
        let systemManagestoryboard = UIStoryboard(name: "SystemManage", bundle: nil)
        let systemManageViewContronll = systemManagestoryboard.instantiateViewControllerWithIdentifier("systemManageNavigation") as! UINavigationController
        self.addChildViewController(systemManageViewContronll)
        systemManageViewContronll.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftMenuBarItem())
        
        UserBasicInfoViewController.getShopInfo()
        
        //xjq add end
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
    }
 
    
    override func numberOfItems() -> Int {
        return menuItems.count
    }
    
    override func leftMenu(menu: HULeftMenu, menuItemAtIndex index: Int) -> AnyObject {
        let item = menu.menuItemAtIndex(index) as! HUMenuItenCell
        item.selectedBackground = BASE_UICOLOR
        item.titleLabText = menuItems[index]["title"]
        item.image = UIImage(named: menuItems[index]["image"]!)
        item.titleLabel?.font = UIFont.systemFontOfSize(14)
        item.titleLabColor = UIColor.whiteColor()
        
        return item
    }
    
    func headerViewForLeftMenu(menu: HULeftMenu) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        let lblContent = UILabel()
        lblContent.backgroundColor = UIColor.clearColor()
        lblContent.font = UIFont.systemFontOfSize(18)
        lblContent.textColor = UIColor.whiteColor()
        lblContent.text = "海港餐饮管理集团"
        lblContent.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblContent)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[lblContent]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["lblContent" : lblContent]))
        view.addConstraint(NSLayoutConstraint(item: lblContent, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        return view
    }

}
