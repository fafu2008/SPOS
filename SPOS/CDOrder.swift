//
//  CDOrder.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/28.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit
import CoreData

class CDOrder: CoreDataHelper {

    /**
     读取订单信息
     
     - parameter orderNo: 订单号
     
     - returns: 订单
     */
    func selectedOrder(orderNo : String) -> Order? {
        let predicate = NSPredicate(format: "ord_no == %@", orderNo)
        if let orders = selectObject("Order", predicate: predicate) as? [Order] {
            if orders.count > 0 {
                return orders.first
            }
        }
        return nil
    }
    
}
