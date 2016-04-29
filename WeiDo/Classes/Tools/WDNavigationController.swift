//
//  WDNavigationController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/26.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationBar.alpha = 0.5
     
        
        //背景颜色
       UINavigationBar.appearance().barTintColor = bgColor
        
 
        //返回键颜色
        UINavigationBar.appearance().barStyle = UIBarStyle.Default
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
  
        // 标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttribute as? [String: AnyObject]
        
        setGesture()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

   
    /**
     添加手势
     */
    func setGesture()
    {
        
        let pan = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: "handleNavigationTransition:")
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        self.interactivePopGestureRecognizer?.enabled = false
        
    }
    
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0
        {
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backItemImage"), style: .Plain, target: self, action: #selector(WDNavigationController.back))
            
        }
        super.pushViewController(viewController, animated: true)

        
    }
    
    
    func back()
        
    {
        self.popViewControllerAnimated(true)
        
    }
    
    //只有当非根控制器时才返回
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count != 1
    }
}
