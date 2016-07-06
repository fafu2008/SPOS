//
//  CoreDataHelper.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/1.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    let appDelegate : AppDelegate
    var context : NSManagedObjectContext?
    
    override init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        super.init()
    }
    
    //单例模式
//    class func sharedInstall() -> CoreDataHelper {
//        struct Static {
//            static var helper : CoreDataHelper? = nil
//            static var token : dispatch_once_t = 0
//        }
//        _dispatch_once(&Static.token) { 
//            Static.helper = CoreDataHelper()
//        }
//        return Static.helper!
//    
//    }
    
    //查询
    func selectObject(tablename : String) -> [AnyObject] {
        
       return selectObject(tablename, predicate: nil)
    }
    
    //查询单个对象
    func selectObject(tablename : String , predicate : NSPredicate?) -> [AnyObject] {
        
        do {
            let request = NSFetchRequest.init()
            let entity = NSEntityDescription.entityForName(tablename, inManagedObjectContext: context!)
            request.entity = entity
            if predicate != nil {
                request.predicate = predicate!
            }
            let entities = try context!.executeFetchRequest(request)
            
            return entities
        } catch {
            return []
        }
        
    }
    
    //删除
    func deleteObject(tablename : String) -> Bool {
        
        do {
            let request = NSFetchRequest.init()
            let entity = NSEntityDescription.entityForName(tablename, inManagedObjectContext: context!)
            request.entity = entity
            
            let entities = try context!.executeFetchRequest(request)
            
            for object in entities {
                context!.deleteObject(object as! NSManagedObject)
            }
            do {
                try context!.save()
                return true
            }catch{
                return false
            }
            
        } catch {
            return false
        }
        
    }
    
    //新增
    func insertObject(tablename : String , dic : [[String : AnyObject]]) -> Bool {
        
        for dicItem in dic {
            let entity = NSEntityDescription.insertNewObjectForEntityForName(tablename, inManagedObjectContext: context!)
            for (key , value) in dicItem {
                entity.setValue(value, forKey: key)
            }
        }
        do {
            try context!.save()
            return true
        }catch{
            return false
        }
    }
    
    //add by yushaopeng for 订单增删
    //新增
    func insertNewOrder(tablename : String , dic : [String : AnyObject]) -> Bool {
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName(tablename, inManagedObjectContext: context!)
        for (key , value) in dic {
            if (key == "ord_no" ||
                key == "trade_amount" ||
                key == "original_amount" ||
                key == "discount_amount" ||
                key == "ignore_amount" ||
                key == "trade_no" ||
                key == "trade_account" ||
                key == "trade_result")
            {
                entity.setValue(value, forKey: key)
            }
        }
        
        do {
            try context!.save()
            return true
        }catch{
            return false
        }
    }
    
    //删除
    func deleteOrder(orderNo : String) -> Bool {
        
        do {
            let request = NSFetchRequest.init()
            let entity = NSEntityDescription.entityForName("Order", inManagedObjectContext: context!)
            request.entity = entity
            request.predicate = NSPredicate(format: "ord_no = %@",orderNo)
            
            let entities = try context!.executeFetchRequest(request)
            
            for object in entities {
                context!.deleteObject(object as! NSManagedObject)
            }
            do {
                try context!.save()
                return true
            }catch{
                return false
            }
            
        } catch {
            return false
        }
        
    }
    
    //end add
    
    //修改
    func updateObject(tablename : String , condition : [String : AnyObject] , dic : [String : AnyObject]) -> Bool {
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(tablename, inManagedObjectContext: context!)
        request.entity = entity
        
        //let predicate = NSPredicate(format: "%K=%@", <#T##args: CVarArgType...##CVarArgType#>)
        
        return false
    }
}
