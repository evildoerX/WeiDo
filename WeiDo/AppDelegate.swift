//
//  AppDelegate.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import CoreLocation


//经度
var lat: Double?
//纬度
var long: Double?
//城市名
var cityname: String?
//具体位置
var currLocationName: String?
//街道位置
var currAddress: String?
//保存获取到的本地位置
var currLocation : CLLocation!

//全局颜色
let bgColor = UIColor(red: 77/255, green: 194/255, blue: 167/255, alpha: 1.0)
let WDSwitchRootViewControllerKey = "WDSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
     var locationManager = CLLocationManager()
    //创建视图
    var window: UIWindow?
    

    
    
    
    func applicationDidEnterBackground(application: UIApplication) {
       
        // 清空过期数据
        StatusDAO.cleanStatuses()
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        // 打开数据库
        SQLiteManager.shareManager().openDB("status.sqlite")
        //注册一个推送
        
        let uns = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(uns)
        // 注册一个通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: WDSwitchRootViewControllerKey, object: nil)
       
        // 设置导航条和工具条的外观

        setupUI()
        
        //开启定位
        loadLocation()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        

        //若是第一次打开应用会进入引导页
        
        if (!(NSUserDefaults.standardUserDefaults().boolForKey("everLaunched")))
        {
         NSUserDefaults.standardUserDefaults().setBool(true, forKey:"everLaunched")
            window?.rootViewController = WDNewfeatureViewController()
        
        }
        
        // 若不是进入主页面
        else{
            window?.rootViewController = defaultContoller()
            
        }
        
        window?.makeKeyAndVisible()
        
      
        
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    
    func setupUI()
    {
       UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        //背景颜色
       UITabBar.appearance().tintColor = bgColor
 
             //字体颜色
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
       
        //背景颜色
        UINavigationBar.appearance().barTintColor = bgColor
           //返回键颜色
        UINavigationBar.appearance().barStyle = UIBarStyle.Default
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        // 标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttribute as? [String: AnyObject]
        
 
    }
    
    
    
    
    /**
     选择界面
     
     */
    func switchRootViewController(notify: NSNotification){
        //        print(notify.object)
        if notify.object as! Bool
        {
            window?.rootViewController = WDMainViewController()
          
        }else
        {
            window?.rootViewController = WDWelcomeViewController()
            

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
    /**
     获取软件是否更新
   
     */
    private func isNewupdate() -> Bool{
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
       
        
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

extension AppDelegate: CLLocationManagerDelegate
{
    
    //打开定位
    func loadLocation()
    {
        
        locationManager.delegate = self
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if(UIDevice.currentDevice().systemVersion >= "8.0"){
            //始终允许访问位置信息
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization()
        }
        //开启定位
        locationManager.startUpdatingLocation()
    }
    
    
    
    //获取定位信息
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //取得locations数组的最后一个
        let location:CLLocation = locations[locations.count-1]
        currLocation = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            lat = Double(String(format: "%.1f", location.coordinate.latitude))
            long = Double(String(format: "%.1f", location.coordinate.longitude))
            print("纬度:\(long!)")
            print("经度:\(lat!)")
            LonLatToCity()
            //停止定位
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    //出现错误
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print(error)
    }

    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).valueForKey("City") as! String
                //国家
        //        let country: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Country") as! NSString
                //国家编码
             //   let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("CountryCode") as! NSString
                //街道位置
                let FormattedAddressLines: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("FormattedAddressLines")?.firstObject as! NSString
                //具体位置
                let Name: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Name") as! NSString
                //省
                var State: String = (mark.addressDictionary! as NSDictionary).valueForKey("State") as! String
                //区
              //  let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("SubLocality") as! NSString
                
           
                //去掉“市”和“省”字眼
               
                State = State.stringByReplacingOccurrencesOfString("省", withString: "")
                let citynameStr = city.stringByReplacingOccurrencesOfString("市", withString: "")
              
                
                //转类型
                var citynamestr =  NSMutableString(string: citynameStr)
                //先转换为带声调的拼音
                CFStringTransform(citynamestr, nil, kCFStringTransformMandarinLatin, false)
                //再转换为不带声调的拼音
                CFStringTransform(citynamestr, nil, kCFStringTransformStripDiacritics, false)
                
               
              //去掉中间的空格
              cityname =  String(citynamestr).stringByReplacingOccurrencesOfString(" ", withString: "")
                
                //保存起来
                currAddress = FormattedAddressLines as String
                currLocationName = Name as String
 
                print(currAddress!)
                print(currLocationName!)
            }
            else
            {
                print(error)
            }
        }
        
       
    }



}
