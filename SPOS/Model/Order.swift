//
//  Order.swift
//  
//
//  Created by apple on 16/6/7.
//
//

import Foundation
import CoreData


class Order: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    /**
     撤销订单
     
     - returns: 退款参数字典
     */
    func revokeOrderParam() -> [String : AnyObject] {
        var data = [String : AnyObject]()
        data["ord_no"] = ord_no!
        data["refund_ord_no"] = DefaultKit.orderNo()
        data["refund_amount"] = trade_amount!
        if trade_account != nil {
            data["trade_account"] = trade_account!
        }
        if trade_no != nil {
            data["trade_no"] = trade_no!
        }
        if trade_result != nil {
            data["trade_result"] = trade_result!
        }
        /*
         if tml_token != nil {
         data["tml_token"] = tml_token!
         }
         if remark != nil {
         data["remark"] = remark!
         }
         */
        
        return data
    }
}
