//
//  Order+CoreDataProperties.swift
//  
//
//  Created by apple on 16/6/7.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Order {

    @NSManaged var discount_amount: String?
    @NSManaged var ignore_amount: String?
    @NSManaged var ord_no: String?
    @NSManaged var original_amount: String?
    @NSManaged var trade_account: String?
    @NSManaged var trade_amount: String?
    @NSManaged var trade_no: String?
    @NSManaged var trade_result: String?

}
