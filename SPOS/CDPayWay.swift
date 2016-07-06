//
//  CDPayWay.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/12.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class CDPayWay: CoreDataHelper {

    var payWays = [PayWay]()
    
    
    //支付方式的数量
    func payWayCount() -> Int {
        
        let payWayItems = selectObject("PayWay")
        if payWayItems.count > 0 {
            payWays.removeAll()
            payWays = payWayItems as! [PayWay]
            return payWays.count
        }else{
            return payWays.count
        }
        
    }
    
    /**
     获取单个支付方式
     - parameter row: 行数
     - returns: 支付方式
     */
    func payWayWithRow(row : Int) -> PayWay {
        return payWays[row]
    }
   
    
}
