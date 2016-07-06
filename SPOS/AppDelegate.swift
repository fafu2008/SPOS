//
//  AppDelegate.swift
//  SPOS
//
//  Created by 张晓飞 on 16/1/27.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit
import CoreData

/*
 * 1)国际化后期要完善
 * 2)代码需要重构
 */


//设置个全局变量，纪录当前的网络连接情况
var netActive = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.setStatusBarStyle(.LightContent, animated: false) //状态栏字体颜色
        disposeIsLogined()  //判断是否登录
        monitorNetStatus()  //监听网络
        
        return true
    }
    
    
    //监听网络
    func monitorNetStatus() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    //网络状态变化通知
    func networkStatusChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String : String] {
            let description = userInfo["Status"] ?? ""
            if description.containsString("Online"){
                if description.lowercaseString.containsString("wifi"){
                    hideNetworkStauts()
                }else if description.lowercaseString.containsString("wwan"){
                    hideNetworkStauts()
                }
            }else if description.containsString("Offline"){
                showNetworkStatus("离线状态")
            }else{
                showNetworkStatus("未知网络状态")
            }
        }
        
    }
    
    //显示当前网络状态内容
    func showNetworkStatus(message : String) {
        if !netActive {
            return
        }
        netActive = false
        let options : [NSObject : AnyObject] = [kCRToastTextKey : message ,
                       kCRToastTextAlignmentKey : NSTextAlignment.Center.rawValue,
                       kCRToastBackgroundColorKey : UIColor.redColor(),
                       kCRToastAnimationInTypeKey : CRToastAnimationType.Gravity.rawValue,
                       kCRToastAnimationOutTypeKey : CRToastAnimationType.Gravity.rawValue,
                       kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
                       kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue,
                       kCRToastTimeIntervalKey : DBL_MAX
                       ]
        CRToastManager.showNotificationWithOptions(options) { 
            
        }
    }
    
    //隐藏当前网络状态内容
    func hideNetworkStauts() {
        if !netActive {
            netActive = true
            CRToastManager.dismissNotification(true)
        }
    }
    
    
    //处理是否登录
    func disposeIsLogined() {
        
        let mct_no = NSUserDefaults.standardUserDefaults().objectForKey("mct_no") as? String
        let public_key_path = DefaultKit.filePath("public_key.pem")
        if mct_no != nil && NSFileManager.defaultManager().fileExistsAtPath(public_key_path) {
            if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                app.window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("menu")
                
            }
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

   

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zhangxiaofei.SPOS" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SPOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SPOS.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isEnterBackground")
        NSUserDefaults.standardUserDefaults().synchronize()

    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        var isOpenGestureStr:Int = 10
        var isOpenGesture = false
        isOpenGestureStr = NSUserDefaults.standardUserDefaults().integerForKey("is_open_gesture")
        if(isOpenGestureStr == 1) {
            isOpenGesture = true
        }else{
            isOpenGesture = false
        }
        
        if ((isOpenGesture == true) && NSUserDefaults.standardUserDefaults().boolForKey("isEnterBackground")) {
            let ges = GesturePasswordControllerViewController()
            ges.entryType = 1
            UIApplication.sharedApplication().keyWindow?.addSubview(ges.view)
        }

    }
 
    
    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isEnterBackground")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.saveContext()
    }
    
    /*
    - (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEnterBackground"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    - (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([PasswordAccount isOnWithNeedPassword] && [[NSUserDefaults standardUserDefaults]boolForKey:@"isEnterBackground"]) {
    
    GestureViewController *ges = [[GestureViewController alloc] initWithCaseMode:VerifyMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmhandPwd) name:@"confirmhandPwd" object:nil];
    [PasswordAccount needPasswordIsOn:YES];
    ges.isFormer = YES;
    
    _gestureHand = ges;
    [[UIApplication sharedApplication].keyWindow addSubview:ges.view];
    }
    
    }
    - (void)confirmhandPwd
    {
    [self.gestureHand.view removeFromSuperview];
    }
    - (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isEnterBackground"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    */
    

}

