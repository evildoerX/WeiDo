//
//  AppDelegate.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit



let WDSwitchRootViewControllerKey = "WDSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//创建视图
    var window: UIWindow?
    
    
   
     let bgColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 1.0)
    
    
    
    func applicationDidEnterBackground(application: UIApplication) {
       
        // 清空过期数据
        StatusDAO.cleanStatuses()
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 打开数据库
        SQLiteManager.shareManager().openDB("status.sqlite")
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: WDSwitchRootViewControllerKey, object: nil)
        
        // 设置导航条和工具条的外观
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UITabBar.appearance().tintColor = bgColor
        UINavigationBar.appearance().barTintColor = bgColor
          UITabBar.appearance().barTintColor = UIColor.whiteColor()
  
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 2.创建根控制器
        window?.rootViewController = defaultContoller()
      
        
        window?.makeKeyAndVisible()
        
      
        
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /**
     选择界面
     
     */
    func switchRootViewController(notify: NSNotification){
        //        print(notify.object)
        if notify.object as! Bool
        {
          //  window?.rootViewController = WDMainViewController()
            window?.rootViewController = WDWelcomeViewController()
        }else
        {
           // window?.rootViewController = WDWelcomeViewController()
            window?.rootViewController = WDMainViewController()

        }
    }
    
    /**
     用于获取默认界面
     
     :returns: 默认界面
     */
    private func defaultContoller() ->UIViewController
    {
        // 1.检测用户是否登录
        if userAccount.userlogin(){
            
            return isNewupdate() ? WDNewfeatureViewController() : WDWelcomeViewController()
        }
        return WDMainViewController()
    }
    
    private func isNewupdate() -> Bool{
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 3.比较当前版本号和以前版本号
        
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 3.1.1存储当前最新的版本号
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
    }
    
}

