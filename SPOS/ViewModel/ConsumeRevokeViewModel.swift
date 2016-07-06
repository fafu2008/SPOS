//
//  ConsumeRevoke.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ConsumeRevokeViewModel: BaseViewModel {
    
    /**
     验证主管密码
     * 待处理token过期问题 和 数据处理问题。。。
     - parameter pwd: 主管密码
     */
    func valideManagePWD(pwd : String , callback : (AnyObject? , String?) -> Void) {
        let data : [String : AnyObject] = ["password" : pwd.sha1()]
        let (token , param) = packageParam(data)
        assert(token != nil , "\(#function) : \(#file)")
        let manager = AFNetworkingManager()
        manager.postRequest("superpass/validate?token=\(token!)", postData: param, callback: {[weak self] (data, error) in
            let (value , message) = self!.validParam(data)
            callback(value , message)
        })
    
    }

    /**
     撤销订单
     
     - parameter order:     订单对象
     - parameter shop_pass: 主管密码
     - parameter callback:  回调
     */
    func consumeRevokeByOrder(orderNo : String , shop_pass : String , callback : (AnyObject? , String?) -> Void) {
        
        let orderManager = CDOrder()
        let orders = orderManager.selectObject("Order")
        if let order = orderManager.selectedOrder(orderNo) {
            var data = order.revokeOrderParam()
            data["shop_pass"] = shop_pass.sha1()
            let (token , param) = packageParam(data)
            assert(token != nil , "\(#function) : \(#file)")
            let manager = AFNetworkingManager()
            manager.postRequest("payrefund?token=\(token!)", postData: param) {[weak self] (data, error) in
                let(value , message) = self!.validParam(data)
                callback(value , message)
            }
        }else{
            callback(nil , "订单号不存在或者已退款")
        }
        
        
    }
    
    
}
