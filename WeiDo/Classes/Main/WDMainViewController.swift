//
//  WDMainViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加子控制器
        addChildViewControllers()
      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加加号按钮
        setupComposeBtn()
    }
    
    /**
     监听加号按钮点击
     */
    func composeBtnClick(){
      let composeVc = WDComposeViewController()
        let nav = WDNavigationController(rootViewController: composeVc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: - 添加按钮
    private func setupComposeBtn()
    {
        // 1.添加加号按钮
        tabBar.addSubview(composeBtn)
        
        // 2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect  = CGRect(x: 0, y: 0, width: width, height: 49)
        //        composeBtn.frame = rect
        
        // 第一个参数:是frame的大小
        // 第二个参数:是x方向偏移的大小
        // 第三个参数: 是y方向偏移的大小
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }
    
    /**
     添加所有子控制器
     */
    private func addChildViewControllers() {
        // 1.获取json文件的路径
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        // 2.通过文件路径创建NSData
        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do{
             
                // 3.序列化json数据 --> Array
           
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                // 4.遍历数组, 动态创建控制器和设置数据
        
                for dict in dictArr as! [[String: String]]
                {
                    addChildViewController(dict["vcName"]!, title:dict["title"]!, imageName: dict["imageName"]!)
                    
                    
                }
                
            }catch
            {
                // 发生异常之后会执行的代码
                print(error)
                
                // 从本地创建控制器
                addChildViewController("WDHomeViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("WDMessageController", title: "消息", imageName: "tabbar_message")
                
                // 再添加一个占位控制器
                addChildViewController("WDNullViewController", title: "", imageName: "")
                addChildViewController("WDDiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("WDMineViewController", title: "我", imageName: "tabbar_profile")
                
            }
        }
        
    }
    
    
   

    /**
     初始化子控制器
     
     :param: childController 需要初始化的子控制器
     :param: title           子控制器的标题
     :param: imageName       子控制器的图片
     */
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        // -1.动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        // 将字符串转换为类
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        // 通过类创建对象
        // 将AnyClass转换为指定的类型
       let vcCls = cls as! UIViewController.Type
        // 通过class创建对象
        let vc = vcCls.init()
        
        // 1设置首页对应的数据
        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
      
        // 2.给首页包装一个导航控制器
        let nav = WDNavigationController()
          //设置颜色
        
        nav.addChildViewController(vc)
        
        // 3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
        
    }
    
    
    // MARK: - 懒加载
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        
        // 2.设置前景图片
         btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
       
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        // 3.设置背景图片
       btn.backgroundColor = bgColor
        // 4.添加监听
        btn.addTarget(self, action: #selector(WDMainViewController.composeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}