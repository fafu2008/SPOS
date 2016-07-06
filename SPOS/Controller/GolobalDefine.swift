//
//  GolobalDefine.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation

func TTGLog(message:AnyObject?, function:String = #function){
    #if DEBUG
        print("TTGLog:\(message) --\(function)")
    #else
        
    #endif
}