//
//  LauncherView.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/24.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

protocol LauncherViewDelegate {
    func launcherViewItemSelected(item : LauncherItem)
    func launcherViewDidBeginEditing(sender : AnyObject)
    func launcherViewDidEndEditing(sender : AnyObject)
}

class LauncherView: UIView , UIScrollViewDelegate , LaucherItemDelegate{

    
    struct ItemLocation {
        let page : Int
        let index : Int
    }
    
    var delegate : LauncherViewDelegate?
    
    var draggingItem : LauncherItem?
    var addItem : LauncherItem?
    
    var itemsAdded : Bool = false
    var editing : Bool = false
    var dragging : Bool = false
    var editingAllowed : Bool = false
    
    var minX : CGFloat = 0
    var minY : CGFloat = 0
    var paddingX : CGFloat = 0
    var paddingY : CGFloat = 0
    var columnCount : Int = 0
    var rowCount : Int = 0
    var itemWidth : CGFloat = 0
    var itemHeight : CGFloat = 0
    var iFlag = 0
    
    var animationLeft = false
    
    var itemHoldTimer : NSTimer?
    var movePagesTimer : NSTimer?
    
    @IBOutlet weak var pageScrollView : LauncherScrollView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var wConstraint : NSLayoutConstraint!
    
    
    var pages = [LauncherItem]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dragging = false
        editing = false
        itemsAdded = false
        editingAllowed = true
    }
    
    func setPages(pages : [LauncherItem] , animated : Bool) {
        
        if pages != self.pages {
            if self.pages.count > 0 {
                for page in pages {
                        page.removeFromSuperview()
                }
            }
            self.pages = pages
            itemsAdded = false
            layoutLauncherAnimated(animated)
        }
        
        
    }
    
    
    func updateFrames() {
        pageControl.setNeedsDisplay()
    }
    
    func maxItemsPerPge() -> Int {
        
        return 8
        
    }
    
    func setupCurrentViewLayoutSettings() {
        
        minX = 0
        minY = 0
        paddingX = 0
        paddingY = 0
        columnCount = 2
        rowCount = 4
        itemWidth = SCREENWIDTH / 4
        itemHeight = (SCREENHEIGHT * (2208 - 1445) / 2208 - 37) / 2
        
        
    }
    
    //布局
    func layoutLauncher() {
        layoutLauncherAnimated(false)
    }
    
    //布局动画
    func layoutLauncherAnimated(animated : Bool) {
        updateFrames()
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            [unowned self] in
            self.layoutItems()
        }
        pageChanged()
    }
    
    //布局launcherItem 
    func layoutItems() {
        
        setupCurrentViewLayoutSettings()
        var x = minX
        var y = minY
        for i in 0..<pages.count {
            let k = (i % (rowCount + columnCount)) / 4
            let m = i % 4
            let n = i / (rowCount * columnCount)
            
            x = CGFloat(m) * itemWidth + CGFloat(n) * SCREENWIDTH
            y = CGFloat(k) * itemHeight
            
            let item = pages[i]
            if itemsAdded {
                let prevFrame = CGRectMake(x, y, itemWidth, itemHeight)
                if !item.dragging {
                    item.transform = CGAffineTransformIdentity
                    if item.frame.origin.x != x || item.frame.origin.y != y {
                        item.frame = prevFrame
                    }
                }
                if item.superview == nil {
                    item.delegate = self
                    item.layoutItem()
                    item.addTarget(self, action: #selector(LauncherView.itemTouchedUpInside(_:)), forControlEvents: .TouchUpInside)
                    item.addTarget(self, action: #selector(LauncherView.itemTouchedUpOutside(_:)), forControlEvents: .TouchUpOutside)
                    item.addTarget(self, action: #selector(LauncherView.itemTouchedDown(_:)), forControlEvents: .TouchDown)
                    item.addTarget(self, action: #selector(LauncherView.itemTouchedCancelled(_:)), forControlEvents: .TouchCancel)
                    contentView.addSubview(item)
                }
            }else{
                item.frame = CGRectMake(x, y, itemWidth, itemHeight)
                item.delegate = self
                item.layoutItem()
                item.addTarget(self, action: #selector(LauncherView.itemTouchedUpInside(_:)), forControlEvents: .TouchUpInside)
                item.addTarget(self, action: #selector(LauncherView.itemTouchedUpOutside(_:)), forControlEvents: .TouchUpOutside)
                item.addTarget(self, action: #selector(LauncherView.itemTouchedDown(_:)), forControlEvents: .TouchDown)
                item.addTarget(self, action: #selector(LauncherView.itemTouchedCancelled(_:)), forControlEvents: .TouchCancel)
                contentView.addSubview(item)
            }
            item.closeButton.hidden = editing ? false : true
        }
        pageControl.numberOfPages = pages.count % (columnCount + rowCount) > 0 ? pages.count / (columnCount + rowCount) + 1 : pages.count / (columnCount + rowCount)
        wConstraint.constant = CGFloat(pageControl.numberOfPages) * SCREENWIDTH
        
    }
    
    
    
    
    //页面发生变动
    func pageChanged() {
        pageScrollView.contentOffset = CGPointMake(CGFloat(pageControl.currentPage) * SCREENWIDTH, 0)
    }
    
    //删除Item
    func didDeleteItem(item : LauncherItem) {
        
        if let index = pages.indexOf(item) {
            pages.removeAtIndex(index)
            UIView.animateWithDuration(0.3, animations:  {
                [unowned self] in self.layoutItems()
            })
        }
        
        
    }
    
    //新增Item
    func doAddItems(items : [LauncherItem]) {
        
    }
    
    //item动画
    func animateItems() {
        
        if editing {
            let animationUp = CGAffineTransformMakeScale(1.0, 1.0)
            let animationDown = CGAffineTransformMakeScale(0.9, 0.9)
            UIView.beginAnimations(nil, context: nil)
            var animatingItem = 0
            for i in 0..<pages.count {
                let item = pages[i]
                item.closeButton.hidden = !editing
                if item != draggingItem {
                    animatingItem += 1
                    if i % 2 > 0 {
                        item.transform = animationLeft ? animationDown : animationUp
                    }else{
                        item.transform = animationLeft ? animationUp : animationDown
                    }
                }
            }
            if animatingItem >= 1 {
                UIView.setAnimationDuration(0.05)
                UIView.setAnimationDelegate(self)
                UIView.setAnimationDidStopSelector(#selector(LauncherView.animateItems))
                animationLeft = !animationLeft
            }else {
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
                self.performSelector(#selector(LauncherView.animateItems), withObject: nil, afterDelay: 0.05)
            }
            UIView.commitAnimations()
        }
        
        
    }
    
    //itemLocation
    func itemLocation() -> ItemLocation {
        var i = 0
        for item in pages {
            if item == draggingItem {
                return ItemLocation(page: i / (rowCount + columnCount), index: i % (rowCount + columnCount))
            }
            i += 1
        }
        return ItemLocation(page: 0, index: 0)
    }
    
    //开始编辑
    func beginEditing() {
        if editing {
            return
        }
        editing = true
        addItem = pages.last!
        pages.removeLast()
        addItem!.removeFromSuperview()
        animateItems()
        self.delegate?.launcherViewDidBeginEditing(self)
    }
    
    //结束编辑
    func endEditing() {
        editing = false
        pageScrollView.scrollEnabled = true
        for item in pages {
            item.transform = CGAffineTransformIdentity
        }
        pageControl.numberOfPages = pages.count % (columnCount * rowCount) > 0 ? pages.count / (columnCount * rowCount + 1) : pages.count / (columnCount + rowCount)
        
        wConstraint.constant = CGFloat(pageControl.numberOfPages) * SCREENWIDTH
        layoutItems()
        //差
        self.delegate?.launcherViewDidEndEditing(self)
        
    }
    
    
    //MARK: -UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor((pageScrollView.contentOffset.x - pageScrollView.frame.size.width/2) / pageScrollView.frame.size.width) + 1)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - width / 2) / width) + 1
        pageControl.currentPage = Int(page)
    }
    
    //MARK: -Touch Management
    func itemTouchedUpInside(item : LauncherItem) {
        if editing {
            dragging = false
            draggingItem?.dragging = false
            draggingItem = nil
            pageScrollView.scrollEnabled = true
            UIView.animateWithDuration(0.3, animations: { 
                [unowned self] in self.layoutItems()
            })
            if iFlag == 1 {
                endEditing()
            }
            iFlag = 0
        }else{
            movePagesTimer?.invalidate()
            movePagesTimer = nil
            itemHoldTimer?.invalidate()
            itemHoldTimer = nil
            self.delegate?.launcherViewItemSelected(item)
            pageScrollView.scrollEnabled = true
        }
        
        
    }
    
    func itemTouchedUpOutside(item : LauncherItem) {
        
        movePagesTimer?.invalidate()
        movePagesTimer = nil
        itemHoldTimer?.invalidate()
        itemHoldTimer = nil

        dragging = false
        draggingItem?.dragging = false
        draggingItem = nil
        pageScrollView.scrollEnabled = true
        UIView.animateWithDuration(0.3) { 
            [unowned self] in self.layoutItems()
        }
        
    }
    
    func itemTouchedDown(item : LauncherItem) {
        if editing {
            if draggingItem == nil {
                draggingItem = item
                draggingItem?.dragging = true
                pageScrollView.addSubview(draggingItem!)
                dragging = true
                if iFlag == 0 {
                    iFlag = 1
                }
            }
        }else if editingAllowed {
            if item.title == "" {
                return
            }
            if itemHoldTimer != nil {
                itemHoldTimer?.invalidate()
                itemHoldTimer = nil
            }
            itemHoldTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LauncherView.itemHoldTimer(_:)), userInfo: item, repeats: false)
        }
    }
    
    func itemTouchedCancelled(item : LauncherItem) {
        if editing {
            itemTouchedUpInside(item)
        }else{
            itemTouchedUpOutside(item)
        }
    }
    
    //定时器
    func itemHoldTimer(timer : NSTimer) {
        itemHoldTimer = nil
        beginEditing()
        if let holdItem = timer.userInfo as? LauncherItem {
            draggingItem = holdItem
            draggingItem?.selected = false
            draggingItem?.highlighted = false
            draggingItem?.dragging = true
            pageScrollView.addSubview(draggingItem!)
            dragging = true
            pageScrollView.scrollEnabled = false
        }
    }
    
    //按住按钮进行移动
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if dragging {
            for touch in touches {
                let location = touch.locationInView(self)
                if draggingItem != nil {
                    draggingItem?.center = CGPointMake(location.x + pageScrollView.contentOffset.x, location.y >= 0 ? location.y : 0)
                    setupCurrentViewLayoutSettings()
                    let iLocation = itemLocation()
                    let page = iLocation.page
                    let index = iLocation.index
                    let dragItemX = draggingItem!.center.x - pageScrollView.contentOffset.x
                    let drageItemY = draggingItem!.center.y
                    let distanceWidth = itemWidth + paddingX
                    let distanceHeight = itemHeight + paddingY
                    
                    let dragItemColumn = Int(floor(dragItemX / distanceWidth))
                    var dragItemRow = Int(floor(drageItemY / distanceHeight))
                    if dragItemRow < 0 {
                        dragItemRow = 0
                    }
                    var dragIndex = dragItemRow * columnCount + dragItemColumn
                    let currentPageIndex = Int(floor(pageScrollView.contentOffset.x / pageScrollView.frame.size.width))
                    let itemCount = pages.count >= rowCount * columnCount * (page + 1) ? rowCount * columnCount : pages.count - rowCount * columnCount * page
                    if currentPageIndex != page && dragIndex >= itemCount {
                        dragIndex = 0
                    }
                    if index != dragIndex || (dragIndex == 0 && itemCount == 1 && currentPageIndex != page) {
                        if dragIndex < itemCount {
                            pages.removeAtIndex(page * rowCount * columnCount + index)
                            let itemCount2 = pages.count >= rowCount * columnCount * (currentPageIndex + 1) ? rowCount * columnCount : pages.count - rowCount * columnCount * currentPageIndex
                            if dragIndex > itemCount2 {
                                dragIndex = itemCount2
                                pages.insert(draggingItem!, atIndex: currentPageIndex * (rowCount + columnCount) + dragIndex)
                                
                            }else{
                                if iFlag == 1 {
                                    iFlag = 2
                                }
                                pages.insert(draggingItem!, atIndex: currentPageIndex * (rowCount + columnCount) + dragIndex)
                                UIView.animateWithDuration(0.3, animations: { 
                                    [unowned self] in self.layoutItems()
                                })
                            }
                        }
                    }
                    if location.x + pageScrollView.contentOffset.x < pageScrollView.contentOffset.x + 20 {
                        if currentPageIndex > 0 {
                            if movePagesTimer == nil {
                                movePagesTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(LauncherView.movePagesTimer(_:)), userInfo: "left", repeats: false)
                            }
                        }
                    }else if location.x > pageScrollView.frame.size.width - 20 && location.x + pageScrollView.contentOffset.x < pageScrollView.contentSize.width - 20 {
                        if movePagesTimer == nil {
                            movePagesTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(LauncherView.movePagesTimer(_:)), userInfo: "right", repeats: false)
                        }
                    }else{
                        movePagesTimer?.invalidate()
                        movePagesTimer = nil
                    }
                    
                }
                
            }
        }
    }
    
    func movePagesTimer(timer : NSTimer) {
        movePagesTimer = nil
        if let info = timer.userInfo as? String {
            if info == "right" {
                let newX = pageScrollView.contentOffset.x + pageScrollView.frame.size.width
                let currentPageIndex = Int(floor(newX / pageScrollView.frame.size.width))
                pageControl.currentPage = currentPageIndex
                let offset = CGPointMake(newX, 0)
                UIView.animateWithDuration(0.3, animations: { [unowned self] in
                    self.pageScrollView.contentOffset = offset
                    if self.draggingItem != nil {
                        self.draggingItem!.frame = CGRectMake(self.draggingItem!.frame.origin.x + self.pageScrollView.frame.size.width, self.draggingItem!.frame.origin.y, self.draggingItem!.frame.size.width, self.draggingItem!.frame.size.height)
                    }
                })
            }else if info == "left" {
                var currentPageIndex = Int(floor(pageScrollView.contentOffset.x / pageScrollView.frame.size.width))
                currentPageIndex -= 1
                pageControl.currentPage = currentPageIndex
                let newX = pageScrollView.contentOffset.x - pageScrollView.frame.size.width
                let offset = CGPointMake(newX, 0)
                UIView.animateWithDuration(0.3, animations: { 
                    [unowned self] in
                    self.pageScrollView.contentOffset = offset
                    if self.draggingItem != nil {
                        self.draggingItem!.frame = CGRectMake(self.draggingItem!.frame.origin.x - self.draggingItem!.frame.size.width,self.draggingItem!.frame.origin.y, self.draggingItem!.frame.size.width, self.draggingItem!.frame.size.height)
                    }
                })
                
                
            }
        }
    }

}
