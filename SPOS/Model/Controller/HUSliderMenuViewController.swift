//
//  ViewController.swift
//  HUSliderMenu
//
//  Created by jewelz on 15/7/13.
//  Copyright (c) 2015年 yangtzeu. All rights reserved.
//

import UIKit

class HUSliderMenuViewController: UIViewController, HULeftMenuDelegate, HULeftMenuDataSource, UIGestureRecognizerDelegate {
    
    ///是否允许缩放效果
    var allowTransformWithScale = true
    ///是否允许弹簧效果
    var allowSpringAnimation = true
    
    var panGestureRecognizer : UIPanGestureRecognizer?
    //设置菜单按钮标题
    var leftMenuBarItemTitle: String = "Menu"
    //设置菜单按钮图标
    var leftMenuBarItemImage: String = "menu"
    
    var menuView: HULeftMenu!
   
    var currentViewController: UIViewController!
    private var menuWidth: CGFloat = 0.0
    private let scale: CGFloat = 0.78
    private let animationDuration: NSTimeInterval = 0.5
    private let springDamping: CGFloat = 0.9
    private let springVelocity: CGFloat = 20
    private let maskTag = 100000
    private var canMoveLeft = false
    
   
   // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = SCREENWIDTH * scale
        let height = SCREENHEIGHT
       
        let leftMenu = HULeftMenu(frame: CGRect(x: 0, y: 0, width: width, height: height))
        leftMenu.delegate = self
        leftMenu.dataSoruce = self
        self.view.addSubview(leftMenu)
        
        self.menuWidth = width
        self.menuView = leftMenu
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HUSliderMenuViewController.panGestureHandle(_:)))
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func addPanGestureRecognizer() {
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func removePanGestureRecognizer() {
        self.view.removeGestureRecognizer(panGestureRecognizer!)
    }
    
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func leftMenu(menu: HULeftMenu, menuItemAtIndex index: Int) -> AnyObject {
        let item = menu.menuItemAtIndex(index) as! HUMenuItenCell
        return item
    }
    
    func leftMenu(menu: HULeftMenu, didSelectedItemAtIndex index: Int, toNewItem newIndex: Int) {
        
        let count = self.childViewControllers.count
       
        if index >= count {
            return
        }
        
        if newIndex >= count {
            return
        }
        
        let oldVc = self.childViewControllers[index] as! UINavigationController
        let newVc = self.childViewControllers[newIndex] as! UINavigationController
        
        
        self.view.addSubview(newVc.view)
        newVc.view.transform = oldVc.view.transform
        oldVc.view.removeFromSuperview()
        self.currentViewController = newVc
        
        self.viewAnimationWithSpring(allowSpringAnimation, animation: { () -> () in
            newVc.view.transform = CGAffineTransformIdentity
        })
        
        //移除遮盖
        self.currentViewController.view.viewWithTag(maskTag)?.removeFromSuperview()
        
        canMoveLeft = true
    }
    
    
     func sliderLeft() {
 
        self.viewAnimationWithSpring(allowSpringAnimation, animation: { () -> () in
           
            let mask = UIButton(type: .Custom)
            mask.tag = self.maskTag
            mask.frame = self.currentViewController.view.frame
            mask.addTarget(self, action: #selector(HUSliderMenuViewController.hideLeftMenu(_:)), forControlEvents: .TouchUpInside)
            self.currentViewController.view.addSubview(mask)
            
            let leftPadding = SCREENWIDTH * (1-self.scale) * 0.5
            let tX = self.menuWidth - leftPadding
            
            if CGAffineTransformIsIdentity(self.currentViewController.view.transform) {
                
                self.canMoveLeft = true
                
                var trans = CGAffineTransformMakeTranslation(SCREENWIDTH*self.scale, 0)
                
                if self.allowTransformWithScale {
                    let scaleform = CGAffineTransformMakeScale(self.scale, self.scale)
                    trans = CGAffineTransformTranslate(scaleform, tX/self.scale, 0);
                    
                }
                
                self.currentViewController.view.transform = trans
                
                
            } else {
                self.canMoveLeft = false
                self.currentViewController.view.transform = CGAffineTransformIdentity
                
            }
            
        })
        
    }
    
    //MARK: - maskButton clicked hidden the menu
    func hideLeftMenu(sender: UIButton) {   //点击右侧关闭
        
        self.hiddenLeftMenu()
        sender.removeFromSuperview()
        
    }
    
    func panGestureHandle(recognizer: UIPanGestureRecognizer) {
        
        let offsetX = recognizer.translationInView(view).x
        
        if recognizer.state == .Began {
            
            //print(offsetX)
            
        }else if recognizer.state == .Changed {
            
            
            if offsetX < 0 { //左滑
                if canMoveLeft {
                    self.transformTranslate(true, withOffset: offsetX)
                    
                    if currentViewController.view.frame.origin.x < 0 {
                        self.hiddenLeftMenu()
                    }
                }
            }

            if offsetX > 0 { //右滑
                if currentViewController.view.frame.origin.x >= SCREENWIDTH*scale {
                    return
                }
                self.transformTranslate(false, withOffset: offsetX)
            }
            return
        }else if recognizer.state == .Ended {

            if abs(offsetX) > SCREENWIDTH * 0.5 {
                
                self.transformTranslate(false, withOffset: SCREENWIDTH*scale)
                
            } else {
                self.hiddenLeftMenu()
            }
        }
     }


    //MARK: - 通过滑动位置处理菜单位置 translate为true向左划，false右划
    private func transformTranslate(translae: Bool, withOffset offset: CGFloat) {

        var trans: CGAffineTransform?
        self.viewAnimationWithSpring(allowSpringAnimation, animation: { () -> () in
            if translae {
                trans = CGAffineTransformTranslate(self.currentViewController.view.transform, offset, 0)
            } else {
                self.canMoveLeft = true
                trans = CGAffineTransformMakeTranslation(offset, 0)
            }
            self.currentViewController.view.transform = trans!
        })
        
        
    }
    
    
    private func hiddenLeftMenu() {
        
        self.viewAnimationWithSpring(allowSpringAnimation, animation: { () -> () in
            self.currentViewController.view.transform = CGAffineTransformIdentity
        })
        
        canMoveLeft = false
    }
    
    
    //MARK - gestureRecognizer delegate
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let nav: UINavigationController = self.currentViewController as? UINavigationController {
            if nav.viewControllers.count == 1 {
                return true
            }
        }
        
        return false
    }
    
    private func viewAnimationWithSpring(spring: Bool, animation:() -> ()) {
        
        if spring {
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .CurveLinear, animations: { () -> Void in
                
                animation()
                
                }, completion: { (finished) -> Void in
                    
            })
            
        } else {
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                
                animation()
            })
        }
    }
    
   internal func leftMenuBarItem() -> UIButton {
        let leftBtn = UIButton(type: .Custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
    
    
        if let image =  UIImage(named: leftMenuBarItemImage) {
            leftBtn.setImage(image, forState:.Normal)
            leftBtn.contentHorizontalAlignment = .Left
        } else {
            leftBtn.setTitle(self.leftMenuBarItemTitle, forState: .Normal)
            leftBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    
    
        leftBtn.addTarget(self, action: #selector(HUSliderMenuViewController.sliderLeft), forControlEvents: .TouchUpInside)
    
        return leftBtn
    }
    
  

}

