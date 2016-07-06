//
//  AppPara+CoreDataProperties.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/28.
//  Copyright © 2016年 张晓飞. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AppPara {

    @NSManaged var app_id: NSNumber?
    @NSManaged var trade_no: String?
    @NSManaged var type: String?
    @NSManaged var amount: NSNumber?
    @NSManaged var discount: NSNumber?
    @NSManaged var remark: String?
    @NSManaged var print: String?
    @NSManaged var pay_shop: NSNumber?
    @NSManaged var order: NSManagedObject?

}
