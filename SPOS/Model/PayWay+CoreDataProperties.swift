//
//  PayWay+CoreDataProperties.swift
//  
//
//  Created by apple on 16/6/3.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PayWay {

    @NSManaged var pmt_currency: String?
    @NSManaged var pmt_icon: String?
    @NSManaged var pmt_internal_name: String?
    @NSManaged var pmt_name: String?
    @NSManaged var pmt_split_refund: String?
    @NSManaged var pmt_tag: String?
    @NSManaged var pmt_type: String?
    @NSManaged var pmt_ticket_icon: String?

}
